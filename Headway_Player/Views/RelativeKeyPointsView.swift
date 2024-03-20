//
//  RelativeKeyPointsView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI

struct RelativeKeyPointsView: View {
    let currentPoint: UInt
    let totalPoints: UInt

    var body: some View {
        Text("key point \(currentPoint) of \(totalPoints)")
            .textCase(.uppercase)
            .foregroundStyle(.secondary)
            .fontWeight(.bold)
            .font(.footnote)
    }
}

#Preview {
    RelativeKeyPointsView(currentPoint: 2, totalPoints: 10)
}
