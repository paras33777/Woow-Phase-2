//
//  WebViewVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 09/12/21.
//

import UIKit
import WebKit

class WebViewVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var headingLbl: UILabel!
    var isTerms: Bool = true
    
    
    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        headingLbl.text = isTerms ? "Terms of Service" : "Privacy Policy"
        
        
        var urlString = ""
        if isTerms {
            urlString = "https://woowchannel.com/page/terms-of-use"
        } else {
            urlString = "https://woowchannel.com/page/privacy-policy"
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
//        if let appDetail = appDetail {
//            let font = "<font face='SFProText-Regular' size='4.5' color= 'white'>%@"
//            let textData = String(format: font, appDetail.app_privacy ?? "").data(using: .utf8)
//            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
//                            NSAttributedString.DocumentType.html]
//            do {
//                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
//                textView.attributedText = attText
//            } catch {
//                print(error)
//            }
//        }
    }
    

    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
