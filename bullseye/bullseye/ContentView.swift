//
//  ContentView.swift
//  bullseye
//
//  Created by Olivia Beattie on 1/26/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var alertVisible: Bool = false

    var body: some View {
        VStack {
            Text("Hello, world!")
            
            Button(action: {
                print("button pressed")
                self.alertVisible = true }) {
                Text("HIT ME")
            }.alert(isPresented: $alertVisible) { () ->
                Alert in
                return Alert(title: Text("Hello there!"),
                             message: Text("pop-up"),
                             dismissButton: .default(Text("Awesome!")))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
