//
//  VerificationCodeView.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 26/04/22.
//

import Foundation
import UIKit

@IBDesignable
class VerificationCodeView: UIView {
    
    lazy private var txtFields = [UITextField]()
    private var stackView: UIStackView!
    @IBInspectable var iPhoneSpacing: CGFloat = 5 {
        didSet {
            self.updateViewSpacing()
        }
    }
    @IBInspectable var iPadSpacing: CGFloat = 5 {
        didSet {
            self.updateViewSpacing()
        }
    }
    @IBInspectable var iPadRadius: CGFloat = 5 {
        didSet {
            self.updateViewRadius()
        }
    }
    @IBInspectable var iPhoneRadius: CGFloat = 5 {
        didSet {
            self.updateViewRadius()
        }
    }
    @IBInspectable var iPhoneFontSize: CGFloat = 5 {
        didSet {
            self.updateFontSize()
        }
    }
    @IBInspectable var iPadFontSize: CGFloat = 5 {
        didSet {
            self.updateFontSize()
        }
    }
    var otpString: String = ""
    
    
    // MARK:- LIFE CYCLE METHODS
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateUI()
    }
    
    
    private func updateUI() {
        self.setupStackView()
        
        for i in 0...3 {
            let codeTxtField = UITextField()
            codeTxtField.tag = i
//            codeTxtField.font = AppFonts.SFProDisplayBold.withSize(25.0)
            codeTxtField.textColor = .white
            codeTxtField.textAlignment = .center
            codeTxtField.keyboardType = .numberPad
            codeTxtField.backgroundColor = .systemGray
            codeTxtField.layer.masksToBounds = true
            self.updateViewRadius()
            txtFields.append(codeTxtField)
            stackView.addArrangedSubview(txtFields[i])
            NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notificaiton:)), name: UITextField.textDidChangeNotification, object: codeTxtField)
        }
        self.updateFontSize()
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        self.updateViewSpacing()
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func updateViewSpacing() {
        stackView.spacing = iPhoneSpacing
    }
    
    private func updateViewRadius() {
        txtFields.forEach({$0.layer.cornerRadius = iPhoneSpacing})
    }
    
    private func updateFontSize() {
        txtFields.forEach({$0.font?.withSize(iPhoneFontSize)})
    }
    
    private func getOTPString() {
        let otpStrArr = txtFields.map({$0.text!})
        otpString = otpStrArr.count == 4 ? otpStrArr.joined(separator: "") : ""
    }
    
    @objc func textDidChange(notificaiton: NSNotification) {
        if let txtField = notificaiton.object as? UITextField {
            txtField.backgroundColor = txtField.text == "" ? UIColor.systemGray : .black
            
            switch txtField.tag {
            case 0:
                if (txtField.text!.count - 1) >= 1 {
                    txtFields[0].text = "\(txtField.text?.last ?? Character(""))"
                    txtFields[1].becomeFirstResponder()
                } else {
                    if !txtField.text!.isEmpty {
                        txtFields[1].becomeFirstResponder()
                    }
                }
                
            case 1:
                if (txtField.text!.count - 1) >= 1 {
                    txtFields[1].text = "\(txtField.text?.last ?? Character(""))"
                    txtFields[2].becomeFirstResponder()
                } else {
                    if !txtField.text!.isEmpty {
                        txtFields[2].becomeFirstResponder()
                    } else {
                        txtFields[0].becomeFirstResponder()
                    }
                }
                
            case 2:
                if (txtField.text!.count - 1) >= 1 {
                    txtFields[2].text = "\(txtField.text?.last ?? Character(""))"
                    txtFields[3].becomeFirstResponder()
                } else {
                    if !txtField.text!.isEmpty {
                        txtFields[3].becomeFirstResponder()
                    } else {
                        txtFields[1].becomeFirstResponder()
                    }
                }
                
            case 3:
                if (txtField.text!.count - 1) >= 1 {
                    txtFields[3].text = "\(txtField.text?.last ?? Character(""))"
                    txtFields[3].resignFirstResponder()
                } else {
                    if !txtField.text!.isEmpty {
                        txtFields[3].resignFirstResponder()
                    } else {
                        txtFields[2].becomeFirstResponder()
                    }
                }
                
            default:
                break
            }
            
            self.getOTPString()
        }
    }
}
