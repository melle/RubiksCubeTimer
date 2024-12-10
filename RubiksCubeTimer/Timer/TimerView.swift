// Copyright © 2022 Thomas Mellenthin (privat). All rights reserved.

import ComposableArchitecture
import Foundation
import SwiftUI

struct TimerView: View {
    let store: StoreOf<TimerFeature>
    
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
        }
        .onAppear {
            store.send(.newScramble)
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
                    Text(store.buttonText)
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
