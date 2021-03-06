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
  @State private var animationAmount = [0.0, 0.0, 0.0, 0.0]
  @State private var opacity = [1.0, 1.0, 1.0, 1.0]

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
          .rotation3DEffect(.degrees(animationAmount[number]), axis: (x: 0, y: 1, z:0))
          .opacity(opacity[number])
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
      withAnimation(.linear(duration: 1)) {
        for i in 0 ..< ContentView.choices {
          if i == number {
            continue
          } else {
            opacity[i] = 0.25
          }
        }
        self.animationAmount[number] += 360
      }
      score += 1
      alertTitle = "Correct"
      alertMessage = ""
      showingAlert = true
    } else {
      withAnimation(.linear(duration: 1)) {
        for i in 0 ..< ContentView.choices {
          if i == number {
            opacity[i] = 0.25
          }
        }
      }
      alertTitle = "Wrong"
      alertMessage = "That's the flag of \(self.countries[number])."
      showingAlert = true
    }
  }
  
  func askQuestion() {
    opacity = [1.0, 1.0, 1.0, 1.0]
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
