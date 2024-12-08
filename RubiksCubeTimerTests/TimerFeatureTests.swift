// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import Foundation
import Testing
import ComposableArchitecture
@testable import RubiksCubeTimer

extension DateProvider {
    public static let testValue = Self(
        // FIXME: use swift-clocks
        startDate: Date.init(timeIntervalSince1970: 0),
        stopDate: Date.init(timeIntervalSince1970: 10)
    )
}

struct TimerFeatureTests {
    

    @Test
    func testTimerFromIdleToFinished() async throws {
        let store = await TestStore(initialState: TimerFeature.State()) {
            TimerFeature()
        } withDependencies: {
            $0.dateProvider = .testValue
        }

        await store.send(.stopwatchTouched) {
            $0.stopwatch = .ready
        }

        await store.send(.stopwatchTouchReleased) {
            $0.stopwatch = .running(started: Date.init(timeIntervalSince1970: 0))
        }

        await store.send(.stopwatchTouched) {
            $0.stopwatch = .finished(measured: 10.0)
        }
    }

}
