//
//  Utility.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 21/02/22.
//

import Foundation
import UIKit


class Utility {
    
    // MARK:- CONVERT TIME INTERVALS INTO FORMATTED STRING
    class func convertIntervalsToTimeFormatString(timeIntervals: Float64) -> String {
        if timeIntervals.isNaN {
            return "00:00"
        }
        let seconds = Int(timeIntervals.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeIntervals.truncatingRemainder(dividingBy: 3600) / 60)
        let hour = Int(timeIntervals / 3600)
        
        if timeIntervals < 60 {
            if seconds < 10 {
                return "00:0\(seconds)"
            } else {
                return "00:\(seconds)"
            }
        } else if timeIntervals < (60 * 60) {
            var min = "\(minutes)"
            var sec = "\(seconds)"
            if minutes < 10 {
                min = "0\(minutes)"
            }
            if seconds < 10 {
                sec = "0\(seconds)"
            }
            return "\(min):\(sec)"
        } else {
            return "\(hour):\(minutes):\(seconds)"
        }
    }
    
}


//struct AppUtility {
//    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
//        if let delegate = UIApplication.shared.delegate as? AppDelegate {
////            delegate.deviceOrientation = orientation
//        }
//    }
//
//    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
//   
//        self.lockOrientation(orientation)
//    
//        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
//        UINavigationController.attemptRotationToDeviceOrientation()
//    }
//}
