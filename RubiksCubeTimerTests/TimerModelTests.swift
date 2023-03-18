// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

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
        // Week 46 - no results
        
        // November 22./23./24. = Week 48
        CubeResult(time: 40, date: Date(timeIntervalSince1970: 1669157131), scramble: [], id: "7"),
        CubeResult(time: 39, date: Date(timeIntervalSince1970: 1669243531), scramble: [], id: "8"),
        CubeResult(time: 38, date: Date(timeIntervalSince1970: 1669329931), scramble: [], id: "9"),
    ]
    
    func testAverage() throws {
        let sut = TimerModel()
        sut.results = testResults
        
        XCTAssertEqual(sut.averageOverallString, "40.333")
    }
    
    func testGroupByWeekq() throws {
        let sut = TimerModel()
        sut.results = testResults
        
        let expected: [GroupedCubeResult] = [
            GroupedCubeResult(key: "2022 - 45",
                              results: [
                                CubeResult(time: 44, date: Date(timeIntervalSince1970: 1667335531), scramble: [], id: "1"),
                                CubeResult(time: 42, date: Date(timeIntervalSince1970: 1667421931), scramble: [], id: "2"),
                                CubeResult(time: 40, date: Date(timeIntervalSince1970: 1667508331), scramble: [], id: "3")
                              ]),
            GroupedCubeResult(key: "2022 - 46",
                              results: [
                                CubeResult(time: 42, date: Date(timeIntervalSince1970: 1667940331), scramble: [], id: "4"),
                                CubeResult(time: 40, date: Date(timeIntervalSince1970: 1668026731), scramble: [], id: "5"),
                                CubeResult(time: 38, date: Date(timeIntervalSince1970: 1668113131), scramble: [], id: "6")
                              ]),
            GroupedCubeResult(key: "2022 - 48",
                              results: [
                                CubeResult(time: 40, date: Date(timeIntervalSince1970: 1669157131), scramble: [], id: "7"),
                                CubeResult(time: 39, date: Date(timeIntervalSince1970: 1669243531), scramble: [], id: "8"),
                                CubeResult(time: 38, date: Date(timeIntervalSince1970: 1669329931), scramble: [], id: "9")
                              ])
        ]
        XCTAssertEqual(expected, sut.resultsByWeek)
    }
}
