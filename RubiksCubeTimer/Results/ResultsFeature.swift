// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
struct ResultsFeature {
    @Dependency(\.jsonCoderProvider) var jsonCoderProvider
    @Dependency(\.dateFormatterProvider) var dateFormatterProvider
    
    @ObservableState
    struct State: Equatable {
        var results: [CubeResult] = []
    }
    
    enum Action {
        case loadResults
        case saveResults
        case addResult(CubeResult)
        case deleteResult(indexes: IndexSet)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadResults:
                state.results = loadResults()
                return .none
            case .saveResults:
                saveResults(results: state.results)
            case let .addResult(result):
                state.results.append(result)
                saveResults(results: state.results)
                return .none
            case .deleteResult(indexes: let indexes):
                state.results.remove(atOffsets: indexes)
                saveResults(results: state.results)
                return .none
            }
            return .none
        }
    }
}

extension ResultsFeature.State {

    var dependencies: DependencyValues {
        @Dependency(\.self) var dependencies
        return dependencies
    }

    var averageOverall: TimeInterval? {
        guard results.count > 0 else { return nil }
        
        let time: TimeInterval = results.map({ $0.time }).reduce(0, +) / Double(results.count)
        return time
    }
    
    var averageOverallString: String {
        guard let time = averageOverall else { return "" }
        return String(format: "Average: %.3f seconds", time)
    }
    
    
    var resultsByWeek: [GroupedCubeResult] {
        let formatter = dependencies.dateFormatterProvider.resultsFormatter
        
        return Dictionary(grouping: results) {
            return formatter().string(from: $0.date)
        }
        .map { (key: String, value: [CubeResult]) in
            GroupedCubeResult(key: key, results: value.sorted(by: { $0.date > $1.date }))
        }
        .sorted { lhs, rhs in
            lhs.key > rhs.key
        }
    }
}

extension ResultsFeature {
    
    func saveResults(results: [CubeResult]) {
        guard let blob = try? jsonCoderProvider.encoder().encode(results) else {
            os_log(.error, "Could not encode results: \(results)")
            return
        }
        do {
            try blob.write(to: resultsURL)
        }
        catch {
            os_log(.error, "\(error.localizedDescription)")
        }
    }
    
    func loadResults() -> [CubeResult] {
        var results: [CubeResult]
        do {
            let blob = try Data(contentsOf: resultsURL)
            let loadedResults: [CubeResult] = try jsonCoderProvider.decoder().decode([CubeResult].self, from: blob)
            results = loadedResults
        }
        catch {
            os_log(.error, "\(error.localizedDescription)")
            results = []
        }
        return results
    }
        
    private var resultsURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent("cubeResults.json")
    }
}
