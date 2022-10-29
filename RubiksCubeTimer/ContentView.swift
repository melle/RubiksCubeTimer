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
    var clockFormatter = DateFormatter()
    var movesText: String = CubeMoves.randomMovesString

    init() {
        self.buttonState = .idle
        self.buttonPressed = false
        self.startTime = .now
        self.endTime = .now
        clockFormatter.dateFormat = "HH:mm:ss.SSS"
        clockFormatter.timeZone = TimeZone(identifier: "GMT")
    }
    
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
            let duraction = Date.now.timeIntervalSince1970 - startTime.timeIntervalSince1970
            let date = Date(timeIntervalSince1970: duraction)
            return clockFormatter.string(from: date)
        case .finished:
            let duraction = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            let date = Date(timeIntervalSince1970: duraction)
            return clockFormatter.string(from: date)
        }
    }
    
    mutating func handleButtonPress() {
        guard buttonPressed == false else { return }
        buttonPressed = true

        switch buttonState {
        case .idle:
            buttonState = .ready
            movesText = ""
        case .ready:
            buttonState = .ready
        case .running:
            buttonState = .finished
            endTime = .now
        case .finished:
            buttonState = .idle
            movesText = CubeMoves.randomMovesString
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
