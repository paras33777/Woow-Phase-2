//
//  OTPVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 26/04/22.
//

import UIKit
import Lottie

class OTPVC: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var otpMessageLbl: UILabel!
    @IBOutlet weak var codeView: VerificationCodeView!
    var user: UserModel.UserDetails?
    var closureDidVerified: (() -> ())?
    var otp: Int = 0
    var token: String = ""
    @IBOutlet weak var animationView: LottieAnimationView!

    
    // MARK: - VIEW METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        otpMessageLbl.text = "Enter the OTP you received to\n\(user?.countryCode ?? "") \(user?.phone ?? "")"
        sendOTP()
    }
    func playAnimation(){
        self.animationView.isHidden = false
        //        animationView = .init(name: "loading")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
    func stopAnimation(){
        self.animationView.isHidden = true
        animationView!.stop()
    }
    private func sendOTP() {
        let param = ["mobile": "\(user?.countryCode ?? "")\(user?.phone ?? "")"]
        
//        Hud.show(message: "", view: self.view)
        self.playAnimation()
        WebServices.post(url: .sendOTP, jsonObject: param, method: .post, isEncoding: true) { data in
//            Hud.hide(view: self.view)
            self.stopAnimation()
            do {
                let user = try JSONDecoder().decode(OTPVerifyModel.self, from: data)
                
                if (user.success ?? false) {
                    self.view.makeToast(user.message ?? "")
                    self.otp = user.body?.otp ?? 0
                } else {
                    self.view.makeToast(user.message ?? "")
                }
            } catch {
                print(error)
            }
        } failureHandler: { errorDict in
//            Hud.hide(view: self.view)
            self.stopAnimation()
            print(errorDict)
        }
    }
    

    // MARK: - IBACTIONS
    @IBAction func actionContinue(_ sender: Any) {
        if codeView.otpString.isEmpty {
            self.view.makeToast("Please enter otp")
        } else {
            if codeView.otpString == "\(otp)" {
                
//                Hud.show(message: "", view: self.view)
                self.playAnimation()
                WebServices.post(url: .verifyOTP, jsonObject: [:], method: .get, isEncoding: false) { data in
//                    Hud.hide(view: self.view)
                    self.stopAnimation()
                    do {
                        let user = try JSONDecoder().decode(OTPVerifyModel.self, from: data)
                        
                        if (user.success ?? false) {
                            self.closureDidVerified?()
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            Alert.show(message: user.message ?? "")
                        }
                    } catch {
                        print(error)
                    }
                } failureHandler: { errorDict in
//                    Hud.hide(view: self.view)
                    self.stopAnimation()
                    print(errorDict)
                }
                
            } else {
                self.view.makeToast("OTP not matched")
            }
        }
    }
    
    @IBAction func actionResendOTP(_ sender: Any) {
        sendOTP()
    }
}
