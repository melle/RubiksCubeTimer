// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation
import SwiftUI

struct AppMainView: View {
    var store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationView {
            TabView(selection: .init(
                get: { store.selectedTab},
                set: { store.send(.selectTab($0)) })
            ) {
                TimerView(store: store.scope(state: \.timer, action: \.timer))
                    .tabItem { Label("Timer", systemImage: "stopwatch.fill") }
                    .tag(TimerTab.timer)
                
                ResultsView(store: store.scope(state: \.results, action: \.results))
                    .tabItem { Label("Results", systemImage: "chart.line.uptrend.xyaxis") }
                    .tag(TimerTab.results)
                
                SettingsView(store: store.scope(state: \.settings, action: \.settings))
                    .tabItem { Label("Settings", systemImage: "gear") }
                    .tag(TimerTab.settings)
            }
            .navigationTitle(store.selectedTab.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            //            .toolbar {
            //                ToolbarItem(placement: .primaryAction) {
            //                    PuzzlePicker(
            //                        categories: model.availablePuzzles,
            //                        selectedCategory: $model.selectedPuzzle
            //                    )
            //                }
            //            }
        }
        .onAppear() {
            store.send(.results(.loadResults))
        }
        //        .onAppear {
        //            // correct the transparency bug for Tab bars
        //            let tabBarAppearance = UITabBarAppearance()
        //            tabBarAppearance.configureWithDefaultBackground()
        //            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        //        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        AppMainView(store: Store(initialState: AppFeature.State(), reducer: {
            AppFeature()
        }))
    }
}
