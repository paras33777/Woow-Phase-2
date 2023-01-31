//
//  TVShowDetailVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 16/03/22.
//

import UIKit
import Alamofire
import IBAnimatable
import MobileVLCKit

class TVShowDetailVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var trailorImgView: AnimatableImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    var channelDetail: ChannelList?
    var categoryName: String = ""

    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showInfoOnUI()
    }
    
    
    // MARK: - CORE METHODS
    func showInfoOnUI() {
        self.thumbnailImgView.showImage(imgURL: channelDetail?.channelThumb ?? "", isMode: true)
        self.movieNameLbl.text = channelDetail?.channelName
        self.ratingLbl.text = "0.0"
        self.categoryLbl.text = categoryName
        
        let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
        let textData = String(format: font, channelDetail?.channelDescription ?? "").data(using: .utf8)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html]
        do {
            let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
            self.descLbl.attributedText = attText
        } catch {
            print(error)
        }
    }


    // MARK: - IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        if UserData.User == nil {
            self.openSignInScreen()
            return
        }
        
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "VLCPlayerVC") as? VLCPlayerVC {
//            vc.channelDetail = self.channelDetail
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortraitPlayerVC") as? PortraitPlayerVC {
            vc.channelDetail = self.channelDetail
            vc.playerType = .channel
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //            mediaPlayer.drawable = playerContainerView
        //            mediaPlayer.delegate = self
        //
        //            let media = VLCMedia(url: URL(string: channelDetail?.channelURL ?? "")!)
        //            mediaPlayer.media = media
        //            mediaPlayer.audio.volume = 1  // Mute audio
        //            mediaPlayer.play()
    }
}
