// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import XCTest
@testable import RubiksCubeTimer

final class TimerModelTests: XCTestCase {

    var testResults: [CubeResult] = [
        // November 1./2./3. = Week 45
        CubeResult(time: 44, date: Date(timeIntervalSince1970: 1667335531), scramble: [], id: "1"),
        CubeResult(time: 42, date: Date(timeIntervalSince1970: 1667421931), scramble: [], id: "2"),
        CubeResult(time: 40, date: Date(timeIntervalSince1970: 1667508331), scramble: [], id: "3"),
        // November 8./9./10. = Week 46
        CubeResult(time: 42, date: Date(timeIntervalSince1970: 1667940331), scramble: [], id: "4"),
        CubeResult(time: 40, date: Date(timeIntervalSince1970: 1668026731), scramble: [], id: "5"),
        CubeResult(time: 38, date: Date(timeIntervalSince1970: 1668113131), scramble: [], id: "6"),
        // Week 47 - no results
        
        // November 22./23./24. = Week 48
        CubeResult(time: 40, date: Date(timeIntervalSince1970: 1669157131), scramble: [], id: "7"),
        CubeResult(time: 39, date: Date(timeIntervalSince1970: 1669243531), scramble: [], id: "8"),
        CubeResult(time: 38, date: Date(timeIntervalSince1970: 1669329931), scramble: [], id: "9"),
    ]
    
    func testAverage() throws {
        let store = TestStore(initialState: ResultsFeature.State(results: testResults)) {
            ResultsFeature()
        }
        
        XCTAssertEqual(store.state.averageOverallString, "Average: 40.333 seconds")
    }
    
    func testEmptyAverage() throws {
        let store = TestStore(initialState: ResultsFeature.State(results: [])) {
            ResultsFeature()
        }
        
        XCTAssertEqual(store.state.averageOverallString, "")
    }
    
    @MainActor
    func testGroupByWeek() async throws {
        let store = TestStore(initialState: ResultsFeature.State(results: testResults), reducer: {
            ResultsFeature()
        }, withDependencies: { dependencies in
            dependencies.dateFormatterProvider = .testValue
        })

        let expected: [GroupedCubeResult] = [
            GroupedCubeResult(
                key: "2022 - 47",
                results: [
                    CubeResult(time: 38.0, date: Date(timeIntervalSince1970: 1669329931), scramble: [], id: "9"),
                    CubeResult(time: 39.0, date: Date(timeIntervalSince1970: 1669243531), scramble: [], id: "8"),
                    CubeResult(time: 40.0, date: Date(timeIntervalSince1970: 1669157131), scramble: [], id: "7")
                ]
            ),
            GroupedCubeResult(
                key: "2022 - 45",
                results: [
                    CubeResult(time: 38.0, date: Date(timeIntervalSince1970: 1668113131), scramble: [], id: "6"),
                    CubeResult(time: 40.0, date: Date(timeIntervalSince1970: 1668026731), scramble: [], id: "5"),
                    CubeResult(time: 42.0, date: Date(timeIntervalSince1970: 1667940331), scramble: [], id: "4")
                ]
            ),
            GroupedCubeResult(
                key: "2022 - 44",
                results: [
                    CubeResult(time: 40.0, date: Date(timeIntervalSince1970: 1667508331), scramble: [], id: "3"),
                    CubeResult(time: 42.0, date: Date(timeIntervalSince1970: 1667421931), scramble: [], id: "2"),
                    CubeResult(time: 44.0, date: Date(timeIntervalSince1970: 1667335531), scramble: [], id: "1")
                ]
            )
        ]
        
        XCTAssertEqual(store.state.resultsByWeek, expected)
    }
}
