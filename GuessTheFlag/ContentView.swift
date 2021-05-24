//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Yew Wai Hon on 21/05/2021.
//

import SwiftUI

struct FlagImage: View {
  var imageName: String
  
  var body: some View {
    Image(imageName)
      .renderingMode(.original)
      .clipShape(RoundedRectangle(cornerRadius: 10.0))
      .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.black, lineWidth: 1))
      .shadow(color: .black, radius: 2)
  }
}

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
  @State private var showingAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @State private var score = 0
  @State private var currentRound = 1
  @State private var finalMessage = ""

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
            FlagImage(imageName: self.countries[number])
          }
          .disabled(finalMessage != "")
        }
        
        VStack {
          Text("Score: \(score)")
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.black)
          
          Text(finalMessage)
            .foregroundColor(.white)
            .font(.title3)
            .fontWeight(.black)
        }
        
        Spacer()
      }
    }
    .alert(isPresented: $showingAlert) {
      Alert(title: Text(alertTitle),
            message: Text(alertMessage),
            dismissButton: .default(Text("Continue")) {
        self.askQuestion()
      })
    }
  }
  
  func flagTapped(_ number: Int) {
    if number == correctAnswer {
      score += 1
      showingAlert = false
      self.askQuestion()
    } else {
      alertTitle = "Wrong"
      alertMessage = "That's the flag of \(self.countries[number])."
      showingAlert = true
    }
  }
  
  func askQuestion() {
    if currentRound == ContentView.maximumRounds {
      let percent = score * 100 / ContentView.maximumRounds
      finalMessage = "You scored \(score) out of \(ContentView.maximumRounds) (\(percent)%)"
    } else {
      currentRound += 1
      countries.shuffle()
      correctAnswer = Int.random(in: 0 ..< ContentView.choices)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
