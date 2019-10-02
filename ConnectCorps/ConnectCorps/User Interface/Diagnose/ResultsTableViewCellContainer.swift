//
//  ResultsTableViewCellContainer.swift
//

import UIKit

enum TweakColor: CaseIterable {
    case lightGreen
//    case darkGreen
    case lightBlue
    case lightYellow
//    case darkYellow
    case lightRed
//    case darkRed
    case lightPurple
//    case darkPurple
    case lightPink

    private var rawColors: (start: UIColor, end: UIColor, shadow: UIColor) {
        // this is more consolidated than having three separate `switch` statements
        switch self {
        case .lightGreen:
            return (
                start: UIColor(red: 0.26, green: 0.9, blue: 0.58, alpha: 1),
                end: UIColor(red: 0.23, green: 0.7, blue: 0.72, alpha: 1),
                shadow: UIColor(red: 0.31, green: 0.89, blue: 0.76, alpha: 1)
            )
//        case .darkGreen:
//            return (
//                start: UIColor(red: 0.24, green: 0.74, blue: 0.65, alpha: 1),
//                end: UIColor(red: 0.12, green: 0.41, blue: 0.26, alpha: 1),
//                shadow: UIColor(red: 0.18, green: 0.58, blue: 0.46, alpha: 1)
//            )
        case .lightBlue:
            return (
                start: UIColor(red: 0.09, green: 0.92, blue: 0.85, alpha: 1),
                end: UIColor(red: 0.38, green: 0.47, blue: 0.92, alpha: 1),
                shadow: UIColor(red: 0.24, green: 0.69, blue: 0.88, alpha: 1)
            )
        case .lightYellow:
            return (
                start: UIColor(red: 0.99, green: 0.89, blue: 0.54, alpha: 1),
                end: UIColor(red: 0.95, green: 0.51, blue: 0.51, alpha: 1),
                shadow: UIColor(red: 0.97, green: 0.68, blue: 0.52, alpha: 1)
            )
//        case .darkYellow:
//            return (
//                start: UIColor(red: 0.84, green: 0.75, blue: 0.39, alpha: 1),
//                end: UIColor(red: 0.56, green: 0.24, blue: 0.14, alpha: 1),
//                shadow: UIColor(red: 0.56, green: 0.24, blue: 0.14, alpha: 1)
//            )
        case .lightRed:
            return (
                start: UIColor(red: 1, green: 0.46, blue: 0.46, alpha: 1),
                end: UIColor(red: 0.96, green: 0.31, blue: 0.64, alpha: 1),
                shadow: UIColor(red: 0.98, green: 0.38, blue: 0.55, alpha: 1)
            )
//        case .darkRed:
//            return (
//                start: UIColor(red: 0.77, green: 0.2, blue: 0.39, alpha: 1),
//                end: UIColor(red: 0.38, green: 0.15, blue: 0.45, alpha: 1),
//                shadow: UIColor(red: 0.56, green: 0.17, blue: 0.42, alpha: 1)
//            )
        case .lightPurple:
            return (
                start: UIColor(red: 0.85, green: 0.51, blue: 0.78, alpha: 1),
                end: UIColor(red: 0.62, green: 0.23, blue: 0.9, alpha: 1),
                shadow: UIColor(red: 0.62, green: 0.23, blue: 0.9, alpha: 1)
            )
//        case .darkPurple:
//            return (
//                start: UIColor(red: 0.4, green: 0.47, blue: 0.61, alpha: 1),
//                end: UIColor(red: 0.37, green: 0.15, blue: 0.39, alpha: 1),
//                shadow: UIColor(red: 0.38, green: 0.31, blue: 0.5, alpha: 1)
//            )
        case .lightPink:
            return (
                start: UIColor(red: 0.95, green: 0.73, blue: 0.77, alpha: 1),
                end: UIColor(red: 0.78, green: 0.33, blue: 0.5, alpha: 1),
                shadow: UIColor(red: 0.88, green: 0.56, blue: 0.65, alpha: 1)
            )
        }
    }

    var start: UIColor { return rawColors.start }
    var end: UIColor { return rawColors.end }
    var shadow: UIColor { return rawColors.shadow }
}

class ResultsTableViewCellContainer: UIView {

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    var color: TweakColor! {
        didSet {
            updateGradientColor()
        }
    }

    func updateGradientColor() {
        gradientLayer.colors = [
            color.start.cgColor,
            color.end.cgColor
        ]
        layer.shadowColor = color.shadow.cgColor
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 44
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowRadius = 6

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }

}
