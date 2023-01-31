//
//  Indicator.swift
//  Woow_Phase2
//
//  Created by Vikas MacBook on 29/12/22.
//

import Foundation
import UIKit
import Lottie

public class Indicator {

    public static let sharedInstance = Indicator()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()
    var animationView: LottieAnimationView?

    private init()
    {
        animationView = LottieAnimationView()
//        animationView.frame = UIScreen.main.bounds
        animationView!.frame = indicator.bounds

        animationView?.backgroundColor = UIColor.black
        animationView?.isUserInteractionEnabled = true
        animationView?.alpha = 0.5
//        indicator.style = .UIActivityIndicatorView.Style.large
        indicator.center = animationView!.center
        indicator.startAnimating()
        indicator.color = .red
        animationView = .init(name: "coffee")
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        indicator.addSubview(animationView!)

    }

    func showIndicator(){
        DispatchQueue.main.async( execute: {

            UIApplication.shared.keyWindow?.addSubview(self.animationView!)
            UIApplication.shared.keyWindow?.addSubview(self.indicator)
            self.animationView!.play()

        })
    }
    func hideIndicator(){

        DispatchQueue.main.async( execute:
            {
            self.animationView!.removeFromSuperview()
                self.indicator.removeFromSuperview()
            self.animationView!.stop()

        })
    }
}
