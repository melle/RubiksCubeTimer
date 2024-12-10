// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct TimerFeature: Sendable {
    @Dependency(\.dateProvider) var dateProvider
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.withRandomNumberGenerator) var withRandomNumberGenerator

    enum StopwatchState: Equatable, Hashable {
        /// The App is ready to stop the time
        case idle
        /// The user has it's hand on the screen, ready to solve the puzzle
        case ready
        /// The user is solving the puzzle
        case running
        /// The user solved the puzzle
        case finished
    }
    
    
    @ObservableState
    public struct State: Equatable, Sendable {
        var stopwatch: StopwatchState = .idle
        var startDate: Date?
        var duration: TimeInterval = 0
        
        var scramble: [CubeMoves] = []
        
        var buttonText: String = "START"
        
        var movesText: String {
            CubeMoves.string(from: scramble)
        }
    }

    public enum Action: Equatable {
        /// TouchDown on the stopwatch view
        case stopwatchTouched
        /// TouchUpInside on the stopwatch view
        case stopwatchTouchReleased
        /// The motion sensor detected a bump (i.e. when a solved cube hits the desk or the user taps the screen).
        case bumpEvent
        /// Create a new Scramble for the current puzzle
        case newScramble

        case `internal`(Internal)
        
        public enum Internal: Equatable {
            case startTimer
            case stopTimer
            /// Update the timer text during the solving phase
            case updateTimerText
        }
    }
    
    struct CancellableTimerID: Hashable, Sendable {}
    static let timerID = CancellableTimerID()
    
    public var body: some ReducerOf<Self> {
        
        Reduce { state, action in
            print(action)
            switch action {
            case .stopwatchTouched:
                switch state.stopwatch {
                case .idle:
                    state.stopwatch = .ready
                    return .send(.internal(.updateTimerText))
                case .ready:
                    // FIXME: test tapping with the second finger?
                    assertionFailure("It should be impossible to receive a touch in the ready state")
                    state.stopwatch = .running
                    state.startDate = dateProvider.startDate()
                    return .send(.internal(.startTimer))
                case .running:
                    if let startDate = state.startDate {
                        state.duration = dateProvider.stopDate().timeIntervalSince(startDate)
                    }
                    state.stopwatch = .finished
                    return .send(.internal(.stopTimer))
                case .finished:
                    // FIXME: report time
                    state.stopwatch = .idle
                    return .concatenate(
                        .send(.internal(.updateTimerText)),
                        .send(.newScramble)
                    )
                }
                
            case .stopwatchTouchReleased:
                switch state.stopwatch {
                case .ready:
                    state.stopwatch = .running
                    state.startDate = dateProvider.startDate()
                    return .send(.internal(.startTimer))
                default:
                    break
                }
                
            case .bumpEvent:
                guard case .running = state.stopwatch else {
                    return .none
                }
                
                if let startDate = state.startDate {
                    state.duration = dateProvider.stopDate().timeIntervalSince(startDate)
                }
                state.stopwatch = .finished
                
            case .newScramble:
                state.scramble = newScramble()

            case .internal(.startTimer):
                return .run(operation: { send in
                    // publish 30 times per second the .updateTimerText action
                    let timer = mainQueue.timer(interval: .milliseconds(32))
                    
                    for await _ in timer {
                        await send(Action.internal(.updateTimerText))
                    }
                })
                .cancellable(id: TimerFeature.timerID)

            case .internal(.stopTimer):
                return .concatenate(
                    .cancel(id: TimerFeature.timerID),
                    .send(.internal(.updateTimerText))
                )
                
            case .internal(.updateTimerText):
                switch state.stopwatch {
                case .idle:
                    state.buttonText = "START"
                case .ready:
                    state.buttonText = "READY"
                case .running, .finished:
                    if let startDate = state.startDate {
                        state.duration = dateProvider.stopDate().timeIntervalSince(startDate)
                    }
                    state.buttonText = formatTimeInterval(state.duration)
                }
            }
            return .none
        }
    }
    
    /// DateFormatter is too expensive in a loop, instead we format the time manually.
    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let totalMilliseconds = Int(interval * 1000)
        let hours = totalMilliseconds / (60 * 60 * 1000)
        let minutes = (totalMilliseconds / (60 * 1000)) % 60
        let seconds = (totalMilliseconds / 1000) % 60
        let milliseconds = totalMilliseconds % 1000
        
        return String(format: "%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
    }
    
    
    func newScramble() -> [CubeMoves] {
        withRandomNumberGenerator { randomNumberGenerator in
            var rng: any RandomNumberGenerator = randomNumberGenerator
            return CubeMoves.randomMoves(18, rng: &rng)
        }
    }
}

extension TimerFeature.State {

    var buttonColor: Color {
        switch stopwatch {
        case .idle:
            return .gray
        case .ready:
            return .yellow
        case .running:
            return .red
        case .finished:
            return .green
        }
    }
}

