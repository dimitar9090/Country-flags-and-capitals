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
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                        .padding(.top, geometry.safeAreaInsets.top) // Use geometry reader to access safeAreaInsets
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.top))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 2)
                    Spacer()
                    
                    NavigationLink(destination: ContentView()) {
                        Text("Знамена")
                            .padding(EdgeInsets(top: 50, leading: 100, bottom: 30, trailing: 100))
                            .font(.title)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: CapitalGameView()) {
                        Text("Столици")
                            .padding(EdgeInsets(top: 50, leading: 100, bottom: 30, trailing: 100))
                            .font(.title)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    OpeningPageView()
}
