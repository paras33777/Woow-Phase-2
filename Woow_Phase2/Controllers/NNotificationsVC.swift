//
//  NNotificationsVC.swift
//  WooW
//
//  Created by Rahul Chopra on 06/12/21.
//

import UIKit

class NNotificationsVC: UIViewController {

    // MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension NNotificationsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NNotificationCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
