// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import Foundation
import SwiftUI

enum TimerState: Hashable {
    case idle
    case ready
    case running
    case finished
}

struct CubeResult: Identifiable, Hashable, Codable {

    internal init(time: TimeInterval, date: Date, scramble: [CubeMoves]) {
        self.time = time
        self.date = date
        self.scramble = scramble
        self.id = UUID()
    }
    
    let time: TimeInterval
    let date: Date
    let scramble: [CubeMoves]
    let id: UUID
}

class TimerModel: ObservableObject {
    var timerState: TimerState = .idle
    var buttonPressed: Bool = false
    var startTime: Date = .now
    var endTime: Date = .now
    let clockFormatter = DateFormatter()
    let resultDateFormatter = DateFormatter()
    
    var scramble: [CubeMoves] = CubeMoves.randomMoves
    var results: [CubeResult] = []
    
    init() {
        self.timerState = .idle
        self.buttonPressed = false
        self.startTime = .now
        self.endTime = .now
        
        clockFormatter.dateFormat = "HH:mm:ss.SSS"
        clockFormatter.timeZone = TimeZone(identifier: "GMT")
        
        resultDateFormatter.dateStyle = .medium
        resultDateFormatter.timeStyle = .medium
        resultDateFormatter.locale = Locale.current

        loadResults()
    }
    
    var buttonColor: Color {
        switch timerState {
        case .idle: return Color.gray
        case .ready: return Color.green
        case .running: return Color.red
        case .finished: return Color.red
        }
    }
    
    var buttonText: String {
        
        switch timerState {
        case .idle: return "START"
        case .ready: return "READY"
        case .running:
            let duraction = Date.now.timeIntervalSince1970 - startTime.timeIntervalSince1970
            let date = Date(timeIntervalSince1970: duraction)
            return clockFormatter.string(from: date)
        case .finished:
            let duraction = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            let date = Date(timeIntervalSince1970: duraction)
            return clockFormatter.string(from: date)
        }
    }

    func resultTimeFormatted(from result: CubeResult) -> String {
        let date = Date(timeIntervalSince1970: result.time)
        return clockFormatter.string(from: date)
    }

    var movesText: String {
        if scramble.count <= 0 || timerState != .idle {
            return ""
        }
        
        return CubeMoves.string(from: scramble)
    }
}

extension TimerModel {
    
    func handleButtonPress() {
        guard buttonPressed == false else { return }
        buttonPressed = true

        switch timerState {
        case .idle:
            timerState = .ready
            scramble = CubeMoves.randomMoves
        case .ready:
            timerState = .ready
        case .running:
            timerState = .finished
            endTime = .now
        case .finished:
            timerState = .idle
            scramble = CubeMoves.randomMoves
        }
        objectWillChange.send()
    }
    
    func handleButtonRelease() {
        guard buttonPressed == true else { return }
        buttonPressed = false
        
        switch timerState {
        case .idle: timerState = .idle
        case .ready:
            timerState = .running
            startTime = .now
        case .running:
            timerState = .running
        case .finished:
            timerState = .finished
            appendResult()
            saveResults()
        }
        objectWillChange.send()
    }
    
    func saveResults() {
        guard let blob = try? JSONEncoder().encode(results) else {
            print("\(#file):\(#line)")
            return
        }
        do {
            try blob.write(to: resultsURL)
        }
        catch {
            print("\(#file):\(#line) \(error)")
        }
    }
    
    func loadResults() {
        do {
            let blob = try Data(contentsOf: resultsURL)
            let loadedResults: [CubeResult] = try JSONDecoder().decode([CubeResult].self, from: blob)
            results = loadedResults
        }
        catch {
            print("\(#file):\(#line) \(error)")
            results = []
        }
    }
    
    private var resultsURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let resultsPath = documentsDirectory.appendingPathComponent("cubeResults.json")
        return resultsPath
    }
    
    private func appendResult() {
        let result = CubeResult(time: endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970,
                                date: Date.now,
                                scramble: scramble)
        results.append(result)
        print("Results: \n\(results.map({ res in "\(res.date) - \(res.time)"  }).joined(separator: "\n"))")
    }
}
