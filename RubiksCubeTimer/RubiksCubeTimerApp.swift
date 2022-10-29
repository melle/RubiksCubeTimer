// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

@main
struct RubiksCubeTimerApp: App {
    let model = TimerModel()
    var body: some Scene {
        WindowGroup {
            CubeTabsView(model: model)
        }
    }
}
