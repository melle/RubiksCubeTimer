// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct ResultsView: View {
    var model: TimerModel
    
    var body: some View {
        VStack {
            List(Binding.init(get: {
                model.results
            }, set: { _ in
                
            }), id: \.id, rowContent: { result in
                Text("Result \(result.id)")
            })
            .id(model.results)
        }
        
    }      
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(model: TimerModel())
    }
}

