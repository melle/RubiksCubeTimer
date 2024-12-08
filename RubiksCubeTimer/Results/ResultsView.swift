// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import SwiftUI

struct ResultsView: View {
    let store: StoreOf<ResultsFeature>
    
    var body: some View {
        VStack {
            
            Text("Average: \(store.averageOverallString) seconds")
                .font(.headline)
            
            List {
                ForEach(store.resultsByWeek, id: \.id) { section in
                    Section(content: {
                        ForEach(section.results) { result in
                            resultRow(result: result)
                        }
                        .onDelete { indexes in
                            store.send(.deleteResult(indexes: indexes))
                        }
                    }, header: {
                        Text(section.key)
                    })
                }
            }
        }
    }
    
    private func resultRow(result: CubeResult) -> some View {
        VStack {
            Text(result.date.formatted())
                .font(.caption)
                .foregroundColor(Color.gray)
            Text(result.time.formatted())
                .font(.subheadline)
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
        ResultsView(store: Store(initialState: ResultsFeature.State(), reducer: {
            ResultsFeature()
        }))
    }
}

