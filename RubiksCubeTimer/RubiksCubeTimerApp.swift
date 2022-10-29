// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

@main
struct RubiksCubeTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: TimerModel())
        }
    }
}
