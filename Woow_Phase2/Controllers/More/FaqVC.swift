//
//  FaqVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 30/04/22.
//

import UIKit
import Alamofire
import Lottie

class FaqVC: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: LottieAnimationView!
    var faqs = [FAQModel.Body]()
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiCalled(api: .faq, param: [:], method: .get)
    }
    

    // MARK: - IBACTIONS
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension FaqVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableCell", for: indexPath) as! FAQTableCell
        cell.configure(faq: faqs[indexPath.row])
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(handleCollapseExpand(tap:)))
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(handleCollapseExpand(tap:)))
        cell.answerLbl.addGestureRecognizer(labelTap)
        cell.dropdownImgView.addGestureRecognizer(imageTap)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func handleCollapseExpand(tap: UITapGestureRecognizer) {
        guard let indexPath = tableView.indexPathForRow(at: tap.location(in: tableView)) else {return}
        let isExpanded = faqs[indexPath.row].isExpanded
        faqs[indexPath.row].isExpanded = !isExpanded
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}



class FAQTableCell: UITableViewCell {
    // MARK:- OUTLETS
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var dropdownImgView: UIImageView!
    
    // MARK:- CORE METHODS
    func configure(faq: FAQModel.Body) {
        questionLbl.text = "Question. \(faq.question ?? "")"
        self.dropdownImgView.transform = faq.isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        
        if faq.isExpanded {
            let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
            let textData = String(format: font, faq.answer ?? "").data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                self.answerLbl.attributedText = attText
            } catch {
                print(error)
            }
        } else {
            answerLbl.text = ""
        }
    }
}


// MARK: - API IMPLEMENTATIONS
extension FaqVC {
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
                let faqModel = try JSONDecoder().decode(FAQModel.self, from: jsonData)
                if (faqModel.success ?? false) {
                    self.faqs = faqModel.body ?? []
                    self.tableView.reloadData()
                } else {
                    Alert.show(message: faqModel.message ?? "")
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
