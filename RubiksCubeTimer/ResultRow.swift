// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct ResultRow: View {
    @ObservedObject var model: TimerModel
    let result: CubeResult

    var body: some View {
        VStack {
            Text(model.resultDateFormatter.string(from: result.date))
                .font(.caption)
                .foregroundColor(Color.gray)
            Text(model.resultTimeFormatted(from: result))
                .font(.subheadline)
        }
    }
}

struct ResultRow_Previews: PreviewProvider {
    static var previews: some View {
        ResultRow(model: TimerModel.init(),
                  result: CubeResult.init(time: 23.42,
                                          date: .now,
                                          scramble: []))
    }
}
