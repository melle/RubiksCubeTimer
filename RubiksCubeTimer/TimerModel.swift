// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import Foundation
import SwiftUI

enum TimerState {
    case idle
    case ready
    case running
    case finished
}

struct CubeResult: Identifiable, Hashable {

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

class TimerModel {
    var timerState: TimerState = .idle
    var buttonPressed: Bool = false
    var startTime: Date = .now
    var endTime: Date = .now
    var clockFormatter = DateFormatter()
    var scramble: [CubeMoves] = []
    var results: [CubeResult] = []

    init() {
        self.timerState = .idle
        self.buttonPressed = false
        self.startTime = .now
        self.endTime = .now
        clockFormatter.dateFormat = "HH:mm:ss.SSS"
        clockFormatter.timeZone = TimeZone(identifier: "GMT")
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
    
    var movesText: String {
        if scramble.count <= 0 || timerState != .idle {
            return ""
        }
        
        return CubeMoves.string(from: scramble)
    }
    
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
            saveResult()
        }
    }
    
    func saveResult() {
        let result = CubeResult(time: endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970,
                                date: Date.now,
                                scramble: scramble)
        results.append(result)
        print("Results: \(results.map({ res in res.date }))")
    }
}
