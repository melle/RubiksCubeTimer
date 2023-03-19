// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import Foundation
import SwiftUI

struct CubeTabsView: View {
    @ObservedObject var model: TimerModel

    var body: some View {
        NavigationView {
            TabView {
                TimerView(model: model)
                    .tabItem {
                        Label("Timer", systemImage: "stopwatch.fill")
                    }
                    .navigationTitle("Settings")

                ResultsView(model: model)
                    .tabItem {
                        Label("Results", systemImage: "chart.line.uptrend.xyaxis")
                    }

                SettingsView(model: model)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .navigationTitle(model.selectedPuzzle.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    PuzzlePicker(
                        categories: model.availablePuzzles,
                        selectedCategory: $model.selectedPuzzle
                    )
                }
            }
        }
        .onAppear {
            // correct the transparency bug for Tab bars
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        CubeTabsView(model: TimerModel())
    }
}
