//
//  PortraitPlayerVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 20/02/22.
//

import UIKit
import MobileVLCKit
import VMaxAdsSDK
import JioAdsFramework

struct Sides : OptionSet {
    let rawValue: Int

    static let left = Sides(rawValue:1)
    static let right = Sides(rawValue:2)

    static let both : Sides = [.left, .right]
    static let none : Sides = []
}

class PortraitPlayerVC: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - OUTLETS
    @IBOutlet weak var reverseImgView: UIImageView!
    @IBOutlet weak var forwardImgView: UIImageView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var playerContainerView: UIView!
    @IBOutlet weak var moveiNameLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var controlsView: UIStackView!
    @IBOutlet weak var vlcPlayerView: UIView!
    var movieDetail: MovieDetailModel.Body?
    var seriesDetail: SeriesDetailModel.SeasonListing.EpisodeListing?
    var channelDetail: ChannelList?
    var playerType: PlayerType = .movie
    let mediaPlayer = VLCMediaPlayer()
    var previousVC: UIViewController?
    override var shouldAutorotate: Bool { return false }
    
    var player = VGPlayer()
    var isPaused = false
    var isTrailor: Bool = false
//    var adView: JioAdView?
    var adspotId                        : String?
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.displayView.portraitPlayerVC = self
        playerContainerView.addSubview(self.player.displayView)
        player.displayView.isDisplayControl = false
        self.player.backgroundMode = .suspend
        
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.playerContainerView.snp.top)
            make.left.equalTo(strongSelf.playerContainerView.snp.left)
            make.right.equalTo(strongSelf.playerContainerView.snp.right)
            make.bottom.equalTo(strongSelf.playerContainerView.snp.bottom)
        }
        
        self.showInfoOnUI()
//        self.configCacheAds()
    }

    
    //MARK: - Helper Methods
//    func configCacheAds() {
//        self.title = "InstreamVideo"
//        self.setValueInUserDefaults(objValue: "Production", for: "currentEnvironment")
//
//        JioAdSdk.setPackageName(packageName: "com.woow")
//        self.adView = JioAdView.init(adSpotId: "lhx0g6oj", adType: .InstreamVideo, delegate: self, forPresentionClass: self, publisherContainer: self.playerContainerView)
//
//        self.adView?.setCustomInstreamAdContainer(container: self.playerContainerView)// container view
//        self.playerContainerView.isHidden = false
//
////        self.adView?.setRequestedAdDuration(adPodDuration: 5)
//        self.adView?.autoPlayMediaEnalble = true
//        self.adView?.setRefreshRate(refreshRate: 15)
//        self.adView?.cacheAd()
//    }
    
    func showInfoOnUI() {
        if playerType == .channel {
            vlcPlayerView.isHidden = false
            mediaPlayer.drawable = vlcPlayerView
            mediaPlayer.delegate = self

            let media = VLCMedia(url: URL(string: channelDetail?.channelURL ?? "")!)
            mediaPlayer.media = media
            mediaPlayer.audio?.volume = 1  // Mute audio
            mediaPlayer.play()
            playerContainerView.backgroundColor = .clear
            player.displayView.backgroundColor = .clear
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(rotationVLCVideoPlayer))
            vlcPlayerView.addGestureRecognizer(tap)
        } else {
            vlcPlayerView.isHidden = true
        }
        
        if let movieDetail = movieDetail {
            player.displayView.titleLabel.text = movieDetail.videoTitle
            
            if isTrailor {
                player.replaceVideo(URL(string: movieDetail.trailer ?? "")!)
            } else {
                player.replaceVideo(URL(string: movieDetail.videoURL ?? "")!)
            }
        } else if let seriesDetail = seriesDetail {
            player.displayView.titleLabel.text = seriesDetail.seoTitle
            player.replaceVideo(URL(string: seriesDetail.videoURL ?? "")!)
        } else {
            player.displayView.titleLabel.text = channelDetail?.channelName
            player.replaceVideo(URL(string: channelDetail?.channelURL ?? "")!)
        }
        
        self.player.play()
    }
    
    
    @objc func rotationVLCVideoPlayer(_ tap: UITapGestureRecognizer) {
        player.displayView.displayControlView(true)
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        Player.shared.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func actionPlayPause(_ sender: UIButton) {
//        isPaused = !isPaused
//        if isPaused {
//            sender.setImage(UIImage(named: "Icon - play-circle"), for: .normal)
//            player.pause()
//        } else {
//            sender.setImage(UIImage(named: "Icon - pause"), for: .normal)
//            player.play()
//        }
//    }
    
    @IBAction func actionBackward(_ sender: Any) {
        if playerType == .series {
            if let vc = previousVC as? SeriesDetailVC {
                if let a = vc.decreaseSeriesSelection() {
                    self.seriesDetail = a
                    self.showInfoOnUI()
                }
            }
        }
    }
    
    @IBAction func actionForward(_ sender: Any) {
        if playerType == .series {
            if let vc = previousVC as? SeriesDetailVC {
                if let a = vc.increaseSeriesSelection() {
                    self.seriesDetail = a
                    self.showInfoOnUI()
                }
            }
        }
    }
}


extension PortraitPlayerVC: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
}

extension PortraitPlayerVC: VGPlayerViewDelegate {
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {

    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.player.pause()
            self.mediaPlayer.pause()
            self.player.cleanPlayer()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
        
        /*UIView.animate(withDuration: 1.0) {
            self.controlsView.alpha = playerView.isDisplayControl ? 1.0 : 0.0
        }*/
    }
    
    func vgPlayerView(didDoubleTap: TapSide) {
        /*if didDoubleTap == .right {
            UIView.animate(withDuration: 0.4) {
                self.forwardImgView.alpha = 1.0
            } completion: { _ in
                UIView.animate(withDuration: 0.4) {
                    self.forwardImgView.alpha = 0.0
                }
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.reverseImgView.alpha = 1.0
            } completion: { _ in
                UIView.animate(withDuration: 0.4) {
                    self.reverseImgView.alpha = 0.0
                }
            }
        }*/
    }
}

extension PortraitPlayerVC: VLCMediaPlayerDelegate {
    
}


// MARK: - JIO ADS DELEGATE METHODS
//extension PortraitPlayerVC: JIOAdViewProtocol {
//    func onAdReceived(adView: JioAdView) {
//        print("onAdReceived")
//    }
//
//    func onAdPrepared(adView: JioAdView) {
//        print("onAdPrepared")
//        self.adView?.loadAd()
//    }
//
//    func onAdRender(adView: JioAdView) {
//        print("onAdRender")
//    }
//
//    func onAdClicked(adView: JioAdView) {
//        print("onAdClicked")
//    }
//
//    func onAdRefresh(adView: JioAdView) {
//        print("onAdRefresh")
//    }
//
//    func onAdFailedToLoad(adView: JioAdView, error: JioAdError) {
//        print("onAdFailedToLoad : \(error)")
//    }
//
//    func onAdMediaEnd(adView: JioAdView) {
//        print("onAdMediaEnd")
//    }
//
//    func onAdClosed(adView: JioAdView, isVideoCompleted: Bool, isEligibleForReward: Bool) {
//        print("onAdClosed")
//        self.player.displayView.play()
//
////        self.adView?.setRequestedAdDuration(adPodDuration: 10)
//
//
//    }
//
//    func onAdMediaStart(adView: JioAdView) {
//        print("")
//        self.player.displayView.pause()
//    }
//
//    func onAdSkippable(adView: JioAdView) {
//        print("onAdSkippable")
//    }
//
//    func onAdMediaExpand(adView: JioAdView) {
//        print("onAdMediaExpand")
//    }
//
//    func onAdMediaCollapse(adView: JioAdView) {
//        print("onAdMediaCollapse")
//    }
//
//    func onMediaPlaybackChange(adView: JioAdView, mediaPlayBack: MediaPlayBack) {
//        print("onMediaPlaybackChange")
//    }
//
//    func onAdChange(adView: JioAdView, trackNo: Int) {
//        print("onAdChange")
//    }
//
//    func mediationLoadAd() {
//        print("")
//    }
//
//    func mediationRequesting() {
//        print("")
//    }
//}
