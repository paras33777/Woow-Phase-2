//
//  LandscapeVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 18/02/22.
//

import UIKit
import AVFoundation
import MobileVLCKit

class LandscapeVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var controlsView: UIStackView!
    @IBOutlet weak var minimizeBtb: UIButton!
    var movieDetail: MovieDetailModel.Body?
    let mediaPlayer = VLCMediaPlayer()
    var playerType: PlayerType = .movie
    var channelDetail: ChannelList?
    

    // MARK:- VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(playerTapAction))
        playerView.addGestureRecognizer(tap)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.controlsAction(isHidden: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
        
        if playerType == .channel {
            mediaPlayer.drawable = playerView
            mediaPlayer.delegate = self
            
            let media = VLCMedia(url: URL(string: channelDetail?.channelURL ?? "")!)
            mediaPlayer.media = media
            mediaPlayer.audio?.volume = 0  // Mute audio
            mediaPlayer.play()
        } else {
            self.setupPlayer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    
    // MARK:- CORE METHODS
    func setupPlayer() {
        Player.shared.pause()
        Player.shared.changePlayerView(playerView: playerView, avPlayer: Player.shared.player!)
        Player.shared.playerLayer?.videoGravity = .resizeAspect
//        self.totalTimeLbl.textColor = .white
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
//            self.currentTimeLbl.text = "00:00"
//            self.slider.value = 0
//            self.slider.minimumValue = 0
//            self.totalTimeLbl.text = Player.shared.fileDuration()
//            self.slider.maximumValue = NumberFormatter().number(from: Player.shared.fileDuration())?.floatValue ?? 0
            self.progressView.progress = 0
        }
        Player.shared.trackTimeObserver { (currentTime, timeInSec) in
//            self.currentTimeLbl.text = "\(currentTime)"
//            self.slider.value = timeInSec
//            self.totalTimeLbl.text = Player.shared.fileDuration()
//            self.slider.maximumValue = Float(Player.shared.fileTimeIntervals())
            self.progressView.progress = timeInSec
            print("Playting")
        }
        Player.shared.closureDidFinishPlaying = { isFinished in
//            self.currentTimeLbl.text = "00:00"
//            self.slider.value = 0
            self.progressView.progress = 0
        }
    }

    func controlsAction(isHidden: Bool) {
        self.controlsView.isHidden = isHidden
        self.progressView.isHidden = isHidden
        self.minimizeBtb.isHidden = isHidden
    }

    @objc func playerTapAction() {
        controlsAction(isHidden: !controlsView.isHidden)
        
        if !controlsView.isHidden {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if !self.controlsView.isHidden {
                    self.controlsAction(isHidden: !self.controlsView.isHidden)
                }
            }
        }
    }
    
    
    
    // MARK:- IBACTIONS
    @IBAction func actionPlayPause(_ sender: UIButton) {
        if Player.shared.isPaused() {
            Player.shared.play()
            sender.setImage(UIImage(named: "Icon - pause"), for: .normal)
        } else {
            Player.shared.pause()
            sender.setImage(UIImage(named: "Icon - play-circle"), for: .normal)
        }
    }
    
    @IBAction func actionBackward(_ sender: Any) {
    }
    
    @IBAction func actionForward(_ sender: Any) {
    }
    
    @IBAction func actionMinimize(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension LandscapeVC: VLCMediaPlayerDelegate {
    func mediaPlayerSnapshot(_ aNotification: Notification!) {
        print("mediaPlayerSnapshot : \(aNotification)")
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if let player = aNotification.object as? VLCMediaPlayer {
            let state = VLCMediaPlayerState(rawValue: player.state.rawValue)
            if state == VLCMediaPlayerState.playing {
                print("***** Playing")
            } else if state == VLCMediaPlayerState.stopped {
                print("***** Stopped")
            } else if state == VLCMediaPlayerState.ended {
                print("***** Ended")
            } else if state == VLCMediaPlayerState.buffering {
                print("***** Buffering")
            } else if state == VLCMediaPlayerState.opening {
                print("***** Opening")
            } else if state == VLCMediaPlayerState.paused {
                print("***** Paused")
            }
            print("***** isPlaying : \(mediaPlayer.isPlaying)")
        }
    }
}
