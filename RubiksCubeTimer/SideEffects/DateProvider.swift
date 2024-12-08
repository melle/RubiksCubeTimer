// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation

public struct DateProvider {
    public var startDate: Date
    public var stopDate: Date
}

extension DateProvider: DependencyKey {
    public static let liveValue = Self(
        startDate: Date.now,
        stopDate: Date.now
    )
}

extension DependencyValues {
    public var dateProvider: DateProvider {
    get { self[DateProvider.self] }
    set { self[DateProvider.self] = newValue }
  }
}
