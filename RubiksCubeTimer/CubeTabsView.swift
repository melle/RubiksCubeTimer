// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct CubeTabsView: View {
    let model: TimerModel

    var body: some View {
        TabView {
            TimerView(model: model)
                .tabItem {
                    Label("Timer", systemImage: "stopwatch.fill")
                }
            
            ResultsView(model: model)
                .id(model.results)
                .tabItem {
                    Label("Results", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView(model: model)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        CubeTabsView(model: TimerModel())
    }
}
