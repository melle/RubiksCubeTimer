// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation

public struct JSONCoderProvider {
    public var encoder: () -> JSONEncoder
    public var decoder: () -> JSONDecoder
}

extension JSONCoderProvider: DependencyKey {
    public static let liveValue = Self(
        encoder: {
            var encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return encoder
        },
        decoder: {
            JSONDecoder()
        }
    )
}

extension DependencyValues {
    public var jsonCoderProvider: JSONCoderProvider {
        get { self[JSONCoderProvider.self] }
        set { self[JSONCoderProvider.self] = newValue }
    }
}
