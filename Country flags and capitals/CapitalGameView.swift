import SwiftUI
import AVFoundation
import Foundation

struct CapitalGameView: View {
    @StateObject var game = CapitalGuessingGame()
    
    var body: some View {
        ZStack {
            Color.mint.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Познай столицата")
                    .font(.title)
                    .padding()
                
                if !game.currentCountry.isEmpty {
                    Image(game.currentCountry)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 120)
                        .clipShape(Circle())
                    
                    Text(" \(game.currentCountry)")
                        .font(.title)
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
                            .font(.title)
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
        .onDisappear {
            game.saveHighestScore()
        }
    }
}

class CapitalGuessingGame: ObservableObject {
    @Published var currentCountry = ""
    @Published var correctCapital = ""
    @Published var options: [String] = []
    @Published var correctAnswerCount = 0
    @Published var highestScore = UserDefaults.standard.integer(forKey: "capitalHighestScore")
    
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
                UserDefaults.standard.set(highestScore, forKey: "capitalHighestScore")
            }
            correctAnswerSoundEffect?.play()
        } else {
            wrongAnswerSoundEffect?.play()
            correctAnswerCount = 0
        }
        generateQuestion()
    }
    
    func saveHighestScore() {
        UserDefaults.standard.set(highestScore, forKey: "capitalHighestScore")
    }
}

struct CapitalGameView_Previews: PreviewProvider {
    static var previews: some View {
        CapitalGameView()
    }
}
