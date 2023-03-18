// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct ResultsView: View {
    @ObservedObject var model: TimerModel
    var body: some View {
        VStack {
            Text("Average: \(model.averageOverallString) seconds")
                .font(.title)
            
            List {
                ForEach(model.resultsByWeek, id: \.id) { section in
                    Section(content: {
                        ForEach(section.results) { result in
                            ResultRow(model: model, result: result)
                        }
                        .onDelete { indexes in
                            model.deleteResult(indexes: indexes)
                        }
                    }, header: {
                        Text(section.key)
                    })
                }
            }
        }
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var model: TimerModel {
        let mdl = TimerModel()
        mdl.results = [
            CubeResult(time: 10, date: .now, scramble: []),
            CubeResult(time: 20, date: .now, scramble: []),
            CubeResult(time: 30, date: .now, scramble: []),
            CubeResult(time: 40, date: .now, scramble: []),
            CubeResult(time: 50, date: .now, scramble: []),
            CubeResult(time: 60, date: .now, scramble: []),
        ]
        return mdl
    }
    
    static var previews: some View {
        ResultsView(model: model)
    }
}

