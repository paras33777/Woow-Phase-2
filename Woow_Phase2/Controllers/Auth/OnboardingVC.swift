//
//  OnboardingVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 09/12/21.
//

import UIKit

class OnboardingVC: UIViewController {

    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK:- CORE METHODS
    func openSignInVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NLoginVC") as! NLoginVC
        let navVC = UINavigationController(rootViewController: vc)
        navVC.isNavigationBarHidden = true
        UIApplication.window().rootViewController = navVC
        UIApplication.window().makeKeyAndVisible()
    }
    

    
    // MARK:- ACTIONS
    @IBAction func actionWatchMovie(_ sender: Any) {
        self.openSignInVC()
    }
}
