//
//  PlayerControllerView.swift
//  RotatingPlayer
//
//  Created by calvin on 18/6/2016.
//  Copyright © 2016年 me.calvinchankf. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerControllerViewDelegate: AnyObject {
    func userWantFullScreen()
    func userWantSmallScreen()
}

class PlayerControllerView: UIView {
    
    @IBOutlet weak var playerView: PlayerView!
    var player: AVPlayer?
    @IBOutlet weak var sizeToggleButton: UIButton!
    weak var delegate: PlayerControllerViewDelegate?
    
    var isFullscreen = false
    
    func loadVideo(url: String) {
        if let url = URL(string: url) {
            self.player = AVPlayer(url: url)
            self.player?.actionAtItemEnd = .none
            playerView.player = player
        }
    }
    
    func playVideo() {
        player?.play()
    }
    
    func pauseVide() {
        player?.pause()
    }
    
    func playerItemDidPlayToEnd() {
        self.player?.seek(to: CMTime.zero)
    }
    
    func removePlayer() {
        player?.currentItem?.removeObserver(self, forKeyPath: "status")
        
        player?.pause()
        player = nil
    }
    
    @IBAction func sizeTogglePressed(sender: AnyObject) {
        if isFullscreen {
            delegate?.userWantSmallScreen()
        } else {
            delegate?.userWantFullScreen()
        }
        isFullscreen = !isFullscreen
    }
    
}
