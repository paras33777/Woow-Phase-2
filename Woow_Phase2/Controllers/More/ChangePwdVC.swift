//
//  ChangePwdVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 12/12/21.
//

import UIKit
import SkyFloatingLabelTextField
import Lottie

class ChangePwdVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var oldPwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPwdTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPwdEye(_ sender: UIButton) {
        if sender.tag == 0 {
            oldPwdTxtField.isSecureTextEntry = !oldPwdTxtField.isSecureTextEntry
        } else if sender.tag == 1 {
            newPwdTxtField.isSecureTextEntry = !newPwdTxtField.isSecureTextEntry
        } else {
            confirmPwdTxtField.isSecureTextEntry = !confirmPwdTxtField.isSecureTextEntry
        }
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
    @IBAction func actionUpdate(_ sender: Any) {
        if oldPwdTxtField.isEmptyOrWhitespace() {
            self.view.makeToast("Please enter old password")
        } else if newPwdTxtField.isEmptyOrWhitespace() {
            self.view.makeToast("Please enter new password")
        } else if confirmPwdTxtField.isEmptyOrWhitespace() {
            self.view.makeToast("Please enter confirm new password")
        } else if newPwdTxtField.text! != confirmPwdTxtField.text! {
            self.view.makeToast("New and confirm password not matched")
        } else {
            var params = [String:Any]()
            params["oldpassword"] = oldPwdTxtField.text!
            params["newpassword"] = newPwdTxtField.text!
            
//            Hud.show(message: "", view: self.view)
            self.playAnimation()
            WebServices.post(url: .changePassword, jsonObject: params, method: .post, isEncoding: true) { data in
//                Hud.hide(view: self.view)
                self.stopAnimation()
                do {
                    let user = try JSONDecoder().decode(UserModel.self, from: data)
                    
                    if (user.success ?? false) {
                        self.oldPwdTxtField.text = ""
                        self.newPwdTxtField.text = ""
                        self.confirmPwdTxtField.text = ""
                        
                        Alert.show(message: user.message ?? "")
                    } else {
                        Alert.show(message: user.message ?? "")
                    }
                } catch {
                    print(error)
                }
            } failureHandler: { errorDict in
//                Hud.hide(view: self.view)
                self.stopAnimation()
                print(errorDict)
            }
        }
    }
}


// MARK:- API DELEGATE METHODS
extension ChangePwdVC {
    func apiCalled(api: Api, param: [String:Any]) {
        let sign = API.shared.sign()
        var params = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        for (key, value) in param {
            params[key] = value
        }
        
//        Hud.show(message: "", view: self.view)
        self.playAnimation()
//        WebServices.uploadData(url: api, jsonObject: params, method: .post) { (jsonDict) in
//            Hud.hide(view: self.view)
//            print(jsonDict)
//
//            if api == .profile_update {
//                if isSuccess(json: jsonDict) {
//                    if let user = ProfileIncoming(dict: jsonDict).user!.first {
//                        Alert.showSimple(user.msg ?? "")
//                    }
//                } else {
//                    Alert.showSimple(ProfileIncoming(dict: jsonDict).user?.first?.msg ?? "")
//                }
//            }
//        } failureHandler: { (errorDict) in
//            Hud.hide(view: self.view)
//            print(errorDict)
//        }
    }
}
