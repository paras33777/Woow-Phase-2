//
//  ForgotPwdVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 27/04/22.
//

import UIKit
import Lottie

class ForgotPwdVC: UIViewController {
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var animationView: LottieAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - IBACTIONS
    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    @IBAction func actionSend(_ sender: Any) {
        if emailTxtField.isEmpty() {
            self.view.makeToast("Please enter email address")
            return
        } else if !emailTxtField.isValidEmailAddress() {
            self.view.makeToast("Please enter valid email address")
            return
        }
        
        let param = ["email": emailTxtField.text!]
        
//        Hud.show(message: "", view: self.view)
        self.playAnimation()
        WebServices.post(url: .forgotPassword, jsonObject: param, method: .post, isEncoding: true) { data in
//            Hud.hide(view: self.view)
            self.stopAnimation()
            do {
                let user = try JSONDecoder().decode(UserModel.self, from: data)
                
                if (user.success ?? false) {
                    self.view.makeToast(user.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    Alert.show(message: user.message ?? "")
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
}
