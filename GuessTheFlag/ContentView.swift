//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yew Wai Hon on 21/05/2021.
//

import SwiftUI

struct ContentView: View {
  @State private var countries = ["Estonia", "France", "Germany", "Ireland",
                                  "Italy", "Nigeria", "Poland", "Russia",
                                  "Spain", "UK", "US"].shuffled()
  @State private var correctAnswer = Int.random(in: 0...2)
  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var message = ""
  @State private var score = 0
  @State private var rounds = 1
  let maximumRounds = 20

  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [.blue, .black]),
                     startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 30) {
        VStack {
          Text("Tap the flag of")
            .foregroundColor(.white)
          Text(countries[correctAnswer])
            .foregroundColor(.white)
            .font(.largeTitle)
            .fontWeight(.black)
        }
        
        ForEach(0 ..< 3) { number in
          Button(action: {
            self.flagTapped(number)
          }) {
            Image(self.countries[number])
              .renderingMode(.original)
              .clipShape(Capsule())
              .overlay(Capsule().stroke(Color.black, lineWidth: 1))
              .shadow(color: .black, radius: 2)
          }
        }
        
        Text("Score: \(score)")
          .foregroundColor(.white)
          .font(.title)
          .fontWeight(.black)
        
        Spacer()
      }
    }
    .alert(isPresented: $showingScore) {
      Alert(title: Text(scoreTitle),
            message: Text(message),
            dismissButton: .default(Text("Continue")) {
        self.askQuestion()
      })
    }
  }
  
  func flagTapped(_ number: Int) {
    if number == correctAnswer {
      scoreTitle = "Correct"
      score += 1
      if rounds < maximumRounds {
        message = "Your current score is \(score)."
      } else {
        message = "Your final score is \(score)."
      }
    } else {
      scoreTitle = "Wrong"
      score -= 1
      message = "That's the flag of \(self.countries[number])."
      if rounds == maximumRounds {
        message += "\nYour final score is \(score)."
      }
    }
    
    rounds += 1
    showingScore = true
  }
  
  func askQuestion() {
    countries.shuffle()
    correctAnswer = Int.random(in: 0...2)
    if rounds > maximumRounds {
      rounds = 1
      score = 0
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
