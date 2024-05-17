import SwiftUI
import AVFoundation
import Foundation

struct ContentView: View {
    @StateObject var game = FlagGuessingGame()
    
    var body: some View {
        FlagGuessingView(game: game)
            .onAppear {
                game.startTimer()
            }
    }
}

struct FlagGuessingView: View {
    @ObservedObject var game: FlagGuessingGame
    @State private var selectedOption: String? // Track the selected option
    @State private var showHint = false // Track whether to show the hint

    var body: some View {
        VStack {
            Text("Познай знамето")
                .font(.custom("Troika", size: 40))
                .fontWeight(.semibold)
                .padding(.vertical, 10)
            
            Spacer()
            
            HStack {
                Image(game.currentFlag)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .padding()
                    .rotation3DEffect(
                        .degrees(game.flagRotationAngle),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )

                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 120, height: 60)
                        .shadow(radius: 5)
                    
                    Text(" \(game.timeRemaining)")
                        .font(.custom("Troika", size: 40))
                        .bold()
                        .foregroundColor(.red)
                }
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                showHint = true
            }) {
                Text("Жокер")
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .font(.title)
                    .cornerRadius(10)
            }
            .padding(.vertical, 10)
            
            Spacer()
            
            ForEach(game.options.prefix(game.numberOfOptions), id: \.self) { option in
                Button(action: {
                    selectedOption = option
                    game.checkAnswer(option: option)
                    game.resetTimer()
                    showHint = false // Reset hint display when an option is selected
                }) {
                    Text(option)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(showHint && option == game.currentFlag ? Color.green : Color.blue) // Highlight correct answer if hint is shown
                        .foregroundColor(.white)
                        .font(.title)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.vertical, 5)
            }
            
            Text("Правилни отговори: \(game.correctAnswerCount)")
                .font(.custom("Azbuki", size: 35))
                .bold()
                .padding()
                
            Text("Най-висок резултат: \(UserDefaults.standard.integer(forKey: "highestScore"))")
                .font(.custom("Azbuki", size: 35))
               

                .bold()
                .padding()
                

            Spacer()
        }
        .background(Color.mint)
    }
}

class FlagGuessingGame: ObservableObject {
    @Published var correctAnswerIndex = Int.random(in: 0..<3)
    @Published var userGuess = ""
    @Published var correctAnswerCount = 0
    @Published var currentLevel = 1
    @Published var timeRemaining = 10
    var timer: Timer?
    private var optionsLocked = false
    @Published var flagRotationAngle: Double = 0.0

    var currentFlag: String {
        countries[correctAnswerIndex]
    }
    
    var numberOfOptions: Int {
        return min(2 + currentLevel, countries.count)
    }
    
    var options: [String] {
        if optionsLocked {
            return _options
        } else {
            _options = generateOptions()
            return _options
        }
    }
    private var _options: [String] = []
    
    var correctAnswerSoundEffect: AVAudioPlayer?
    var wrongAnswerSoundEffect: AVAudioPlayer?

    init() {
        _options = generateOptions()
        
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
    
    private func generateOptions() -> [String] {
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
        _options = generateOptions()
        optionsLocked = false
        
        withAnimation {
            flagRotationAngle += 360.0 // Rotate flag image when changing
        }
        startTimer()
    }

    func resetOptions() {
        // Reset options to three
        currentLevel = 1
        _options = generateOptions()
        optionsLocked = false
        objectWillChange.send()
    }

    func startTimer() {
        timeRemaining = 10
        optionsLocked = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.checkAnswer(option: "")
            }
        }
    }

    func resetTimer() {
        timer?.invalidate()
        startTimer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
