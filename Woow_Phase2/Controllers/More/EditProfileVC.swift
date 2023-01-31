//
//  EditProfileVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 10/12/21.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import Lottie

class EditProfileVC: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var userImgView: RoundImageView!
    @IBOutlet weak var emailTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var nameTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var genderTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTxtField: SkyFloatingLabelTextField!
    @IBOutlet weak var animationView: LottieAnimationView!
    var selectedImage: UIImage?
    var user: ProfileIncoming.User?
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        showInfoOnUI()
    }
    
    func showInfoOnUI() {
//        nameLbl.text = Cookies.userInfo()!.name
//        emailLbl.text = Cookies.userInfo()!.email
//        userImgView.showImage(imgURL: Cookies.userInfo()?.user_image ?? "", placeholderImage: "dummy_user", isMode: true)
        userImgView.showImage(imgURL: userImageBaseUrl + (UserData.User?.userImage ?? ""), placeholderImage: "dummy_user", isFullURL: true)
        emailTxtField.text = UserData.User?.email
        nameTxtField.text = UserData.User?.name
        phoneTxtField.text = UserData.User?.phone
//        genderTxtField.text = UserData.User.gen
        emailTxtField.setLeftPaddingPoints(0)
        genderTxtField.text = UserData.User?.gender ?? ""
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionChangeAvatar(_ sender: Any) {
        PhotoPicker.shared.showPicker()
        PhotoPicker.shared.closureDidGetImage = { image in
            self.selectedImage = image
            self.userImgView.image = image
        }
    }
    
    @IBAction func actionSave(_ sender: DesignableButton) {
        if nameTxtField.isEmptyOrWhitespace() {
            self.view.makeToast("Please enter full name")
        } else if emailTxtField.isEmptyOrWhitespace() {
            self.view.makeToast("Please enter email")
        } else if phoneTxtField.isEmptyOrWhitespace() {
            self.view.makeToast("Please enter phone")
        } else if genderTxtField.isEmptyOrWhitespace() {
            self.view.makeToast("Please enter gender")
        } else {
            
            var params = [String:Any]()
            params["user_id"] = UserData.User?.id ?? 0
            params["name"] = nameTxtField.text ?? ""
            params["email"] = emailTxtField.text ?? ""
            params["phone"] = phoneTxtField.text ?? ""
            params["country_code"] = "+91"
            params["user_address"] = "punjab"
            params["family_content"] = "Mr"
            params["gender"] = genderTxtField.text ?? ""
            if selectedImage != nil {
                self.uploadImage(params: params, image: selectedImage!)
            } else {
//                self.apiCalled(api: .updateProfile, param: params, method: .post)
                params["user_image"] = UserData.User?.userImage ?? ""
                self.editProfile(params: params)
            }
        }
    }
}



// MARK: - API IMPLEMENTATIONS
extension EditProfileVC {
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
    func apiCalled(api: Api, param: [String:Any], method: HTTPMethod) {
        let sign = API.shared.sign()
        var params = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        for (key, value) in param {
            params[key] = value
        }

        print(params)
//        Hud.show(message: "", view: self.view)
        self.playAnimation()
        WebServices.post(url: api, jsonObject: param, method: method, isEncoding: false) { jsonData in
//            Hud.hide(view: self.view)
            self.stopAnimation()
            
            do {
                let searchListModel = try JSONDecoder().decode(UserModel.self, from: jsonData)
                if (searchListModel.success ?? false) {
                    
                    
                } else {
                    Alert.show(message: searchListModel.message ?? "")
                }
            } catch {
                print(error)
            }
        } failureHandler: { errorJson in
//            Hud.hide(view: self.view)
            self.stopAnimation()

        }
    }
    
    func editProfile(params: [String:Any]) {
        WebServices.uploadSingle(url: .updateProfile, jsonObject: params, profiePic: nil) { jsonData in
//            Hud.hide(view: self.view)
            self.stopAnimation()

            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] ?? [:]
                print(json)
                
                let userModel = try JSONDecoder().decode(UserModel.self, from: jsonData)
                if (userModel.success ?? false) {
                    UserData.User = userModel.body?.userDetails
                    Alert.show(message: userModel.message ?? "")
                } else {
                    Alert.show(message: userModel.message ?? "")
                }
            } catch {
                print(error)
            }
        } failureHandler: { (errorDict) in
//            Hud.hide(view: self.view)
            self.stopAnimation()

            print(errorDict)
        }
    }
    
    /*func openSubscriptionList(subscriptions: [SubscriptionPlanIncoming.Subscription]) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionListVC") as? SubscriptionListVC {
            vc.modalPresentationStyle = .overFullScreen
            vc.subscriptions = subscriptions
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }*/
    
    func uploadImage(params: [String:Any], image: UIImage?) {
        let sign = API.shared.sign()
        var params1 = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        for (key, value) in params {
            params1[key] = value
        }
        
//        Hud.show(message: "", view: self.view)
        self.playAnimation()
        WebServices.uploadSingle(url: .uploadingImage, jsonObject: [:], profiePic: image) { jsonData in
//            Hud.hide(view: self.view)
            self.stopAnimation()

            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] ?? [:]
                print(json)
                
                if let code = json["code"] as? Int {
                    if code == 200 {
                        if let body = json["body"] as? String {
                            var par = params
                            par["user_image"] = body
//                            self.apiCalled(api: .updateProfile, param: par, method: .post)
                            self.editProfile(params: par)
                        }
                    }
                }
            } catch {
                print(error)
            }
        } failureHandler: { (errorDict) in
//            Hud.hide(view: self.view)
            self.stopAnimation()

            print(errorDict)
        }

//        WebServices.uploadDataWithImg(url: .profile_update, jsonObject: params1, image: image, imageKey: "user_image") { (jsonDict) in
//            Hud.hide(view: self.view)
//            print(jsonDict)
//
//            if isSuccess(json: jsonDict) {
//                if let json = ProfileIncoming(dict: jsonDict).user, let first = json.first {
//                    self.apiCalled(api: .profile, param: ["user_id": Cookies.userInfo()?.user_id ?? 0])
//                    self.view.makeToast(first.msg ?? "")
//                }
//            } else {
//                self.view.makeToast(message(json: jsonDict))
//            }
//
//        } failureHandler: { (errorDict) in
//            Hud.hide(view: self.view)
//            print(errorDict)
//        }

    }
}

