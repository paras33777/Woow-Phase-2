//
//  NMoreVC.swift
//  WooW
//
//  Created by Rahul Chopra on 07/12/21.
//

import UIKit
import Alamofire
import Lottie

class NMoreVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var userImgView: RoundImageView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var moreModels = [MoreSectionModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moreModels.append(MoreSectionModel(name: "General Settings", item: [MoreSectionModel.MoreItemModel(name: "Account Setting", image: "Icon - box", action: .accountSetting), MoreSectionModel.MoreItemModel(name: "Language", image: "Icon - box-1", action: .language), MoreSectionModel.MoreItemModel(name: "FAQ", image: "Icon - box-2", action: .help), MoreSectionModel.MoreItemModel(name: "My Plans", image: "subscription", action: .myPlans), MoreSectionModel.MoreItemModel(name: "Kids", image: "parental-control", action: .kids)]))
        
        moreModels.append(MoreSectionModel(name: "Terms", item: [MoreSectionModel.MoreItemModel(name: "Terms & Condition", image: "", action: .terms), MoreSectionModel.MoreItemModel(name: "Privacy & Policy", image: "", action: .privacy), MoreSectionModel.MoreItemModel(name: UserData.User != nil ? "Logout" : "Login", image: "", action: .logout)]))
        
        self.apiCalled(api: .myDetails, param: [:], method: .get, isEncoding: false)
        self.showInfoOnUI()
    }
    
    func showInfoOnUI() {
        nameLbl.text = UserData.User?.name ?? ""
        emailLbl.text = UserData.User?.email ?? ""
        userImgView.showImage(imgURL: userImageBaseUrl + (UserData.User?.userImage ?? ""), placeholderImage: "dummy_user", isFullURL: true)
        print(UserData.User?.userImage ?? "")
    }
    
    @IBAction func actionEditProfile(_ sender: Any) {
        if UserData.User == nil {
            self.openSignInScreen()
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension NMoreVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return moreModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moreModels[section].item.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        
        let label = UILabel()
        label.text = moreModels[section].name
        label.font = UIFont(name: "SFProText-Regular", size: 14.0)
        label.textColor = UIColor(white: 1.0, alpha: 0.7)
        
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10.0)
        ])
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableCell", for: indexPath) as! MoreTableCell
        cell.moreVC = self
        cell.nameLbl.text = moreModels[indexPath.section].item[indexPath.row].name
        cell.imgView.image = UIImage(named: moreModels[indexPath.section].item[indexPath.row].image)
        cell.imgHeightConst.constant = indexPath.section == 0 ? 18: 0
        cell.imgTrailingConst.constant = indexPath.section == 0 ? 12: 0
        cell.kidsSwitch.isHidden = moreModels[indexPath.section].item[indexPath.row].action != .kids
        cell.arrImgView.isHidden = moreModels[indexPath.section].item[indexPath.row].action == .kids
        
        cell.kidsSwitch.isOn = (UserData.User?.familyContent ?? 0) == 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = moreModels[indexPath.section].item[indexPath.row]
        
        if UserData.User == nil {
            self.openSignInScreen()
            return
        }
        
        if selected.action == .accountSetting {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountSettingsVC") as! AccountSettingsVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if selected.action == .language {
            Alert.show(message: "Coming Soon...")
        } else if selected.action == .help {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if selected.action == .terms {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.isTerms = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if selected.action == .privacy {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
            vc.isTerms = false
            self.navigationController?.pushViewController(vc, animated: true)
        } else if selected.action == .logout {
            if UserData.User != nil {
                Alert.show(message: "Are you sure you want to logout?", actionTitle1: "Yes", actionTitle2: "No", alertStyle: .alert, completionOK: {
                    UserData.User = nil
                    UserData.Token = nil
                    self.openSignInScreen()
                }, completionCancel: nil)
            } else {
                self.openSignInScreen()
            }
        } else if selected.action == .myPlans {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionsVC") as! SubscriptionsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class MoreTableCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgTrailingConst: NSLayoutConstraint!
    @IBOutlet weak var arrImgView: UIImageView!
    @IBOutlet weak var kidsSwitch: UISwitch!
    weak var moreVC: NMoreVC?
    
    @IBAction func actionKidsSwitch(_ sender: UISwitch) {
        let param = ["status": sender.isOn ? "1" : "0"]
        moreVC?.apiCalled(api: .kidsMode, param: param, method: .post)
    }
}


// MARK: - API IMPLEMENTATIONS
extension NMoreVC {
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
    func apiCalled(api: Api, param: [String:Any], method: HTTPMethod, isEncoding: Bool = true) {
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
        WebServices.post(url: api, jsonObject: param, method: method, isEncoding: isEncoding) { jsonData in
//            Hud.hide(view: self.view)
            self.stopAnimation()
            
            do {
                switch api {
                case .kidsMode:
                    let kidsModel = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                    if let code = kidsModel["code"] as? Int {
                        let message = kidsModel["message"] as? String ?? ""
                        if code == 200 {
                            self.view.makeToast(message)
                            self.apiCalled(api: .myDetails, param: [:], method: .get)
                        } else {
                            self.view.makeToast(message)
                        }
                    }
                case .myDetails:
                    let userModel = try JSONDecoder().decode(UpdateUserModel.self, from: jsonData)
                    
                    if userModel.code! == 200 {
                        UserData.User = userModel.body
                        self.showInfoOnUI()
                        self.tableView.reloadData()
                    }
                default:
                    break
                }
            } catch {
                print(error)
            }
        } failureHandler: { errorJson in
//            Hud.hide(view: self.view)
            self.stopAnimation()
        }
    }
}
