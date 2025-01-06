// Copyright © 2024 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation

public struct DateFormatterProvider {
    public var resultsFormatter: () -> DateFormatter
}

extension DateFormatterProvider: DependencyKey {
    
    // DateFormatter used to be expensive to create
    private static let _liveValue: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateFormat = "Y - w"
        return formatter
    }()
    
    public static let liveValue = Self(
        resultsFormatter: { _liveValue }
    )
}

extension DependencyValues {
    public var dateFormatterProvider: DateFormatterProvider {
    get { self[DateFormatterProvider.self] }
    set { self[DateFormatterProvider.self] = newValue }
  }
}
