//
//  GameOverView.swift
//  EntityWorkshop
//
//  Created by Justin Chang on 8/31/24.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.extraLargeTitle)
                .fontWeight(.bold)

            Button("Main Menu") {}
            Button("Restart") {}
        }
    }
}

#Preview {
    GameOverView()
}
