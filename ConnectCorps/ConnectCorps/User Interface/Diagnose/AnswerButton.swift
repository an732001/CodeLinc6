//
//  AnswerButton.swift
//

import UIKit

class AnswerButton: UIControl {

    // TL: 62d9e3
    // BR: 00aeff

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        buttonify()

        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [
            UIColor(red: 0.38, green: 0.85, blue: 0.89, alpha: 1).cgColor,
            UIColor(red: 0, green: 0.68, blue: 1, alpha: 1).cgColor
        ]
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }

}
