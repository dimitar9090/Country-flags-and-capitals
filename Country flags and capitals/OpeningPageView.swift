//
//  OpeningPageView.swift
//  Country flags and capitals
//
//  Created by Dimitar Angelov on 8.05.24.
//
import SwiftUI

struct OpeningPageView: View {
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    Spacer()
                    Text("Изберете игра")
                        .font(.custom("Troika", size: 42))
                        .foregroundColor(.accentColor)
                        .padding( geometry.safeAreaInsets.top) // Use geometry reader to access safeAreaInsets
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.edgesIgnoringSafeArea(.top))
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 2)
                    
                    Image("worldmap")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.6)
                            .cornerRadius(200)
                    
                    Spacer()
                    
                    NavigationLink(destination: ContentView()) {
                        Text("Знамена")
                            .padding(EdgeInsets(top: 50, leading: 100, bottom: 30, trailing: 100))
                            .font(.custom("Azbuki", size: 35))
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: CapitalGameView()) {
                        Text("Столици")
                            .padding(EdgeInsets(top: 50, leading: 100, bottom: 30, trailing: 100))
                            .font(.custom("Azbuki", size: 35))
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.yellow) // Change the background color here
            }
        }
    }
}
#Preview {
    OpeningPageView()
}
