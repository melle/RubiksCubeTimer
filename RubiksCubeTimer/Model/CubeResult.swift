// Copyright © 2025 Thomas Mellenthin (privat). All rights reserved.
import Foundation
import SwiftUI

public struct CubeResult: Identifiable, Hashable, Equatable, Codable, Sendable {

    internal init(time: TimeInterval, date: Date, scramble: [CubeMoves], id: String) {
        self.time = time
        self.date = date
        self.scramble = scramble
        self.id = id
    }
    
    public let time: TimeInterval
    public let date: Date
    public let scramble: [CubeMoves]
    public let id: String
}
