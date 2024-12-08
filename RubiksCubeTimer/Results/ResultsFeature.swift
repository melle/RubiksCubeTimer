// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation

@Reducer
struct ResultsFeature {
    
    @ObservableState
    struct State: Equatable {
        var averageOverallString: String = ""
        var resultsByWeek: [GroupedCubeResult] = []
    }
    
    enum Action {
        case deleteResult(indexes: IndexSet)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}
