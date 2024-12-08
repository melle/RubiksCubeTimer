// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import SwiftUI

struct SettingsView: View {
    var store: StoreOf<SettingsFeature>
    
    var body: some View {
        VStack(alignment: .leading) {
            Stepper(label: {
                Text("Moves per scramble:  \(store.movesPerScramble)")
                    .font(.system(size: 18))
            }, onIncrement: {
                store.send(.incrementMovesPerScramble)
            }, onDecrement: {
                store.send(.decrementMovesPerScramble)
            })
            .padding()
            
#if DEBUG
            Divider() /* -------------- */
            
            Button(action: {
                store.send(.generateRandomResults)
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
        SettingsView(store: Store(initialState: SettingsFeature.State(), reducer: {
            SettingsFeature()
        }))
    }
}
