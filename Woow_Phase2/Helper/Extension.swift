//
//  Extension.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 08/12/21.
//

import Foundation
import UIKit
import CommonCrypto
import CryptoKit
import SkyFloatingLabelTextField

extension UITextField {
    func isEmpty() -> Bool {
        if text == "" || text == " " {
            return true
        }
        return false
    }
    
    func isEmptyOrWhitespace() -> Bool {
        if(self.text!.isEmpty) {
            return true
        }
        return (self.text!.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
    
    func isValidEmailAddress() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self.text!)
    }
    
    func attributes(placeholderColor: UIColor = .white, padding: CGFloat? = nil, imageName: UIImage? = nil, borderColor: UIColor = .white, tintColor: UIColor? = nil, width: CGFloat? = nil) {
        self.placeholderColor(color: placeholderColor)
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 40, y: 0, width: amount, height: self.frame.size.height))
        paddingView.backgroundColor = .clear
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func placeholderColor(color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    func bottomBorderLine(color: UIColor = .white, width: CGFloat? = nil) {
        let bottomLine = CALayer()
        var wid: CGFloat = 0.0
        if width != nil {
            wid = width!
        } else {
            wid = UIScreen.main.bounds.width - 70
        }
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: wid, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
    
    /*@discardableResult
    func setRightPaddingPoints(_ amount:CGFloat) -> UIView {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: amount))
        paddingView.backgroundColor = .clear
        self.rightView = paddingView
        self.rightViewMode = .always
        return paddingView
    }
    
    func addRightImage(imageName: UIImage?, tintColor: UIColor? = nil) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 22))
        button.setImage(imageName, for: .normal)
        let rightView1 = self.setRightPaddingPoints(20)
        rightView1.backgroundColor = .clear
        rightView1.addSubview(button)
        self.tintColor = tintColor != nil ? tintColor : .clear
        return button
    }*/
    
    func addInputViewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        
        //Add DatePicker as inputView
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.maximumDate = Date()
        self.inputView = datePicker
        
        //Add Tool Bar as input AccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelPressed() {
        self.resignFirstResponder()
    }
}


extension SkyFloatingLabelTextField {
    @objc @discardableResult
    func setRightPaddingPoints(_ amount:CGFloat) -> UIView {
        let paddingView = UIView(frame: CGRect(x: self.frame.size.width - amount, y: 0, width: amount, height: amount))
        paddingView.backgroundColor = .clear
        self.leftView = nil
        self.rightView = paddingView
        self.rightViewMode = .always
        return paddingView
    }
    
    func addRightImage(imageName: UIImage?, tintColor: UIColor? = nil) -> UIButton {
        let button = UIButton(frame: CGRect(x: self.frame.size.width, y: 0, width: 25, height: 22))
        button.setImage(imageName, for: .normal)
        let rightView1 = self.setRightPaddingPoints(20)
        rightView1.backgroundColor = .clear
        rightView1.addSubview(button)
        self.tintColor = tintColor != nil ? tintColor : .clear
        return button
    }
}


extension UITextView {
    func isEmptyOrWhitespace() -> Bool {
        if(self.text!.isEmpty) {
            return true
        }
        return (self.text!.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
}


extension String {
    var md5: String {
        if #available(iOS 13.0, *) {
            guard let d = self.data(using: .utf8) else { return ""}
            let digest = Insecure.MD5.hash(data: d)
            let h = digest.reduce("") { (res: String, element) in
                let hex = String(format: "%02x", element)
                //print(ch, hex)
                let  t = res + hex
                return t
            }
            return h
            
        } else {
            // Fall back to pre iOS13
            let length = Int(CC_MD5_DIGEST_LENGTH)
            var digest = [UInt8](repeating: 0, count: length)
            
            if let d = self.data(using: .utf8) {
                _ = d.withUnsafeBytes { body -> String in
                    CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
                    return ""
                }
            }
            let result = (0 ..< length).reduce("") {
                $0 + String(format: "%02x", digest[$1])
            }
            return result
        }
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return try NSMutableAttributedString(data: data,
                                                  options: [.documentType: NSMutableAttributedString.DocumentType.html,
                                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                                  documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var htmlStripped : String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
    
    func embedYoutubeLink() -> String {
        let str = self.components(separatedBy: "src=\"").last!
        let srcStr = str.components(separatedBy: "\"")[0]
        return srcStr
    }
    
    func convertToYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date!)
    }
}



extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}


extension UILabel {
    func roundCorner(rect: UIRectCorner, roundCorner: CGFloat) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: rect,
                                     cornerRadii: CGSize(width: roundCorner, height: roundCorner))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}


// MARK:- VIEW CONTROLLER
extension UIViewController {
    func moveToSpecificVC(vc: UIViewController) {
        if let navVC = self.navigationController {
            for each in navVC.viewControllers {
                if each.classForCoder == vc.classForCoder {
                    self.navigationController?.popToViewController(each, animated: true)
                    break
                }
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func openSignInScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NLoginVC") as! NLoginVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    
    func add(_ parent: UIViewController, containerView: UIView) {
        if let homeVC = parent as? NHomeVC {
            
        }
        self.view.frame = containerView.bounds
        parent.addChild(self)
        containerView.addSubview(view)
        didMove(toParent: parent)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func setValueInUserDefaults(objValue:String,for key:String){
        let userDefault = UserDefaults.standard
        userDefault.set(objValue, forKey: key)
        userDefault.synchronize()
    }
}


extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        UIColor().getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return NSString(format:"#%06x", rgb) as String
    }
}
