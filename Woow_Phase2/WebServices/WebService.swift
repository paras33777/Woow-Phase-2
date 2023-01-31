//
//  WebService.swift
//  WooW
//
//  Created by Rahul Chopra on 29/04/21.
//

import Foundation
import Alamofire
import AVKit
//typealias CompletionBlock = ([String : Any]) -> Void
typealias CompletionBlock = (Data) -> Void
typealias FailureBlock = ([String : Any]) -> Void
typealias ProgressBlock = (Double) -> Void


let downloadTaskIdentifier = "com.woow.channel"
var backgroundConfiguration: URLSessionConfiguration?
var assetDownloadURLSession: AVAssetDownloadURLSession!
var downloadTask: AVAssetDownloadTask!
var downloadVideoURL: URL?
// Your file will be saved at this path
fileprivate var destinationURL: URL?

// ((Swift.Int) -> Swift.Void)? = nil )
// http://fuckingswiftblocksyntax.com
/// https://www.raywenderlich.com/121540/alamofire-tutorial-getting-started
func isConnectedToInternet() ->Bool {
    return NetworkReachabilityManager()!.isReachable
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

class WebServices: NSObject {
    
    enum ContentType : String {
        case applicationJson = "application/json"
        case textPlain = "text/plain"
    }
    
    
    static var manager = AF.session
    
    
    
    class func postAuth( url : Api,
                         parameters  : [String : Any]  ,
                         method : HTTPMethod? = .post ,
                         contentType: ContentType? = .applicationJson,
                         authorization : (user: String, password: String)? = nil,
                         authorizationToken : String?  = nil,
                         completionHandler: CompletionBlock? = nil,
                         failureHandler: FailureBlock? = nil){
        var headers : HTTPHeaders = [
            "Content-Type": contentType!.rawValue,
            "cache-control": "no-cache",
            "username" : "ajay1@marketsflow.com",
            "password" : "UKengland10"
        ]
        
        if authorizationToken  != nil {
            headers["Authorization"] = "Bearer \(authorizationToken!)"
        }
        let urlString = url.baseURl()
        print("url->",urlString)
        var somString = ""
        
        let dictionary = parameters
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
            ), let theJSONText = String(data: theJSONData,
                                        encoding: String.Encoding.ascii) {
            
            somString = theJSONText
        }
        
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.fittingroom.newtimezone.Fitzz")
        configuration.timeoutIntervalForRequest = 60 * 60 * 00
        WebServices.manager = AF.session
        var encodeSting : ParameterEncoding = somString
        
        if method == .get {
            encodeSting = URLEncoding.default
        }
        
        AF.request(urlString, method: method!,parameters: parameters,encoding:encodeSting ,  headers:headers  )
//            .responseJSON {
//                response in
//                switch (response.result) {
//                case .success(let value):
//
//                    completionHandler!(value as! [String : Any] )
//                case .failure(let error):
//                    print(error)
//                    failureHandler?([:] )
//                }
//        }
        .responseData { response in
            switch response.result {
            case .success(let data):
                if let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    completionHandler!(data)
                }
            case .failure(let error) :
                print(error)
                failureHandler?([:] )
            }
        }
    }
    
    /*class func downloadFile(url :String , completionHandler: CompletionBlock? = nil) {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        AF.download(
            url,
            method: .get,
            parameters: [:],
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                
                //progress closure
            }).response(completionHandler: { (DefaultDownloadResponse) in
                
                print(DefaultDownloadResponse)
                completionHandler?([ : ])
                //here you able to access the DefaultDownloadResponse
                //result closure
            })
        
        
    }*/
    
    
    
    
    
    
    class func post( url : Api,jsonObject: [String : Any]  ,
                     method : HTTPMethod? = .post,
                     isEncoding: Bool,
                     completionHandler: CompletionBlock? = nil,
                     failureHandler: FailureBlock? = nil ) {
        let urlString = url.baseURl()
        print(urlString)
        
        var headers : HTTPHeaders = [
            "Content-Type": "application/json",
           "cache-control": "no-cache",
        ]
        
        if UserData.Token != "" {
            headers["Authorization"] = "Bearer \(UserData.Token ?? "")"
        }
        let parameters: Parameters = jsonObject
        print(headers)
        
        if isEncoding {
            AF.request(urlString, method: method!, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        
                        completionHandler!(data)
                    }
                case .failure(let error) :
                    print(error)
                    failureHandler?([:] )
                }
            }
        } else {
            print(parameters)
            AF.request(urlString, method: method!, parameters: parameters, headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                        
                        completionHandler!(data)
                    }
                case .failure(let error) :
                    print(error)
                    failureHandler?([:] )
                }
            }
        }
    }
    
    class func uploadSingle( url : Api,jsonObject: [String : Any] , profiePic:UIImage?, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        let urlString = url.baseURl()
        print(urlString)
        let params: Parameters = jsonObject
        
        var headers : HTTPHeaders = [
            "Content-Type": "application/json",
           "cache-control": "no-cache",
        ]
        
        if UserData.Token != "" {
            headers["Authorization"] = "Bearer \(UserData.Token ?? "")"
        }
        
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            if profiePic != nil {
                let imgData = profiePic!.jpegData(compressionQuality: 0.1)!
                multiPart.append(imgData, withName: "attachment", fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
        }, to: urlString, headers: headers)
        .responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                if let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    completionHandler!(data)
                }
            case .failure(let error) :
                print(error)
                failureHandler?([:] )
            }
        })
        
    }
    
    class func uploadParamData(url : Api,jsonObject: [String : Any] , data:Data?, completionHandler: CompletionBlock? = nil, failureHandler: FailureBlock? = nil) {
        
        let urlString = url.baseURl()
        print(urlString)
        let params: Parameters = jsonObject
        
        var headers : HTTPHeaders = [
            "Content-Type": "application/json",
           "cache-control": "no-cache",
        ]
        
        if UserData.Token != "" {
            headers["Authorization"] = "Bearer \(UserData.Token ?? "")"
        }
        
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            if data != nil {
                multiPart.append(data!, withName: "attachment", fileName: "\(Date().timeIntervalSince1970).txt", mimeType: "image/text")
            }
            
        }, to: urlString, headers: headers)
        .responseData(completionHandler: { response in
            switch response.result {
            case .success(let data):
                if let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                    completionHandler!(data)
                }
            case .failure(let error) :
                print(error)
                failureHandler?([:] )
            }
        })
        
    }
    
    
    
    // MARK:- DOWNLOAD CONFIGURATIONS
    func subscribeAppNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // MARK: DOWNLOAD TASK
     static func initializeDownloadSession()
    {
        // This will create a new configuration if the identifier does not exist
        // Otherwise, it will reuse the existing identifier which is how a download
        // task resumes
        backgroundConfiguration
            = URLSessionConfiguration.background(withIdentifier: downloadTaskIdentifier)
        
        // Resume will happen automatically when this configuration is made
        assetDownloadURLSession
            = AVAssetDownloadURLSession(configuration: backgroundConfiguration!,
                                        assetDownloadDelegate: WebServices(),
                                        delegateQueue: OperationQueue.main)
    }

    class  func resumeDownloadTask() {
        var sourceURL = downloadVideoURL
        
        // Now Check if we have any previous download tasks to resume
        if let destinationURL = destinationURL {
            sourceURL = destinationURL
        }
        
        if let sourceURL = sourceURL {
            let urlAsset = AVURLAsset(url: sourceURL)
            downloadTask = assetDownloadURLSession.makeAssetDownloadTask(asset: urlAsset,
                                                                         assetTitle: "Movie",
                                                                         assetArtworkData: nil,
                                                                         options: nil)
            downloadTask.resume()
        }
    }

    class func cancelDownloadTask() {
        downloadTask.cancel()
//        downloadButton.setTitle("Resume", for: .normal)
    }
    
    class func downloadVideoWith(url: URL) {
//        print("\(downloadButton.titleLabel!.text!) tapped")
        downloadVideoURL = url
        if downloadTask != nil, downloadTask.state == .running {
            WebServices.cancelDownloadTask()
        } else {
            WebServices.initializeDownloadSession()
            WebServices.resumeDownloadTask()
        }
    }
}



// MARK: OBSERVERS
extension WebServices {
    @objc func didEnterForeground() {
        if #available(iOS 13.0, *) { return }
        
        // In iOS 12 and below, there seems to be a bug with AVAssetDownloadDelegate.
        // It will not give you progress when coming from the background so we cancel
        // the task and resume it and you should see the progress in maybe 5-8 seconds
        if let downloadTask = downloadTask {
            downloadTask.cancel()
            WebServices.initializeDownloadSession()
            WebServices.resumeDownloadTask()
        }
    }

    //
    fileprivate func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
}

// MARK: AVAssetDownloadDelegate
extension WebServices: AVAssetDownloadDelegate
{
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?)
    {
        guard error != nil else
        {
            // Download completes here, do what you want
//            playMovie()
            return
        }
        
        // Handle errors
    }

    func urlSession(_ session: URLSession,
                    assetDownloadTask: AVAssetDownloadTask,
                    didFinishDownloadingTo location: URL)
    {
        // Save the download path of the task to resume downloads
        destinationURL = location
    }
    
    func urlSession(_ session: URLSession,
                    assetDownloadTask: AVAssetDownloadTask,
                    didLoad timeRange: CMTimeRange,
                    totalTimeRangesLoaded loadedTimeRanges: [NSValue],
                    timeRangeExpectedToLoad: CMTimeRange)
    {
//        downloadButton.setTitle("Pause", for: .normal)
        var percentageComplete = 0.0
        
        // Iterate over loaded time ranges
        for value in loadedTimeRanges {
            // Unpack CMTimeRange value
            let loadedTimeRange = value.timeRangeValue
            percentageComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        
//        progressView.setProgress(Float(percentageComplete), animated: true)
        
        let downloadCompletedString = String(format: "%.3f", percentageComplete * 100)
        
        print("\(downloadCompletedString)% downloaded")
//        progressLabel.text = "\(downloadCompletedString)%"
        
    }
}
