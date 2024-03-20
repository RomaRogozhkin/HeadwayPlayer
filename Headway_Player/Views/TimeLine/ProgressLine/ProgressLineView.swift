//
//  ProgressLineView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 16.03.2024.
//

import SwiftUI

struct ProgressLineView: View {
    @Binding var progress: Float
    var bounds: ClosedRange<Int>

    var body: some View {
        UISliderView(value: $progress, bounds: bounds)
    }
}

#Preview {
    ProgressLineView(progress: .constant(0), bounds: 0...55)
}
