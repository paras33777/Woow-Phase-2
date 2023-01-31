//
//  ButtonDesignable.swift
//  WooW
//
//  Created by Rahul Chopra on 28/04/21.
//

import Foundation
import UIKit

@IBDesignable class DesignableButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = .white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
}
