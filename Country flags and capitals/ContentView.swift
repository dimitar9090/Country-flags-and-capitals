import SwiftUI

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
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Image(game.currentFlag)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .padding()
            
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
                .padding(.vertical, 5)
            }
            
            if game.showingAlert {
                Text(game.isCorrect ? "Correct answer!" : "Incorrect answer!")
                    .padding()
            }
            
            Spacer()
        }
    }
}

class FlagGuessingGame: ObservableObject {
    let countries = ["USA", "UK", "France", "Germany", "Italy"]
    @Published var correctAnswerIndex = Int.random(in: 0..<3)
    @Published var userGuess = ""
    @Published var showingAlert = false
    
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
    
    var isCorrect: Bool {
        userGuess == currentFlag
    }
    
    func checkAnswer(option: String) {
        userGuess = option
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
