//
//  ReceiptValidator.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 20/08/22.
//

import Foundation
import UIKit

class ReceiptValidator {
    
    static let sharedInstance = ReceiptValidator()
    
    func checkReceiptValidation(completion: @escaping((Any?) -> Void)) {
        DispatchQueue.main.async {
            Hud.show(message: "Processing...", view: UIApplication.topViewController()!.view)
//            let vc = LoadedViewController()
//            self.present(vc, animated: true, completion: nil)
        }
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

        if recieptString == nil {
            print("No Receipt found")
            DispatchQueue.main.async {
                Hud.hide(view: UIApplication.topViewController()!.view)
//                self.dismiss(animated:true,completion:nil)
                completion(true)
            }
            return
        }

        let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password": IAPKeys.kSecretKey as AnyObject]

        do {
            let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
            let storeURL = URL(string: verifyReceiptURL)!
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData

            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in

                do {
                    guard let data = data else {
                        DispatchQueue.main.async {
                            Hud.hide(view: UIApplication.topViewController()!.view)
//                            self.dismiss(animated:true,completion:nil)

                            completion(true)
                        }
                        return
                    }

                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
//                    print("=======>",jsonResponse)
                    
                    
                    DispatchQueue.main.async {
                        Hud.hide(view: UIApplication.topViewController()!.view)
//                        self.dismiss(animated:true,completion:nil)

                    }
                    if let dict = jsonResponse as? [String:Any] {
                        completion(dict)
                    } else {
                        completion(nil)
                    }
                    
                    
                    
//                    let leo = LeoSwiftCoder()
//                    leo.leoClassMake(withName: "ReceiptModel", json: jsonResponse as! NSDictionary)
                    
                    /*if let date = self?.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                        print(date)

                        print("TIME : \(date.timeIntervalSinceNow)")
                        UserDefault.saveSubscriptionExpiration(date: date)

                        DispatchQueue.main.async {
                            Hud.hide(view: UIApplication.topViewController()!.view)
                        }
                        
                        WebServices.serverTimeReturn { (serverDate) in
                            if let serverDate = serverDate {
                                if serverDate < date {
                                    print("NOT EXPIRED")
                                    completion(false)
                                } else {
                                    print("EXPIRED")
                                    DispatchQueue.main.async {
                                        completion(true)
                                        let expiredDate = date.changeExpirationTime()
//                                        Alert.showComplex(title: "Product expired", message: "Product is expired since \(expiredDate)", okTitle: "Ok")
                                        //Alert.showComplex(title: "Product expired", message: "Product is expired since \(expiredDate)", preferredStyle: .alert, cancelTilte: "Cancel", otherButtons: "Ok", comletionHandler: nil)
                                    }
                                }
                            }
                        }

//                        if date.timeIntervalSinceNow < 0 {
//                            print("EXPIRED")
//                            DispatchQueue.main.async {
//                                let expiredDate = date.changeExpirationTime()
//                                Alert.showComplex(title: "Product expired", message: "Product is expired since \(expiredDate)")
//                            }
//                        } else {
//                            print("NOT EXPIRED")
//                        }
                        completion(nil)

                    }  else {
                        DispatchQueue.main.async {
                            Hud.hide(view: UIApplication.topViewController()!.view)
                            completion(true)
                        }
                    } */
                } catch let parseError {
                    DispatchQueue.main.async {
                        Hud.hide(view: UIApplication.topViewController()!.view)
//                        self.dismiss(animated:true,completion:nil)

                        completion(nil)
                    }
                    print(parseError)
                }
            })
            task.resume()
        } catch let parseError {
            DispatchQueue.main.async {
                Hud.hide(view: UIApplication.topViewController()!.view)
//                self.dismiss(animated:true,completion:nil)

                completion(nil)
            }
            print(parseError)
        }
    }

    private func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let productId = lastReceipt["product_id"] as? String {
                print("Purchased Product Id: \(productId)")
                UserDefaults.standard.set(productId, forKey: "PurchasedProductId")
            }

            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            return nil
        }
        else {
            return nil
        }
    }
    
}


// MARK: - Date Convert Date To String
extension Date {
    func changeExpirationTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let defaultTimeZoneStr = formatter.string(from: self)
        let defaultTimeZoneDate = formatter.date(from: defaultTimeZoneStr)
        
        let convertedFormatter = DateFormatter()
        convertedFormatter.dateFormat = "dd:MM:yyyy hh:mm a"
        let convertedDateStr = convertedFormatter.string(from: defaultTimeZoneDate!)
        return convertedDateStr
    }
}
