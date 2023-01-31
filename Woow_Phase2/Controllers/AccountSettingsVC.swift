//
//  AccountSettingsVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 09/12/21.
//

import UIKit

class AccountSettingsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var aboutModel = [AccountSettingModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutModel.append(AccountSettingModel(name: "Change Password", image: "Icon - box", action: .changePwd))
        aboutModel.append(AccountSettingModel(name: "Video Quality", image: "Icon - box-3", action: .videoQuality))
        aboutModel.append(AccountSettingModel(name: "Download Settings", image: "Icon - box-4", action: .downloadSetting))
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension AccountSettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableCell", for: indexPath) as! MoreTableCell
        cell.nameLbl.text = aboutModel[indexPath.row].name
        cell.imgView.image = UIImage(named: aboutModel[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = aboutModel[indexPath.row]
        
        if selected.action == .changePwd {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePwdVC") as! ChangePwdVC
            self.navigationController?.pushViewController(vc, animated: true)
        } else if selected.action == .downloadSetting {
            Alert.show(message: "Coming Soon...")
        } else if selected.action == .videoQuality {
            Alert.show(message: "Coming Soon...")
        }
    }
}
