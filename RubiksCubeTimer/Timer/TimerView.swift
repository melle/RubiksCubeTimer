// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation
import SwiftUI

struct TimerView: View {
    let store: StoreOf<TimerFeature>
    
    // We need to update the time display very often which would cause a flood of actions.
    // Instead the timer updates the timeDisplay string which causes the veiw to update.
    @State private var timeDisplay: String = ""
    private let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    let clockFont = Font
        .system(size: 36)
        .bold()
        .monospaced()
    
    let movesFont = Font
        .system(size: 24)
        .bold()
        .monospaced()
    
    
    var body: some View {
        VStack {
            //            Picker(selection: store.timerMode) {
            //                Text(TimerMode.manualEntry.rawValue).tag(TimerMode.manualEntry)
            //                Text(TimerMode.timer.rawValue).tag(TimerMode.timer)
            //            } label: {
            //            }
            //            .pickerStyle(.segmented)
            //            .padding()
            
            timerView()
            
                .padding(15)
                .onReceive(timer) { _ in
                    timeDisplay = store.buttonText
                }
        }
    }
    
    private func scramblesView() -> some View {
        VStack {
            Text(store.movesText)
                .font(movesFont)
                .foregroundColor(Color.white)
                .padding(.vertical)
                .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private func timerView() -> some View {
        ZStack {
            store.buttonColor // have a color to catch the touches
                .cornerRadius(15)
            
            scramblesView()
            
            VStack {
                Spacer()
                
                Image(systemName: "stopwatch.fill")
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
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { state in
                store.send(.stopwatchTouched)
            }
            .onEnded { state in
                store.send(.stopwatchTouchReleased)
            }
        )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var model: TimerModel {
        let mdl = TimerModel.init()
        mdl.scramble = CubeMoves.randomMoves(18)
        return mdl
    }
    
    static var previews: some View {
        TimerView(store: Store(initialState: TimerFeature.State(), reducer: {
            TimerFeature()
        }) )
    }
}
