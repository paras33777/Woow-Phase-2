//
//  NSignupVC.swift
//  WooW
//
//  Created by Rahul Chopra on 05/12/21.
//

import UIKit
import FlagPhoneNumber
import IBAnimatable
import Lottie
class NSignupVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var confirmPwdTxtField: UITextField!
    @IBOutlet weak var eyeImgView: UIImageView!
    @IBOutlet weak var confirmEyeImgView: UIImageView!
    @IBOutlet weak var countryCodeBtn: AnimatableButton!
    var dobDate: Date?
    @IBOutlet weak var animationView: LottieAnimationView!

    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(eyePwdAction(tap:)))
        eyeImgView.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(eyeConfirmPwdAction(tap:)))
        confirmEyeImgView.addGestureRecognizer(tap1)
    }
    
    
    // MARK:- CORE METHODS
    func setupUI() {
        nameTxtField.attributes(placeholderColor: .white)
        phoneTxtField.attributes(placeholderColor: .white)
        emailTxtField.attributes(placeholderColor: .white)
        ageTxtField.attributes(placeholderColor: .white)
        pwdTxtField.attributes(placeholderColor: .white)
        confirmPwdTxtField.attributes(placeholderColor: .white)
        ageTxtField.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.ageTxtField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let calendar = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date())
            self.ageTxtField.text = "\(calendar.year ?? 0)"
            self.dobDate = datePicker.date
        }
        self.ageTxtField.resignFirstResponder()
    }
    
    @objc func eyePwdAction(tap: UITapGestureRecognizer) {
        self.pwdTxtField.isSecureTextEntry = !self.pwdTxtField.isSecureTextEntry
        eyeImgView.image = pwdTxtField.isSecureTextEntry ? UIImage(named: "ic_eye") : UIImage(named: "eye_n")
    }
    
    @objc func eyeConfirmPwdAction(tap: UITapGestureRecognizer) {
        self.confirmPwdTxtField.isSecureTextEntry = !self.confirmPwdTxtField.isSecureTextEntry
        confirmEyeImgView.image = confirmPwdTxtField.isSecureTextEntry ? UIImage(named: "ic_eye") : UIImage(named: "eye_n")
    }

    func openHomeVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NTabBarVC") as! NTabBarVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCountryCode(_ sender: Any) {
        let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
        let fpnField = FPNTextField()
        listController.setup(repository: fpnField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.countryCodeBtn.setTitle(country.phoneCode, for: .normal)
        }
        present(listController, animated: true, completion: nil)
    }
    
    @IBAction func actionGoogle(_ sender: Any) {
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
    @IBAction func actionRegister(_ sender: Any) {
        if nameTxtField.isEmpty() {
            self.view.makeToast("Please enter name")
        } else if phoneTxtField.isEmpty() {
            self.view.makeToast("Please enter phone number")
        } else if emailTxtField.isEmpty() {
            self.view.makeToast("Please enter email address")
        } else if !emailTxtField.isValidEmailAddress() {
            self.view.makeToast("Please enter valid email address")
        } else if dobDate == nil {
            self.view.makeToast("Please select date of birth")
        } else if pwdTxtField.isEmpty() {
            self.view.makeToast("Please enter password")
        } else if confirmPwdTxtField.isEmpty() {
            self.view.makeToast("Please enter confirm password")
        } else if pwdTxtField.text! != confirmPwdTxtField.text! {
            self.view.makeToast("Password and confirm password not matched")
        } else {
            var params = [String:Any]()
            params["name"] = nameTxtField.text!
            params["email"] = emailTxtField.text!
            params["password"] = pwdTxtField.text!
            params["mobile"] = phoneTxtField.text!
            params["countryCode"] = countryCodeBtn.titleLabel?.text ?? "+91"
            params["device_type"]  = "ios"
            params["device_token"] = UserDefaults.standard.string(forKey: "DeviceToken") as? String ?? ""
            params["build_no"] = Bundle.main.releaseVersionNumber as? String ?? ""
            params["device_uuid"] = UIDevice.current.identifierForVendor?.uuidString as? String ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd-MM-yyyy"
            params["dateOfBirth"] = dateFormatter.string(from: dobDate ?? Date())
            print(params)
            
//            Hud.show(message: "", view: self.view)
            self.playAnimation()
            WebServices.post(url: .signup, jsonObject: params, method: .post, isEncoding: true) { data in
//                Hud.hide(view: self.view)
                self.stopAnimation()
                do {
                    let user = try JSONDecoder().decode(UserModel.self, from: data)
                    
                    if (user.success ?? false) {
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
