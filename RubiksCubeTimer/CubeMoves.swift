// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import Foundation

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
//    case r = "r"
//    case rprime = "r'"
//    case r2 = "r2"
//    case l = "l"
//    case lprime = "l'"
//    case l2 = "l2"
//    case u = "u"
//    case uprime = "u'"
//    case u2 = "u2"
//    case d = "d"
//    case dprime = "d'"
//    case d2 = "d2"
//    case f = "f"
//    case fprime = "f'"
//    case f2 = "f2"
//    case b = "b"
//    case bprime = "b'"
//    case b2 = "b2"
//    case E = "E"
//    case Eprime = "E'"
//    case E2 = "E2"
//    case S = "S"
//    case Sprime = "S'"
//    case S2 = "S2"
//    case M = "M"
//    case Mprime = "M'"
//    case M2 = "M2"
    
    static func randomMoves(_ numberOfMoves: UInt) -> [CubeMoves] {
        var moves: [CubeMoves] = []
        for _ in 1...numberOfMoves {
            moves.append(Self.allCases.randomElement()!) // ok, because we know the collection is not empty
        }
        return moves
    }

    static func string(from: [CubeMoves]) -> String {
        return from.lazy.map { $0.rawValue }.joined(separator: " ")
    }
}
