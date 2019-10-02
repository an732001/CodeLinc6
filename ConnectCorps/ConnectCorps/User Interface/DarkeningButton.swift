//
//  DarkeningButton.swift
//

import UIKit

class DarkeningButton: UIButton {
    
    var _originalBackgroundColor: UIColor?
    
    override var isHighlighted: Bool {
        willSet {
            if !isHighlighted { _originalBackgroundColor = backgroundColor }
        } didSet {
            guard let _backgroundColor = _originalBackgroundColor else { return }
            backgroundColor = isHighlighted ? _backgroundColor.darkened(by: 15) : _backgroundColor
        }
    }
}
