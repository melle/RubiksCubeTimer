// Copyright © 2025 Thomas Mellenthin (privat). All rights reserved.


import Foundation
import SwiftUI

public struct GroupedCubeResult: Hashable, Identifiable {
    let key: String
    let results: [CubeResult]
    
    public var id: String {
        return key
    }
}
