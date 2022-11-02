// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct TimerView: View {
    
    @State var model: TimerModel
    @State var timeDisplay: String = ""

    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    let clockFont = Font
        .system(size: 36)
        .bold()
        .monospaced()
    
    let movesFont = Font
        .system(size: 24)
        .bold()
        .monospaced()
    
    
    var body: some View {
        ZStack {
            model.buttonColor
                .cornerRadius(15)
        
            VStack {
                VStack {
                    Text(model.movesText)
                        .font(movesFont)
                        .foregroundColor(Color.white)
                        .padding(.top, 80)
                        .padding(.horizontal)
                }
                
                Spacer()
                    
                Image(systemName: "stopwatch")
                    .imageScale(.large)
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .padding()
                

                HStack {
                    Spacer()
                    Text(timeDisplay)
                        .font(clockFont)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                
                Spacer()
            }
        }
        .padding(15)
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { state in
                print("onChanged \(state)")
                model.handleButtonPress()
            }
            .onEnded { state in
                print("onEnded \(state)")
                model.handleButtonRelease()
            }
        )
        .onReceive(timer) { _ in
            timeDisplay = model.buttonText
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(model: TimerModel.init())
    }
}
