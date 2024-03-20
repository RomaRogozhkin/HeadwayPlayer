//
//  UISliderView.swift
//  Headway_Player
//
//  Created by Roma Rohozhkin on 19.03.2024.
//

import SwiftUI
import Foundation

fileprivate enum Constants {
    static let trackHeight: CGFloat = 6
    static let trackMaxColor: UIColor = .lightGray.withAlphaComponent(0.4)
}

final class HDSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var original = super.trackRect(forBounds: bounds)
        original.size.height = Constants.trackHeight
        return original
    }
}

struct UISliderView: UIViewRepresentable {
    @Binding var value: Float
    var bounds: ClosedRange<Int>

    private let thumbColor: UIColor = .hdPrimary
    private let minTrackColor: UIColor = .hdPrimary
    private let maxTrackColor: UIColor = Constants.trackMaxColor

    final class Coordinator: NSObject {
        var value: Binding<Float>

        init(value: Binding<Float>) {
            self.value = value
        }

        @objc func valueChanged(_ sender: HDSlider) {
            self.value.wrappedValue = round(sender.value)
        }
    }

    func customizeSlider(_ slider: HDSlider) {
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.minimumValue = Float(bounds.lowerBound)
        slider.maximumValue = Float(bounds.upperBound)
        slider.value = value
        slider.isContinuous = false
    }

    func makeUIView(context: Context) -> HDSlider {
        let slider = HDSlider(frame: .zero)
        customizeSlider(slider)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }

    func updateUIView(_ slider: HDSlider, context: Context) {
        customizeSlider(slider)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
    }

    func makeCoordinator() -> UISliderView.Coordinator {
        Coordinator(value: $value)
    }
}
