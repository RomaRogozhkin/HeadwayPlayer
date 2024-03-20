//
//  ErrorView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 20.03.2024.
//

import SwiftUI

struct ErrorView: View {
    let text: String
    let action: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Text(text)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                    .font(.largeTitle)
                    .foregroundColor(.red)
                Button(action: action) {
                    Image(systemName: "hammer.circle.fill")
                        .font(.system(size: 250))
                }
                .foregroundColor(.black)

            }
        }
        .backgroundStyle(.background)
    }
}

#Preview {
    ErrorView(text: "Ooops something went wrong.\n Please try again later.") {
        print("test")
    }
}
