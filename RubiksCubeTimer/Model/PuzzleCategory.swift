// Copyright © 2025 Thomas Mellenthin (privat). All rights reserved.


import Foundation
import SwiftUI

enum PuzzleCategory: String, CaseIterable {
    case cube2x2 = "2 x 2"
    case cube3x3 = "3 x 3"
    case cube4x4 = "4 x 4"
    case cube5x5 = "5 x 5"
    case cube6x6 = "6 x 6"
    case cube7x7 = "7 x 7"
    case cube3x3onehanded = "3 x 3 One-handed"
    case cube3x3blindfolded = "3 x 3 Blindfolded"
    case cube4x4blindfolded = "4 x 4 Blindfolded"
    case cube5x5blindfolded = "5 x 5 Blindfolded"
    case megaminx = "Megaminx"
    case pyraminx = "Pyraminx"
    case skewb = "Skewb"
    case square1 = "Square-1"
    case clock = "Clock"
}