// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct ResultsView: View {
    @ObservedObject var model: TimerModel
    var body: some View {
        
        List(model.results, id: \.id, rowContent: { result in
            
            Text("\(model.resultDateFormatter.string(from: result.date)) ⬩ \(model.resultTimeFormatted(from: result))")
        })
    }
    
    struct ResultsView_Previews: PreviewProvider {
        static var previews: some View {
            ResultsView(model: TimerModel())
        }
    }
}
