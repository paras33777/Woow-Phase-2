//
//  RoundImageView.swift
//  WooW
//
//  Created by Rahul Chopra on 03/05/21.
//

import Foundation
import UIKit

class RoundImageView: UIImageView {
    
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
