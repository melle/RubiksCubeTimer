// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: TimerModel

    var body: some View {
        VStack(alignment: .leading) {
            Stepper(label: {
                Text("Moves per scramble:  \(model.movesPerScramble)")
                    .font(.system(size: 18))
            }, onIncrement: {
                model.incrementMovesPerScramble()
            }, onDecrement: {
                model.decrementMovesPerScramble()
            })
            .padding()
            
            Divider() /* -------------- */
            
            #if DEBUG
            
            Button(action: {
                model.generateRandomResults()
            }, label: {
                Text("Generate random results")
            })
            .padding()
            
            Divider() /* -------------- */
            
            #endif

            Spacer()
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(model: .init())
    }
}
