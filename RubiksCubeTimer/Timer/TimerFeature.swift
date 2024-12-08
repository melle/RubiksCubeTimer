// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct TimerFeature: Sendable {
    @Dependency(\.dateProvider) var dateProvider
    
    enum StopwatchState: Equatable, Hashable {
        /// The App is ready to stop the time
        case idle
        /// The user has it's hand on the screen, ready to solve the puzzle
        case ready
        /// The user is solving the puzzle
        case running(started: Date)
        /// The user solved the puzzle
        case finished(measured: TimeInterval)
    }
    
    @ObservableState
    public struct State: Equatable, Sendable {
        var stopwatch: StopwatchState = .idle
        var buttonText: String = ""
        var movesText: String = ""
        var buttonColor: Color = .gray
    }
    
    public enum Action {
        /// TouchDown on the stopwatch view
        case stopwatchTouched
        /// TouchUpInside on the stopwatch view
        case stopwatchTouchReleased
        /// The motion sensor detected a bump (i.e. when a solved cube hits the desk or the user taps the screen).
        case bumpEvent
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .stopwatchTouched:
                switch state.stopwatch {
                case .idle:
                    state.stopwatch = .ready
                case .ready:
                    state.stopwatch = .running(started: dateProvider.startDate)
                case let .running(started: startDate):
                    let duration = dateProvider.stopDate.timeIntervalSince(startDate)
                    state.stopwatch = .finished(measured: duration)
                case .finished(measured: _):
                    // FIXME: report time
                    state.stopwatch = .idle
                }
                return .none

            case .stopwatchTouchReleased:
                state.stopwatch = .running(started: dateProvider.startDate)
                return .none

            case .bumpEvent:
                guard case let .running(started: startDate) = state.stopwatch else {
                    return .none
                }
                
                let duration = dateProvider.stopDate.timeIntervalSince(startDate)
                state.stopwatch = .finished(measured: duration)
                return .none
            }
        }
    }
}
