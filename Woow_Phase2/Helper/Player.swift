//
//  Player.swift
//  WooW
//
//  Created by MAC on 20/05/21.
//

import Foundation
import UIKit
import AVKit

class Player {
    
    static let shared = Player()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var avAsset: AVAsset?
    var videoRect: CGRect = UIScreen.main.bounds
    fileprivate let seekDuration: Float64 = 10
    var closureDidFinishPlaying: ((Bool) -> ())?

    
    
    // MARK:- CONFIGURE & SETUP PLAYER LAYER
    func configurePlayer(fileURL: String, playerView: UIView) {
        guard let url = URL(string: fileURL) else { return }
        player = nil
        if playerView.layer.sublayers != nil {
            playerView.layer.sublayers!.forEach { (layer) in
                layer.removeFromSuperlayer()
            }
        }
        
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = .resizeAspectFill
        playerLayer!.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer!)
        avAsset = AVAsset(url: url)
        self.play()
    }
    
    func changePlayerView(playerView: UIView, avPlayer: AVPlayer) {
        self.player = avPlayer
        self.playerLayer = AVPlayerLayer(player: player)
        playerLayer!.frame = CGRect(x: -50, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        playerLayer?.videoGravity = .resizeAspectFill
        playerView.layer.addSublayer(playerLayer!)
        player?.play()
    }
    
    func resizePlayer(frame: CGRect) {
        playerLayer!.frame = frame
        playerLayer!.videoGravity = .resizeAspectFill
    }
    
    // MARK:- PLAY FILE
    func play() {
        if player != nil {
            player!.play()
            NotificationCenter.default.addObserver(self, selector: #selector(Player.shared.didFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    
    // MARK:- PAUSE FILE
    func pause() {
        if player != nil {
            player!.pause()
        }
    }
    
    @objc func didFinishPlaying() {
        print("Audio File FInished")
        self.player!.seek(to: CMTime.zero)
        self.closureDidFinishPlaying!(true)
    }
    
    func isPaused() -> Bool {
        return player!.timeControlStatus == .playing ? false : true
    }
    
    
    // MARK:- CONTROLS
    func forwardTime(to seconds: Float = 0) {
        let totalDuration = player!.currentItem!.duration
        let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
        
        var newTime: Float64 = 0
        if seconds != 0 {
            newTime = Float64(seconds)
        } else {
            newTime = playerCurrentTime + seekDuration
        }
        
        if newTime < CMTimeGetSeconds(totalDuration) {
            let time = CMTime(seconds: newTime, preferredTimescale: 1000)
            player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        } else {
            let time = CMTime(seconds: newTime, preferredTimescale: 1000)
            player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    func reverseTime(to seconds: Int = 0) {
        let totalDuration = player!.currentItem!.duration
        let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
        let newTime = playerCurrentTime - seekDuration
        
        if newTime < CMTimeGetSeconds(totalDuration) {
            let time = CMTime(seconds: newTime, preferredTimescale: 1000)
            player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        } else {
            let time = CMTime(seconds: newTime, preferredTimescale: 1000)
            player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    func restartVideo() {
        let time = CMTime(seconds: 0, preferredTimescale: 1000)
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    // MARK:- TRACK FILE TIMINGS
    func trackTimeObserver(closure: @escaping((String, Float) -> ())) {
        if player != nil {
            player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (time) in
                
                //                print("STATUS: \(self.player!.currentItem!.status.rawValue)")
                self.videoRect = self.playerLayer!.videoRect
                
                if self.player!.currentItem!.status == AVPlayerItem.Status.readyToPlay {
                    let time: Float64 = CMTimeGetSeconds(self.player!.currentTime())
                    let currentTime = Utility.convertIntervalsToTimeFormatString(timeIntervals: time.rounded())
                    closure(currentTime, Float(time))
                }
            }
        }
    }
    
    
    // MARK:- CALCULATE FILE DURATION
    func fileDuration() -> String {
        if let player = player, let item = player.currentItem {
            let durationTime = CMTimeGetSeconds(item.duration)
            let seconds = durationTime // durationTime.truncatingRemainder(dividingBy: 60)
//            let videoDuration = Utility.convertIntervalsToTimeFormatString(timeIntervals: seconds.rounded())
//            return videoDuration
        }
        return ""
    }
    
    func fileTimeIntervals() -> Int {
        if player != nil {
            if let player = player, let item = player.currentItem {
                let durationTime = CMTimeGetSeconds(item.duration)
                let seconds = durationTime // durationTime.truncatingRemainder(dividingBy: 60)
                if seconds.isNaN {
                    return 0
                }
                return Int(seconds)
            }
        }
        return 0
    }
}
