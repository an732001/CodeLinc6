//
//  ResizableImageButton.swift
//

import UIKit

class ResizableImageButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let imageSize = imageView?.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: imageSize.width + imageEdgeInsets.left + imageEdgeInsets.right, height: imageSize.height + imageEdgeInsets.top + imageEdgeInsets.bottom)
        
        return desiredButtonSize
    }
}
