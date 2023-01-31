//
//  VLCPlayerVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 28/05/22.
//

import UIKit
import MobileVLCKit

class VLCPlayerVC: UIViewController {
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var vlcView: UIView!
    let mediaPlayer = VLCMediaPlayer()
    var channelDetail: ChannelList?
    var player = VGPlayer()
    override var shouldAutorotate: Bool { return false }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*player.displayView.vlcPlayerVC = self
        playerView.addSubview(self.player.displayView)
        player.displayView.isDisplayControl = false
        self.player.backgroundMode = .proceed
        self.player.delegate = self
        self.player.displayView.delegate = self
        player.replaceVideo(URL(string: channelDetail?.channelURL ?? "")!)
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.playerView.snp.top)
            make.left.equalTo(strongSelf.playerView.snp.left)
            make.right.equalTo(strongSelf.playerView.snp.right)
            make.bottom.equalTo(strongSelf.playerView.snp.bottom)
        }*/
        
                
        mediaPlayer.drawable = vlcView
        mediaPlayer.delegate = self

        let media = VLCMedia(url: URL(string: channelDetail?.channelURL ?? "")!)
        mediaPlayer.media = media
        mediaPlayer.audio?.volume = 1
        mediaPlayer.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //player.play()
    }
    
    
    @IBAction func actionMaximize(_ sender: Any) {
        let rotateButton = sender as! UIButton
        
        if rotateButton.tag == 0 {
            //Rotation is off
            rotateButton.tag = 1
            player.displayView.enterFullscreen()
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
        else {
            //Rotation is on
            rotateButton.tag = 0
            player.displayView.exitFullscreen()
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        UIViewController.attemptRotationToDeviceOrientation()
    }
}


extension VLCPlayerVC: VLCMediaPlayerDelegate {
    
}


extension VLCPlayerVC: VGPlayerDelegate {
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

extension VLCPlayerVC: VGPlayerViewDelegate {
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {

    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
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
