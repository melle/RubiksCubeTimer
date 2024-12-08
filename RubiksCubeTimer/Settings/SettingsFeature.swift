// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture

@Reducer
struct SettingsFeature {
 
    @ObservableState
    struct State: Equatable {
        var movesPerScramble: Int = 18
    }
    
    enum Action {
        case incrementMovesPerScramble
        case decrementMovesPerScramble
        case generateRandomResults
    }
 
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .incrementMovesPerScramble:
                state.movesPerScramble += 1
            case .decrementMovesPerScramble:
                state.movesPerScramble -= 1
            case .generateRandomResults:
                break
            }
            return .none
        }
    }
}
