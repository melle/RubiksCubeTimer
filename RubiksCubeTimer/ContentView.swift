// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct ContentView: View {
    
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
            
            VStack {
                Text(model.movesText)
                    .font(movesFont)
                    .foregroundColor(Color.white)
                    .padding(.vertical, 80)                
                    .padding(.horizontal)
                

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
                .padding()
                Spacer()
            }
        }
        .cornerRadius(15)
        .padding()
        .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onChanged { state in
                            model.handleButtonPress()
                            print("DRAG \(state)")
                        }
                        .onEnded { state in
                            model.handleButtonRelease()
                            print("END \(state)")
                        })
        .onReceive(timer) { _ in
            timeDisplay = model.buttonText
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: TimerModel.init())
    }
}
