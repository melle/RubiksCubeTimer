// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation

@Reducer
struct SettingsFeature {
    @Dependency(\.uuid) var uuid
    
    @ObservableState
    struct State: Equatable {
        var movesPerScramble: Int = 18
    }
    
    enum Action {
        case incrementMovesPerScramble
        case decrementMovesPerScramble
        case generateRandomResults
        case addResult(CubeResult)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementMovesPerScramble:
                state.movesPerScramble += 1
            case .decrementMovesPerScramble:
                state.movesPerScramble = min(state.movesPerScramble - 1, 13)
            case .generateRandomResults:
                return .send(.addResult(generateRandomResult()))
            case .addResult(_):
                break
            }
            
            return .none
        }
    }
    
    func generateRandomResult() -> CubeResult {
        .init(
            time: .random(in: 0...120),
            date: Date.init(timeIntervalSinceNow: TimeInterval.random(in: -60*60*24*365...0)),
            scramble: [],
            id: uuid().uuidString)
    }
}
