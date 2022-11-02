// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import XCTest
@testable import RubiksCubeTimer

final class TimerModelTests: XCTestCase {

    var testResults: [CubeResult] = [
        // November 1./2./3. = Week 44
        CubeResult(time: 44, date: Date(timeIntervalSince1970: 1667335531), scramble: []),
        CubeResult(time: 42, date: Date(timeIntervalSince1970: 1667421931), scramble: []),
        CubeResult(time: 40, date: Date(timeIntervalSince1970: 1667508331), scramble: []),
        // November 8./9./10. = Week 45
        CubeResult(time: 42, date: Date(timeIntervalSince1970: 1667940331), scramble: []),
        CubeResult(time: 40, date: Date(timeIntervalSince1970: 1668026731), scramble: []),
        CubeResult(time: 38, date: Date(timeIntervalSince1970: 1668113131), scramble: []),
        // Week 46 - no results
        
        // November 22./23./24. = Week 47
        CubeResult(time: 40, date: Date(timeIntervalSince1970: 1669157131), scramble: []),
        CubeResult(time: 39, date: Date(timeIntervalSince1970: 1669243531), scramble: []),
        CubeResult(time: 38, date: Date(timeIntervalSince1970: 1669329931), scramble: []),
    ]
    
    func testAverage() throws {
        let sut = TimerModel()
        sut.results = testResults
        
        XCTAssertEqual(sut.averageOverallString, "40.333")
    }
    
    func testGroupByWeekq() throws {
        let sut = TimerModel()
        sut.results = testResults
    }
}
