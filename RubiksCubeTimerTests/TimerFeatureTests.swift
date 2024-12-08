// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import Foundation
import Testing
import ComposableArchitecture
@testable import RubiksCubeTimer

extension DateProvider {
    public static let testValue = Self(
        // FIXME: use swift-clocks
        startDate: { Date.init(timeIntervalSince1970: 0) },
        stopDate: { Date.init(timeIntervalSince1970: 10) }
    )
}

struct TimerFeatureTests {
    
    @Test
    func testTimerFromIdleToFinished() async throws {
        let mainQueue = DispatchQueue.test
        let store = await TestStore(initialState: TimerFeature.State()) {
            TimerFeature()
        } withDependencies: {
            $0.dateProvider = .testValue
            $0.mainQueue = mainQueue.eraseToAnyScheduler()
        }

        await store.send(.stopwatchTouched) {
            $0.stopwatch = .ready
        }
        await store.receive(.internal(.updateTimerText)) {
            $0.buttonText = "READY"
        }

        await store.send(.stopwatchTouchReleased) {
            $0.stopwatch = .running
            $0.startDate = Date.init(timeIntervalSince1970: 0)
        }

        await store.receive(.internal(.startTimer))

        await mainQueue.advance(by: .milliseconds(16))
        
        await store.receive(.internal(.updateTimerText)) {
            $0.buttonText = "00:00:10.000"
            $0.duration = 10.0
        }

        await store.send(.stopwatchTouched) {
            $0.stopwatch = .finished
        }

        await store.receive(.internal(.stopTimer))

        await store.receive(.internal(.updateTimerText))

        await store.finish()
    }

}
