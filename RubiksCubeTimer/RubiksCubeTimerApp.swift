// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import SwiftUI

@main
struct RubiksCubeTimerApp: App {
    var body: some Scene {
        WindowGroup {
            AppMainView(
                store: Store(initialState: AppFeature.State()) {
                    AppFeature()
                }
            )
        }
    }
}
