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
        var resultsByWeek: [GroupedCubeResult] = []
    }
    
    enum Action {
        case loadResults
        case saveResults
        case addResult(CubeResult)
        case deleteResult(indexes: IndexSet)
        
        case `internal`(Internal)
        
        enum Internal {
            case recalculateGrouping
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadResults:
                state.results = loadResults()
                return .send(.internal(.recalculateGrouping))
            case .saveResults:
                saveResults(results: state.results)
            case let .addResult(result):
                state.results.append(result)
                saveResults(results: state.results)
                return .send(.internal(.recalculateGrouping))
            case .deleteResult(indexes: let indexes):
                state.results.remove(atOffsets: indexes)
                saveResults(results: state.results)
                return .send(.internal(.recalculateGrouping))
            case let .internal(internalAction):
                switch internalAction {
                case .recalculateGrouping:
                    state.resultsByWeek = resultsByWeek(results: state.results, formatter: dateFormatterProvider.resultsFormatter())
                }
            }
            return .none
        }
    }
}

extension ResultsFeature.State {
    
    var averageOverall: TimeInterval? {
        guard results.count > 0 else { return nil }
        
        let time: TimeInterval = results.map({ $0.time }).reduce(0, +) / Double(results.count)
        return time
    }
    
    var averageOverallString: String {
        guard let time = averageOverall else { return "" }
        return String(format: "%.3f", time)
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

    func resultsByWeek(results: [CubeResult], formatter: DateFormatter) -> [GroupedCubeResult] {
        Dictionary(grouping: results) {
            
            return formatter.string(from: $0.date)
        }
        .map { (key: String, value: [CubeResult]) in
            GroupedCubeResult(key: key, results: value)
        }
        .sorted { lhs, rhs in
            lhs.key < rhs.key
        }
    }

}
