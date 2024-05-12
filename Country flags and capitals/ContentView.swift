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
            
            ForEach(game.options.prefix(game.numberOfOptions), id: \.self) { option in
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
        .background(Color.green) // Changed background color for better visibility
    }
}


class FlagGuessingGame: ObservableObject {
    @Published var correctAnswerIndex = Int.random(in: 0..<3)
    @Published var userGuess = ""
    @Published var correctAnswerCount = 0
    @Published var currentLevel = 1
    
    var currentFlag: String {
        countries[correctAnswerIndex]
    }
    
    var numberOfOptions: Int {
        return min(2 + currentLevel, countries.count)
    }
    
    var options: [String] {
        var options = [currentFlag]
        while options.count < numberOfOptions {
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
        if let correctSoundURL = Bundle.main.url(forResource: "correct1", withExtension: "wav") {
            do {
                correctAnswerSoundEffect = try AVAudioPlayer(contentsOf: correctSoundURL)
            } catch {
                print("Error loading correct answer sound file: \(error.localizedDescription)")
            }
        }
        
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
            print("Correct Answer Count:", correctAnswerCount)
            correctAnswerSoundEffect?.play()
            let highestScore = UserDefaults.standard.integer(forKey: "highestScore")
            if correctAnswerCount > highestScore {
                UserDefaults.standard.set(correctAnswerCount, forKey: "highestScore")
            }
            
            if correctAnswerCount % 5 == 0 && numberOfOptions < 5 {
                currentLevel += 1
                print("Current Level:", currentLevel)
            }
        } else {
            wrongAnswerSoundEffect?.play()
            correctAnswerCount = 0
            resetOptions() // Call resetOptions when the answer is incorrect
        }
        correctAnswerIndex = Int.random(in: 0..<countries.count)
    }

    func resetOptions() {
        // Reset options to three
        currentLevel = 1
        objectWillChange.send()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
