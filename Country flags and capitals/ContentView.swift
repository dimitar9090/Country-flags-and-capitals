import SwiftUI
import AVFoundation
import Foundation

struct ContentView: View {
    @StateObject var game = FlagGuessingGame()
    
    var body: some View {
        FlagGuessingView(game: game)
    }
}

struct FlagGuessingView: View {
    @ObservedObject var game: FlagGuessingGame
    
    var body: some View {
        VStack {
            Text("Познай знамето")
                .font(.custom("Arial", size: 40))
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
                .padding(.vertical, 10)
            Spacer()
            
            Image(game.currentFlag)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .padding()
            Spacer()
            
            ForEach(game.options, id: \.self) { option in
                Button(action: {
                    game.checkAnswer(option: option)
                }) {
                    Text(option)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.title)
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
            
            Text("Най-висок резултат: \(UserDefaults.standard.integer(forKey: "highestScore"))")
                .font(.title)
                .bold()
                .foregroundColor(.blue)
            
            Spacer()
        }
        .background(Color.mint)
    }
}


class FlagGuessingGame: ObservableObject {

    
    @Published var correctAnswerIndex = Int.random(in: 0..<3) // Correct answer index is a random number between 0 and 2
    @Published var userGuess = ""
    @Published var correctAnswerCount = 0
    
    var currentFlag: String {
        countries[correctAnswerIndex]
    }
    
    var options: [String] {
        var options = [currentFlag]
        while options.count < 3 {
            let randomIndex = Int.random(in: 0..<countries.count)
            let country = countries[randomIndex]
            if !options.contains(country) {
                options.append(country)
            }
        }
        return options.shuffled()
    }
    
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
    }

    func checkAnswer(option: String) {
        if option == currentFlag {
            correctAnswerCount += 1
            // Play correct answer sound effect
            correctAnswerSoundEffect?.play()
            // Check if the current score is higher than the saved highest score
            let highestScore = UserDefaults.standard.integer(forKey: "highestScore")
            if correctAnswerCount > highestScore {
                UserDefaults.standard.set(correctAnswerCount, forKey: "highestScore")
            }
        } else {
            // Play wrong answer sound effect
            wrongAnswerSoundEffect?.play()
            // Reset the counter to 0 if the answer is wrong
            correctAnswerCount = 0
        }
        // Generate a new random index for the correct answer
        correctAnswerIndex = Int.random(in: 0..<countries.count)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
