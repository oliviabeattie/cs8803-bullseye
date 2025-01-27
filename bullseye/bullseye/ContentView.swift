//
//  ContentView.swift
//  bullseye
//
//  Created by Olivia Beattie on 1/26/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var alertVisible = false
    @State var sliderValue = 50.0
    
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    
    func calculateScore() -> Int {
        let difference = abs(target - Int(sliderValue.rounded()))
        var points = 100 - difference
        
        if (difference == 0) {
            points += 100
        } else if (difference == 1) {
            points += 50
        }
            
        return points
    }
    
    func alertTitle() -> String {
        let difference = abs(target - Int(sliderValue.rounded()))
        let title: String
        
        if (difference == 0) {
            title = "Perfect!"
        } else if (difference < 5) {
            title = "You almost had it!"
        } else if (difference <= 10) {
            title = "Not bad."
        } else {
            title = "Are you even trying?"
        }
        
        return title
    }
    
    func startOver () {
        score = 0
        round = 1
        sliderValue = 50.0
        target = Int.random(in: 1...100)
    }

    var body: some View {
        VStack {
            Spacer()
            
            // target
            HStack {
                Text("Put the bullseye as close as you can to: ")
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black, radius: 5, x: 2, y: 2)
                    .font(Font.custom("Arial Rounded MT Bold", size: 18))
                Text("\(target)")
            }
            Spacer()
            
            // slider
            HStack {
                Text("1")
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black, radius: 5, x: 2, y: 2)
                    .font(Font.custom("Arial Rounded MT Bold", size: 18))
                Slider(value: $sliderValue, in:1...100)
                Text("100")
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black, radius: 5, x: 2, y: 2)
                    .font(Font.custom("Arial Rounded MT Bold", size: 18))
            }
            Spacer()
            
            // button
            Button(action: {
                self.alertVisible = true }) {
                Text("HIT ME")
            }.alert(isPresented: $alertVisible) { () ->
                Alert in
                return Alert(title: Text(alertTitle()),
                             message: Text("The slider value is \(Int(sliderValue.rounded())).\n" +
                                           "You scored \(calculateScore()) this round!"),
                             dismissButton: .default(Text("Awesome!")) {
                                            score += calculateScore()
                                            round += 1
                                            target = Int.random(in: 1...100) })
            }
            Spacer()
            // score
            HStack {
                // restart button
                Button(action: {
                    startOver() }) {
                    Text("Start Over")
                }
                Spacer()
                
                // score
                Text("Score:")
                Text("\(score)")
                Spacer()
                
                // round
                Text("Round:")
                Text("\(round)")
                Spacer()
                
                // info button
                Button(action: {}) {
                    Text("Info")
                }
            }
        }
        .padding(.bottom, 20)
        .background(Image("Background"), alignment: .center)
    }
}

#Preview(traits: .fixedLayout(width: 896, height: 414)) {
    ContentView()
}
