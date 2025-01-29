//
//  ContentView.swift
//  bullseye
//
//  Created by Olivia Beattie on 1/26/25.
//

import SwiftUI
import FirebaseAnalytics
import FirebaseDatabase

struct ContentView: View {
    
    @State var alertVisible = false
    @State var sliderValue = 50.0
    
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    
    struct TextStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.white)
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.yellow)
                .shadow(color: Color.black, radius: 5, x: 2, y: 2)
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
        }
    }
    
    struct ButtonSmallStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
        }
    }
    
    struct ButtonLargeStyle: ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 20))
        }
    }
    
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
                Text("Put the bullseye as close as you can to: ").modifier(TextStyle())
                Text("\(target)").modifier(ValueStyle())
            }
            Spacer()
            
            // slider
            HStack {
                Text("1").modifier(TextStyle())
                Slider(value: $sliderValue, in:1...100)
                Text("100").modifier(TextStyle())
            }
            Spacer()
            
            // button
            Button(action: {
                self.alertVisible = true
                Analytics.logEvent("score_submitted", parameters: [
                    "round": round,
                    "score": calculateScore(),
                    "target": target,
                    "slider_value": Int(sliderValue.rounded())
                ])
                // Save data to Firebase Realtime Database
                let ref = Database.database().reference()
                let eventData = [
                    "round": round,
                    "score": score,
                    "target": target,
                    "slider_value": Int(sliderValue.rounded())
                ]
                ref.child("events").childByAutoId().setValue(eventData) }) {
                Text("HIT ME!").modifier(ButtonLargeStyle())
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
            .background(Image("Button"))
            Spacer()
            // score
            HStack {
                // restart button
                Button(action: {
                    startOver() }) {
                    HStack {
                        Image("StartOverIcon")
                        Text("Start Over")
                    }
                }.background(Image("Button"))
                 .modifier(ButtonSmallStyle())
                Spacer()
                
                // score
                Text("Score:").modifier(TextStyle())
                Text("\(score)").modifier(ValueStyle())
                Spacer()
                
                // round
                Text("Round:").modifier(TextStyle())
                Text("\(round)").modifier(ValueStyle())
                Spacer()
                
                // info button
                Button(action: {}) {
                    HStack {
                        Image("InfoIcon")
                        Text("Info")
                    }
                }.background(Image("Button"))
                 .modifier(ButtonSmallStyle())
            }
        }
        .padding(.bottom, 20)
        .background(Image("Background"), alignment: .center)
    }
}

#Preview(traits: .fixedLayout(width: 896, height: 414)) {
    ContentView()
}
