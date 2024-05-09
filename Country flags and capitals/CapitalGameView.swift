import SwiftUI
import AVFoundation
import Foundation

import SwiftUI
import AVFoundation
import Foundation

import SwiftUI
import AVFoundation
import Foundation

struct CapitalGameView: View {
    @StateObject var game = CapitalGuessingGame()
    
    var body: some View {
        ZStack {
            Color.mint.edgesIgnoringSafeArea(.all) // Background color covering the entire screen
            
            VStack {
                Text("Познай столицата")
                    .font(.title)
                    .padding()
                
                if !game.currentCountry.isEmpty { // Check if currentCountry is not empty
                    Image(game.currentCountry) // Assuming flag images are named after country names
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 60) // Adjust size as needed
                        .clipShape(Circle()) // Optional: Clip to circle for rounded effect
                    
                    Text("Country: \(game.currentCountry)")
                        .padding()
                }
                
                ForEach(game.options, id: \.self) { option in
                    Button(action: {
                        game.checkAnswer(option: option)
                    }) {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                }
                
                Text("Правилни отговори: \(game.correctAnswerCount)")
                    .font(.title)
                    .bold()
                    .italic()
                    .padding()
                
                Text("Най-висок резултат: \(game.highestScore)")
                    .font(.title)
                    .bold()
                    .italic()
                    .padding()
            }
        }
    }
}




class CapitalGuessingGame: ObservableObject {
    let countriesAndCapitals: [String: String] = [
        "USA": "Washington D.C.",
        "Bulgaria": "Sofia",
        "Greece": "Athens",
        "Turkey": "Ankara",
        "Romania": "Bucharest",
        "North Macedonia": "Skopje",
        "Serbia": "Belgrade",
        "Albania": "Tirana",
        "Croatia": "Zagreb",
        "Унгария": "Будапещ"
        // Add more countries and capitals as needed
    ]
    
    @Published var currentCountry = ""
    @Published var correctCapital = ""
    @Published var options: [String] = []
    @Published var correctAnswerCount = 0
    @Published var highestScore = 0
    
    var correctAnswerSoundEffect: AVAudioPlayer?
    var wrongAnswerSoundEffect: AVAudioPlayer?

    init() {
        // Load the sound file for correct answer
        if let correctSoundURL = Bundle.main.url(forResource: "correct1", withExtension: "wav") {
            do {
                correctAnswerSoundEffect = try AVAudioPlayer(contentsOf: correctSoundURL)
            } catch {
                print("Error loading correct answer sound file: \(error.localizedDescription)")
            }
        }
        
        // Load the sound file for wrong answer
        if let wrongSoundURL = Bundle.main.url(forResource: "wrong", withExtension: "wav") {
            do {
                wrongAnswerSoundEffect = try AVAudioPlayer(contentsOf: wrongSoundURL)
            } catch {
                print("Error loading wrong answer sound file: \(error.localizedDescription)")
            }
        }
        
        generateQuestion()
    }
    
    func generateQuestion() {
        let randomIndex = Int.random(in: 0..<countriesAndCapitals.count)
        let country = Array(countriesAndCapitals.keys)[randomIndex]
        currentCountry = country
        correctCapital = countriesAndCapitals[country] ?? ""
        
        options = generateOptions(correctCapital: correctCapital)
    }
    
    func generateOptions(correctCapital: String) -> [String] {
        var options: [String] = [correctCapital]
        
        while options.count < 3 {
            let randomIndex = Int.random(in: 0..<countriesAndCapitals.count)
            let capital = Array(countriesAndCapitals.values)[randomIndex]
            
            if !options.contains(capital) {
                options.append(capital)
            }
        }
        
        return options.shuffled()
    }
    
    func checkAnswer(option: String) {
        if option == correctCapital {
            correctAnswerCount += 1
            if correctAnswerCount > highestScore {
                highestScore = correctAnswerCount
            }
            correctAnswerSoundEffect?.play()
        } else {
            wrongAnswerSoundEffect?.play()
            correctAnswerCount = 0
        }
        generateQuestion()
    }
}

struct CapitalGameView_Previews: PreviewProvider {
    static var previews: some View {
        CapitalGameView()
    }
}
