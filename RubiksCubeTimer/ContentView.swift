// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

enum ButtonState {
    case idle
    case ready
    case running
    case finished
}

struct TimerModel {
    
    var buttonState: ButtonState = .idle
    var buttonPressed: Bool = false
    var startTime: Date = .now
    var endTime: Date = .now

    
    var buttonColor: Color {
        switch buttonState {
        case .idle: return Color.gray
        case .ready: return Color.green
        case .running: return Color.red
        case .finished: return Color.red
        }
    }
    
    var buttonText: String {
        switch buttonState {
        case .idle: return "START"
        case .ready: return "READY"
        case .running:
            return String(format: "%.3f", Date.now.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate)
        case .finished:
            return String(format: "%.3f", endTime.timeIntervalSinceReferenceDate - startTime.timeIntervalSinceReferenceDate)
        }
    }
    
    mutating func handleButtonPress() {
        guard buttonPressed == false else { return }
        buttonPressed = true

        switch buttonState {
        case .idle: buttonState = .ready
        case .ready: buttonState = .ready
        case .running:
            buttonState = .finished
            endTime = .now
        case .finished: buttonState = .idle
        }
    }
    
    mutating func handleButtonRelease() {
        guard buttonPressed == true else { return }
        buttonPressed = false
        
        switch buttonState {
        case .idle: buttonState = .idle
        case .ready:
            buttonState = .running
            startTime = .now
        case .running: buttonState = .running
        case .finished: buttonState = .finished
        }
    }
}

struct ContentView: View {
    
    @State var model: TimerModel
    @State var timeDisplay: String = ""
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            model.buttonColor
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "stopwatch")
                        .imageScale(.large)
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                    Text(timeDisplay)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.white)
                    Spacer()
                }
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
        ContentView(model: TimerModel.init(buttonState: .idle))
    }
}
