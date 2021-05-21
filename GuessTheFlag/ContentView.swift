//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yew Wai Hon on 21/05/2021.
//

import SwiftUI

struct ContentView: View {
  var countries = ["Estonia", "France", "Germany", "Ireland",
                   "Italy", "Nigeria", "Poland", "Russia",
                   "Spain", "UK", "US"]
  var correctAnswer = Int.random(in: 0...2)
  
  var body: some View {
    Text("Hello, world!")
      .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
