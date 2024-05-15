import SwiftUI
import AVFoundation
import Foundation

struct CapitalGameView: View {
    @StateObject var game = CapitalGuessingGame()
    
    var body: some View {
        ZStack {
            Color.mint.edgesIgnoringSafeArea(.all)
            
            ScrollView { // Encapsulate the main content in a ScrollView
                VStack {
                    Text("Познай Столицата")
                        .font(.custom("Troika", size: 42))
                        .padding()
                    
                    
                    if !game.currentCountry.isEmpty {
                        Image(game.currentCountry)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 120)
                            .clipShape(Circle())
                        
                        Text(" \(game.currentCountry)")
                            .font(.custom("Troika", size: 35))
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
                        .padding(.vertical, 2)
                    }
                    
                    Text("Правилни отговори: \(game.correctAnswerCount)")
                       
                        .bold()
                        .font(.custom("Azbuki", size: 35))
                        .padding()
                    
                    Text("Най-висок Резолтат: \(game.highestScore)")
                        .font(.custom("Azbuki", size: 35))
                        .bold()
                        .italic()
                        .padding()
                    Spacer()
                }
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
    @Published var currentLevel = 1
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
        
        let numberOfOptions = min(2 + currentLevel, 5) // Maximum of 5 options
        
        while options.count < numberOfOptions {
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
            
            if correctAnswerCount % 5 == 0 { // Increase level every 5 correct answers
                currentLevel += 1
            }
        } else {
            wrongAnswerSoundEffect?.play()
            correctAnswerCount = 0
            
            // Reset options to three
            currentLevel = 1
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
