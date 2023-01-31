//
//  NLoginVC.swift
//  WooW
//
//  Created by Rahul Chopra on 04/12/21.
//

import UIKit
import GoogleSignIn
import Lottie
class NLoginVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var eyeImgView: UIImageView!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
//        emailTxtField.text = "nikhilsani311@gmail.com"
//        pwdTxtField.text = "12345678"
        
        self.setupUI()
    }
    
    
    // MARK:- CORE METHODS
    func setupUI() {
        emailTxtField.attributes(placeholderColor: .white)
        pwdTxtField.attributes(placeholderColor: .white)
    }
    
    func openHomeVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NTabBarVC") as! NTabBarVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionEye(_ sender: Any) {
        pwdTxtField.isSecureTextEntry = !pwdTxtField.isSecureTextEntry
        eyeImgView.image = pwdTxtField.isSecureTextEntry ? UIImage(named: "ic_eye") : UIImage(named: "eye_n")
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NSignupVC") as! NSignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionForgotPwd(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPwdVC") as! ForgotPwdVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func actionGoogle(_ sender: Any) {
//        GIDSignIn.sharedInstance()?.signOut()
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.delegate = self
//        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func actionFacebook(_ sender: Any) {
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
    func yesNo(status:String){

        let parameters = "{\n    \"device_type\": \"ios\",\n    \"device_token\": \"\( UserDefaults.standard.string(forKey: "DeviceToken") as? String ?? "")\",\n    \"device_uuid\": \"\(UIDevice.current.identifierForVendor?.uuidString as? String ?? "")\",\n    \"build_no\": \"\(Bundle.main.releaseVersionNumber as? String ?? "")\",\n    \"login_status\": \"\(status)\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(baseUrl)auth/accept-logout")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(UserData.Token ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }

        task.resume()
    }
    @IBAction func actionLogin(_ sender: Any) {
        if emailTxtField.isEmpty() {
            Alert.showSimple("Please enter email address")
        } else if !emailTxtField.isValidEmailAddress() {
            Alert.showSimple("Please enter valid email address")
        } else if pwdTxtField.isEmpty() {
            Alert.showSimple("Please enter password")
        }
        
//        let sign = API.shared.sign()
        let param = ["email": emailTxtField.text ?? "",
                     "password": pwdTxtField.text ?? "",
                     "device_type": "ios",
                     "device_token": UserDefaults.standard.string(forKey: "DeviceToken") as? String ?? "",
                     "build_no":Bundle.main.releaseVersionNumber as? String ?? "",
                     "device_uuid":UIDevice.current.identifierForVendor?.uuidString as? String ?? ""
//                     "salt": API.shared.salt,
//                     "sign": sign
                    ] as [String : Any]

        print(param)
//        Hud.show(message: "", view: self.view)
        self.playAnimation()
        WebServices.post(url: .login, jsonObject: param, method: .post, isEncoding: true) { data in
//            Hud.hide(view: self.view)
            self.stopAnimation()
            do {
//                let data = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                let user = try JSONDecoder().decode(UserModel.self, from: data)
                
                if (user.success ?? false) {
                    
                    if (user.body?.userDetails?.phoneVerification ?? 0) == 1 {
                        // Phone Verification Verified
                        if (user.body?.already_login ?? 0) == 1{
                            UserData.Token = user.body?.token ?? ""

                            Alert.show(message: "Are you sure you want to logout previous device?", actionTitle1: "Yes", actionTitle2: "No", alertStyle: .alert, completionOK: {
                                self.yesNo(status: "yes")
                                UserData.Token = user.body?.token ?? ""
                                UserData.User = user.body?.userDetails
                                self.openHomeVC()
                            }, completionCancel: {
                                self.yesNo(status: "no")
                                UserData.User = nil
                                UserData.Token = nil

                                
                            })
                        }else{
                            UserData.Token = user.body?.token ?? ""
                            UserData.User = user.body?.userDetails
                            self.openHomeVC()
                        }
                        
                        /*let msg = "We advise you to verify your number by visiting Profile Section from the side bar. In case any problem occur, contact support."
                        Alert.show(message: msg, completionOK: ({
                            self.openHomeVC()
                        }))*/
                    } else {
                        // Phone Verification Not Verified
                        UserData.Token = user.body?.token ?? ""
                        
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OTPVC") as? OTPVC {
                            vc.user = user.body?.userDetails
                            vc.modalPresentationStyle = .overCurrentContext
                            vc.closureDidVerified = {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    UserData.User = user.body?.userDetails
                                    self.openHomeVC()
                                    
                                    /*let msg = "We advise you to verify your number by visiting Profile Section from the side bar. In case any problem occur, contact support."
                                    Alert.show(message: msg, completionOK: ({
                                        self.openHomeVC()
                                    }))*/
                                }
                            }
                            self.present(vc, animated: true, completion: nil)
                        }
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


// MARK:- GOOGLE SIGN IN DELEGATE METHODS
//extension NLoginVC: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let err = error {
//            self.dismiss(animated: true) {
////                Helper.showAlert(withTitle: "", withDescription: err.localizedDescription)
//            }
//        } else {
////            self.socialEmail = user.profile.email
////            self.socialName = user.profile.name
////            self.socialId = user.userID
////            self.login(socialEmail: user.profile.email, socialToken: user.userID, name: user.profile.name)
//        }
//    }
//    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        self.dismiss(animated: true, completion: nil)
//    }
//}
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
