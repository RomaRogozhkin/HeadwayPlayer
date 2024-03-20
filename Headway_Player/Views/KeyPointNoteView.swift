//
//  KeyPointNoteView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI

struct KeyPointNoteView: View {
    let note: String
    var body: some View {
        Text(note)
            .font(.subheadline)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    KeyPointNoteView(note: "Hello, World!\nHello, World!")
}
