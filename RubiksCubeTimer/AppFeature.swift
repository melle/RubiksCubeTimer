// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State: Equatable {
        var selectedTab: TimerTab = .timer
        var timer: TimerFeature.State = .init()
        var results: ResultsFeature.State = .init()
        var settings: SettingsFeature.State = .init()
    }
    
    enum Action {

        case timer(TimerFeature.Action)
        case results(ResultsFeature.Action)
        case settings(SettingsFeature.Action)
        case selectTab(TimerTab)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.timer, action: \.timer) {
            TimerFeature()
        }
        Scope(state: \.results, action: \.results) {
            ResultsFeature()
        }
        Scope(state: \.settings, action: \.settings) {
            SettingsFeature()
        }
        Reduce { state, action in
            // Handle AppFeature-specific actions, if any
            switch action {
                
            case .timer(_):
                break
            case .results(_):
                break
            case .settings(_):
                break
            case let .selectTab(newTab):
                state.selectedTab = newTab
            }
            return .none
        }
    }
}
