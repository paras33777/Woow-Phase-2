//
//  SubscriptionsVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 22/02/22.
//

import UIKit
import SafariServices
import Alamofire
import IBAnimatable
import StoreKit

class SubscriptionsVC: UIViewController {
    
    // MARK: - OUTLET
    @IBOutlet weak var planNameLbl: UILabel!
    @IBOutlet weak var priceDurationLbl: UILabel!
    @IBOutlet weak var termsLbl: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tickBtn: UIButton!
    @IBOutlet var subsContentViews: [AnimatableView]!
    var subscriptions = [SubscriptionPlanModel.Subscription]()
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.checkTransaction()
        
        subsContentViews.forEach({$0.isHidden = true})
    }
    
    func setupUI() {
        let attributedString = NSMutableAttributedString(string: "Full details can be found on our terms & condition and privacy policy page.")
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: NSRange(location: 0, length: 33))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], range: NSRange(location: 33, length: 17))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: NSRange(location: 51, length: 4))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], range: NSRange(location: 55, length: 14))
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], range: NSRange(location: 70, length: 5))
//        attributedString.addAttributes([NSAttr            ibutedString.Key.font: UIFont(name: "System-Semibold", size: 14.0)!], range: NSRange(location: 0, length: 75))
        
        attributedString.addAttribute(.link, value: termConditionURL, range: NSRange(location: 34, length: 17))
        attributedString.addAttribute(.link, value: privacyURL, range: NSRange(location: 56, length: 14))
        termsLbl.attributedText = attributedString
        
        tickBtn.imageView?.contentMode = .scaleAspectFit
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == privacyURL {
            let vc = SFSafariViewController(url: URL)
            present(vc, animated: true, completion: nil)
        } else if URL.absoluteString == termConditionURL {
            let vc = SFSafariViewController(url: URL)
            present(vc, animated: true, completion: nil)
        }
        return true
    }
    
    func showInfoOnUI(subscription: SubscriptionPlanModel.Subscription) {
        planNameLbl.text = subscription.planName
        priceDurationLbl.text = "\(subscription.product?.price ?? 0) \(subscription.product?.priceLocale.currencyCode ?? "") \(subscription.planEnum.rawValue)"
    }

    
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actionSkip(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionTick(_ sender: Any) {
        let selected = subscriptions.filter({$0.isSelected})
        if selected.count > 0 {
            Hud.show(message: "Purchasing...", view: self.view)
//            let vc = LoadedViewController()
//            self.present(vc, animated: true, completion: nil)
            RCInAppPurchase.shared.actionBuyProduct(selected.first!.product!)
        }
    }
}


// MARK:- COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
extension SubscriptionsVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCollCell", for: indexPath) as! SubscriptionCollCell
//        cell.nameLbl.text = indexPath.row == 0 ? "BRONZE" : (indexPath.row == 1 ? "SILVER" : "GOLD")
        cell.nameLbl.text = subscriptions[indexPath.row].planName
        cell.unselectedCell()
        subscriptions[indexPath.row].isSelected ? cell.selectedCell() : cell.unselectedCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<subscriptions.count {
            if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? SubscriptionCollCell {
                cell.unselectedCell()
            }
            subscriptions[i].isSelected = false
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SubscriptionCollCell {
            cell.selectedCell()
        }
        subscriptions[indexPath.row].isSelected = true
        self.showInfoOnUI(subscription: subscriptions[indexPath.row])
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? SubscriptionCollCell {
//            cell.unselectedCell()
//        }
//        subscriptions[indexPath.row].isSelected = false
//    }
}


// MARK: - SUBSCRIPTION CELL
class SubscriptionCollCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var lineLbl: UILabel!
 
    func selectedCell() {
        nameLbl.textColor = UIColor(named: "Color2")!
        lineLbl.isHidden = false
    }
    
    func unselectedCell() {
        nameLbl.textColor = UIColor(hexString: "#D5D5D5")
        lineLbl.isHidden = true
    }
}


// MARK:- IAP HANDLING
extension SubscriptionsVC {
    func checkTransaction() {
        Hud.show(message: "Processing...", view: self.view)
//        let vc = LoadedViewController()
//        self.present(vc, animated: true, completion: nil)
        RCInAppPurchase.shared
//            .withAppendProductId(IAPKeys.kMonthly)
//            .withAppendProductId(IAPKeys.kHalfYearly)
            .withAppendProductId(IAPKeys.kYearly)
            .actionRequestProductInfo()
            .withClosureInvalidProductIdentifiers { (error) in
                print("Invalid Product Identifier : \(error)")
                DispatchQueue.main.async {
                    Hud.hide(view: self.view)
//                    self.dismiss(animated:true,completion:nil)

                }
            }
        .withDidReceiveProducts {
            print("*****PRODUCTS RECEIVED*******")
            DispatchQueue.main.async {
                Hud.hide(view: self.view)
//                self.dismiss(animated:true,completion:nil)

                self.apiCalled(api: .subscriptionList, param: [:], method: .get)
            }
        }
        
        .withDidUpdatedTransactions({ (transacation) in
            
            switch transacation.transactionState {
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                print(transacation.transactionIdentifier)
                DispatchQueue.main.async {
                    Hud.hide(view: self.view)
//                    self.dismiss(animated:true,completion:nil)

                    ReceiptValidator.sharedInstance.checkReceiptValidation { receiptDict in
                        DispatchQueue.main.async {
                            if let rec = receiptDict {
                                Hud.hide(view: self.view)
//                                self.dismiss(animated:true,completion:nil)

                                self.uploadMultiData(trans_id: transacation.transactionIdentifier ?? "", receipt: rec)
                            }
                        }
                    }
                }
                
            case .failed:
                print("failed")
                DispatchQueue.main.async {
                    Hud.hide(view: self.view)
//                    self.dismiss(animated:true,completion:nil)

                    Alert.showSimple("Transaction Failed!")
                }
                NotificationCenter.default.post(name: NSNotification.Name("IAPObserver"), object: 1)
                
            case .restored:
                print("restored")
                DispatchQueue.main.async {
                    Hud.hide(view: self.view)
//                    self.dismiss(animated:true,completion:nil)

                }
                NotificationCenter.default.post(name: NSNotification.Name("IAPObserver"), object: 1)
                
            case .deferred:
                print("deferred")
                NotificationCenter.default.post(name: NSNotification.Name("IAPObserver"), object: 1)
                DispatchQueue.main.async {
                    Hud.hide(view: self.view)
//                    self.dismiss(animated:true,completion:nil)

                }
            @unknown default:
                print("")
                DispatchQueue.main.async {
                    Hud.hide(view: self.view)
//                    self.dismiss(animated:true,completion:nil)

                }
            }
            
        }).fullStop()
    }
    
    func updatePackagaes() {
        let firstIndex = subscriptions.firstIndex(where: {($0.planDays ?? 0) == 180})
//        if firstIndex != nil {
//            subscriptions[firstIndex!].product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kHalfYearly})[0]
//            subscriptions[firstIndex!].planEnum = .halfYearly
//        }
//
//        let secondIndex = subscriptions.firstIndex(where: {($0.planDays ?? 0) == 30})
//        if secondIndex != nil {
//            subscriptions[secondIndex!].product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kMonthly})[0]
//            subscriptions[secondIndex!].planEnum = .monthly
//        }

        let thirdIndex = subscriptions.firstIndex(where: {($0.planDays ?? 0) == 365})
        if thirdIndex != nil {
            subscriptions[thirdIndex!].product = RCInAppPurchase.shared.products.filter({$0.productIdentifier == IAPKeys.kYearly})[0]
            subscriptions[thirdIndex!].planEnum = .annually
            
            self.subscriptions[thirdIndex!].isSelected = true
        }
        
        if subscriptions.count > 0 {
            self.showInfoOnUI(subscription: subscriptions[0])
            subsContentViews.forEach({$0.isHidden = false})
            self.subscriptions[0].isSelected = true
        }
        collectionView.reloadData()
    }
    
    func callPurchaseTransactionAPI(trans_id: String, trans_date: Date, receipt: String) {
        let selectedSubscription = subscriptions.filter({$0.isSelected == true}).first!
        
        var params = [String:Any]()
        params["receipt"] = receipt
        params["planid"] = "\(selectedSubscription.id ?? 0)"
        params["type"] = "iOS"
        params["transactionID"] = trans_id
        let header: HTTPHeaders = ["Authorization": "Bearer \(UserData.Token ?? "")"]
        
        print(params)
        DispatchQueue.main.async {
            Hud.show(message: "", view: self.view)
//            let vc = LoadedViewController()
//            self.present(vc, animated: true, completion: nil)
        }
        AF.request("http://woowchannel.com:4191/app/mobile/v1/subscription/saveSubscription", method: .post, parameters: params, encoding: URLEncoding.default, headers: header)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .success:
                    print(String.init(data: response.data ?? Data(), encoding: .utf8))
                    DispatchQueue.main.async {
                        Hud.hide(view: self.view)
//                        self.dismiss(animated:true,completion:nil)

                        
                    }
                    do {
                        let subscriptionModel = try JSONDecoder().decode(UserModel.self, from: response.data ?? Data())
                        if (subscriptionModel.success ?? false) {
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            Alert.show(message: subscriptionModel.message ?? "")
                        }
                    } catch {
                        print(error)
                        DispatchQueue.main.async {
                            Hud.hide(view: self.view)
//                            self.dismiss(animated:true,completion:nil)

                            
                        }
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        Hud.hide(view: self.view)
//                        self.dismiss(animated:true,completion:nil)

                        
                    }
                }
            })
    }
    
    func uploadMultiData(trans_id: String, receipt: Any) {
        let sign = API.shared.sign()
        var params1 = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        
        var data: Data?
        if let rec = receipt as? [String:Any] {
            do {
                data = try JSONSerialization.data(withJSONObject: rec, options: .prettyPrinted)
            } catch let myJSONError {
                print(myJSONError)
            }
        }
        
        Hud.show(message: "", view: self.view)
//        let vc = LoadedViewController()
//        self.present(vc, animated: true, completion: nil)
        WebServices.uploadParamData(url: .uploadingImage, jsonObject: params1, data: data) { jsonData in
            Hud.hide(view: self.view)
//            self.dismiss(animated:true,completion:nil)

            do {
                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] ?? [:]
                print(json)
                
                if let code = json["code"] as? Int {
                    if code == 200 {
                        if let body = json["body"] as? String {
                            self.callPurchaseTransactionAPI(trans_id: trans_id, trans_date: Date(), receipt: body)
                        }
                    }
                }
            } catch {
                print(error)
            }
        } failureHandler: { (errorDict) in
            Hud.hide(view: self.view)
//            self.dismiss(animated:true,completion:nil)

            print(errorDict)
        }
    }
    
    func apiCalled(api: Api, param: [String:Any], method: HTTPMethod, isEncoding: Bool = false) {
        let sign = API.shared.sign()
        var params = ["sign": sign,
                     "salt": API.shared.salt
                    ] as [String : Any]
        for (key, value) in param {
            params[key] = value
        }
        
        Hud.show(message: "", view: self.view)
//        let vc = LoadedViewController()
//        self.present(vc, animated: true, completion: nil)
        WebServices.post(url: api, jsonObject: params, method: method, isEncoding: false) { jsonData in
            DispatchQueue.main.async {
                Hud.hide(view: self.view)
//                self.dismiss(animated:true,completion:nil)

            }
            
            do {
                switch api {
                case .subscriptionList:
                    let subscriptionModel = try JSONDecoder().decode(SubscriptionPlanModel.self, from: jsonData)
                    if (subscriptionModel.success ?? false) {
                        self.subscriptions = subscriptionModel.body ?? []
                        if let index = self.subscriptions.firstIndex(where: {$0.planDays! == 180}) {
                            self.subscriptions.remove(at: index)
                        }
                        if let index = self.subscriptions.firstIndex(where: {$0.planDays! == 90}) {
                            self.subscriptions.remove(at: index)
                        }
                        self.updatePackagaes()
                        self.collectionView.reloadData()
                    } else {
                        Alert.show(message: subscriptionModel.message ?? "")
                    }
                case .saveSubscription:
                    let subscriptionModel = try JSONDecoder().decode(UserModel.self, from: jsonData)
                    if (subscriptionModel.success ?? false) {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        Alert.show(message: subscriptionModel.message ?? "")
                    }
                default: break
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    Hud.hide(view: self.view)
//                    self.dismiss(animated:true,completion:nil)

                }
            }
        } failureHandler: { errorDict in
            DispatchQueue.main.async {
                Hud.hide(view: self.view)
//                self.dismiss(animated:true,completion:nil)

            }
        }
    }
}
