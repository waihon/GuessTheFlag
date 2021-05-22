//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yew Wai Hon on 21/05/2021.
//

import SwiftUI

struct ContentView: View {
  static let choices = 4
  static let maximumRounds = 20

  @State private var countries = [
    "Afghanistan", "Albania", "Algeria", "Andorra", "Angola",
    "Antigua and Barbuda", "Argentina", "Armenia", "Aruba",
    "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain",
    "Bangladesh", "Barbados", "China", "Estonia", "France",
    "Germany", "India", "Indonesia", "Ireland", "Italy",
    "Japan", "Laos", "Malaysia", "Myanmar", "Nigeria",
    "North Korea", "Poland", "Russia", "Singapore",
    "South Korea", "Spain", "Thailand", "UK", "US", "Vietnam"
  ].shuffled()
  @State private var correctAnswer = Int.random(in: 0 ..< ContentView.choices)
  @State private var showingScore = false
  @State private var scoreTitle = ""
  @State private var message = ""
  @State private var score = 0
  @State private var rounds = 1

  var body: some View {
    ZStack {
      LinearGradient(gradient: Gradient(colors: [.blue, .black]),
                     startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
      VStack(spacing: 20) {
        VStack {
          Text("Tap the flag of")
            .foregroundColor(.white)
          Text(countries[correctAnswer])
            .foregroundColor(.white)
            .font(.largeTitle)
            .fontWeight(.black)
        }
        
        ForEach(0 ..< ContentView.choices) { number in
          Button(action: {
            self.flagTapped(number)
          }) {
            Image(self.countries[number])
              .renderingMode(.original)
              .clipShape(RoundedRectangle(cornerRadius: 10.0))
              .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.black, lineWidth: 1))
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
      if rounds < ContentView.maximumRounds {
        message = "Your current score is \(score)."
      } else {
        message = "Your final score is \(score)."
      }
      showingScore = false
      self.askQuestion()
    } else {
      scoreTitle = "Wrong"
      score -= 1
      message = "That's the flag of \(self.countries[number])."
      if rounds == ContentView.maximumRounds {
        message += "\nYour final score is \(score)."
      }
      showingScore = true
    }
    
    rounds += 1
  }
  
  func askQuestion() {
    countries.shuffle()
    correctAnswer = Int.random(in: 0 ..< ContentView.choices)
    if rounds > ContentView.maximumRounds {
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
