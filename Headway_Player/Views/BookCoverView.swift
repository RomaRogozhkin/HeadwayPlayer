//
//  BookCoverView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI

private enum Constants {
    static let cornerRadius: CGFloat = 12
    static let placeholderImageName: String = "text.book.closed"
}

struct BookCoverView: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .cornerRadius(Constants.cornerRadius)
        } placeholder: {
            Image(systemName: Constants.placeholderImageName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.secondary)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .foregroundStyle(.fill)
                }
        }
        .padding()
    }
}

#Preview {
    BookCoverView(url: nil)
}
