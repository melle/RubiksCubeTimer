// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import Foundation

// FIXME: use tnoodle or another official scrambler program
// FIXME: avoid repetations (L , L -> 2L)
// FIXME: avoid pairs (R , R' -> no change at all)
enum CubeMoves: String, CaseIterable, Codable {
    case R = "R"
    case Rprime = "R'"
    case R2 = "R2"
    case L = "L"
    case Lprime = "L'"
    case L2 = "L2"
    case U = "U"
    case Uprime = "U'"
    case U2 = "U2"
    case D = "D"
    case Dprime = "D'"
    case D2 = "D2"
    case F = "F"
    case Fprime = "F'"
    case F2 = "F2"
    case B = "B"
    case Bprime = "B'"
    case B2 = "B2"

    static func randomMoves(_ numberOfMoves: UInt) -> [CubeMoves] {
        var moves: [CubeMoves] = []
        for _ in 1...numberOfMoves {
            moves.append(Self.allCases.randomElement()!) // ok, because we know the collection is not empty
        }
        return moves
    }

    static func string(from: [CubeMoves]) -> String {
        return from.lazy.map { $0.rawValue }.joined(separator: "  ")
    }
}
