// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import Foundation
import SwiftUI


enum TimerMode: String {
    case timer = "Timer"
    case manualEntry = "Manual Entry"
}

enum PuzzleCategory: String, CaseIterable {
    case cube2x2 = "2 x 2"
    case cube3x3 = "3 x 3"
    case cube4x4 = "4 x 4"
    case cube5x5 = "5 x 5"
    case cube6x6 = "6 x 6"
    case cube7x7 = "7 x 7"
    case cube3x3onehanded = "3 x 3 One-handed"
    case cube3x3blindfolded = "3 x 3 Blindfolded"
    case cube4x4blindfolded = "4 x 4 Blindfolded"
    case cube5x5blindfolded = "5 x 5 Blindfolded"
    case megaminx = "Megaminx"
    case pyraminx = "Pyraminx"
    case skewb = "Skewb"
    case square1 = "Square-1"
    case clock = "Clock"
}

struct CubeResult: Identifiable, Hashable, Codable {

    internal init(time: TimeInterval, date: Date, scramble: [CubeMoves], id: String = UUID().uuidString) {
        self.time = time
        self.date = date
        self.scramble = scramble
        self.id = id
    }
    
    let time: TimeInterval
    let date: Date
    let scramble: [CubeMoves]
    let id: String
}

struct GroupedCubeResult: Hashable, Identifiable {
    let key: String
    let results: [CubeResult]
    
    var id: String {
        return key
    }
}

@available(*, deprecated, message: "Use TimerFeature instead.")
class TimerModel: ObservableObject {
    @Published var timerState: TimerFeature.StopwatchState = .idle
    var buttonPressed: Bool = false
    var startTime: Date = .now
    var endTime: Date = .now
    var manualTime: String = ""
    @Published var timerMode: TimerMode = .timer
    @Published var selectedPuzzle: PuzzleCategory = .cube3x3
    var availablePuzzles: [PuzzleCategory] = PuzzleCategory.allCases
    let clockFormatter = DateFormatter()
    let resultDateFormatter = DateFormatter()
    let resultByWeekFormatter = DateFormatter()
    
    var movesPerScramble: UInt = 13 
    
    @Published var scramble: [CubeMoves] = []
    @Published var results: [CubeResult] = []
    
    init() {
        self.timerState = .idle
        self.buttonPressed = false
        self.startTime = .now
        self.endTime = .now
        
        clockFormatter.dateFormat = "HH:mm:ss.SSS"
        clockFormatter.timeZone = TimeZone(identifier: "GMT")
        
        resultDateFormatter.dateStyle = .short
        resultDateFormatter.timeStyle = .short
        resultDateFormatter.locale = Locale.current

        resultByWeekFormatter.dateFormat = "Y - w"
        movesPerScramble = UInt(UserDefaults.standard.integer(forKey: "movesPerScramble"))
        if movesPerScramble < 13 {
            movesPerScramble = 13
        }

        scramble = CubeMoves.randomMoves(movesPerScramble)
        
        loadResults()
    }
    
    var buttonColor: Color {
        switch timerMode {
        case .manualEntry:
            return Color.gray
        case .timer:
            switch timerState {
            case .idle: return Color.gray
            case .ready: return Color.green
            case .running: return Color.red
            case .finished: return Color.red
            }
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
            return " \n "
        }
        
        return CubeMoves.string(from: scramble)
    }
}

extension TimerModel {
    
    func newScramle() {
        scramble = CubeMoves.randomMoves(movesPerScramble)
    }
        
    func incrementMovesPerScramble() {
        if movesPerScramble < 18 {
            movesPerScramble += 1
            UserDefaults.standard.set(movesPerScramble, forKey: "movesPerScramble")
            scramble = CubeMoves.randomMoves(movesPerScramble)
        }
        objectWillChange.send()
    }

    func decrementMovesPerScramble() {
        if movesPerScramble > 13 {
            movesPerScramble -= 1
            UserDefaults.standard.set(movesPerScramble, forKey: "movesPerScramble")
            scramble = CubeMoves.randomMoves(movesPerScramble)
        }
        objectWillChange.send()
    }
    
    func generateRandomResults() {
        results.append(.init(time: .random(in: 0...120),
                             date: Date.init(timeIntervalSinceNow: TimeInterval.random(in: 0...60*60*24*365)) ,
                             scramble: []))
        objectWillChange.send()
    }
}

extension TimerModel {
    
    var averageOverall: TimeInterval? {
        guard results.count > 0 else { return nil }
        
        let time: TimeInterval = results.map({ $0.time }).reduce(0, +) / Double(results.count)
        return time
    }
    
    var averageOverallString: String {
        guard let time = averageOverall else { return "" }
        return String(format: "%.3f", time)
    }
    
    var resultsByWeek: Array<GroupedCubeResult> {
        Dictionary(grouping: results) {
            return resultByWeekFormatter.string(from: $0.date)            
        }
        .map { (key: String, value: [CubeResult]) in
            GroupedCubeResult(key: key, results: value)
        }
        .sorted { lhs, rhs in
            lhs.key < rhs.key
        }
    }
}

extension TimerModel {
    
    func handleButtonPress() {
        guard buttonPressed == false else { return }
        buttonPressed = true

        switch timerState {
        case .idle:
            timerState = .ready
            scramble = CubeMoves.randomMoves(movesPerScramble)
        case .ready:
            timerState = .ready
        case .running:
            timerState = .finished
            endTime = .now
        case .finished:
            timerState = .idle
            scramble = CubeMoves.randomMoves(movesPerScramble)
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
    
    func deleteResult(indexes: IndexSet) {
        results.remove(atOffsets: indexes)
        objectWillChange.send()
        saveResults()
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
    }
}
