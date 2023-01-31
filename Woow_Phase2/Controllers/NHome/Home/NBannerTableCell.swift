//
//  NBannerTableCell.swift
//  WooW
//
//  Created by Rahul Chopra on 05/12/21.
//

import Foundation
import UIKit
import FSPagerView
import AVKit

// MARK: - BANNER METHODS
class NBannerTableCell: UITableViewCell, FSPagerViewDataSource, FSPagerViewDelegate {
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            pagerView.register(PagerViewCell.self, forCellWithReuseIdentifier: "BannerPagerCell")
            pagerView.dataSource = self
            pagerView.delegate = self
        }
    }
    var banners = [Banner]() {
        didSet {
            pagerView.reloadData()
        }
    }
    @IBOutlet weak var playBtn: UIButton!
    weak var parentVC: HomeDetailVC?
    var isPlayed: Bool = false
    var pagerCells = [PagerViewCell]()
    
    
    // MARK: - IBACTIONS
    @IBAction func actionPlay(_ sender: UIButton) {
        isPlayed = !isPlayed
        if isPlayed {
            banners[pagerView.currentIndex].isPlayed = true
            if banners.filter({$0.isPlayed}).count > 0 {
                playBtn.setImage(UIImage(named: "pause_ic"), for: .normal)
                
                let cell = pagerCells[pagerView.currentIndex]
                cell.videoView.isHidden = false
                self.playVideo(index: pagerView.currentIndex, videoView: cell.videoView)
            }
        } else {
            playBtn.setImage(UIImage(named: "Btn play"), for: .normal)
            for i in 0..<banners.count {
                banners[i].isPlayed = false
                banners[i].player?.pause()
            }
        }
    }
    
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 0//banners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerPagerCell", at: index) as! PagerViewCell
        
        if pagerCells.contains(where: {$0 === cell}) {
        } else {
            pagerCells.append(cell)
        }
        
        cell.imgView.showImage(imgURL: banners[index].thumbnail ?? "", isFullURL: true)
        if banners[index].isPlayed {
//            cell.imgView.isHidden = true
            cell.videoView.isHidden = false
        } else {
//            cell.imgView.isHidden = false
            cell.videoView.isHidden = true
        }
        
        return cell
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
//        if let cell = pagerView.cellForItem(at: targetIndex) {
//            for i in 0..<self.banners.count {
//                self.banners[i].isPlayed = false
//                self.banners[i].player?.pause()
//            }
//            self.banners[targetIndex].isPlayed = true
////            self.banners[targetIndex].player?.play()
//            self.playVideo(index: targetIndex, videoView: cell.backgroundView!)
//
//            if banners[targetIndex].isPlayed {
//                cell.imageView?.isHidden = true
//                cell.backgroundView?.isHidden = false
//            } else {
//                cell.imageView?.isHidden = false
//                cell.backgroundView?.isHidden = true
//            }
//
//            print("pagerViewWillEndDragging : \(targetIndex)")
//            self.pagerView.scrollToItem(at: targetIndex, animated: true)
//        }
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
//        print("==== \(pagerView.currentIndex)")
//
//        for i in 0..<banners.count {
//            if banners[i].player != nil {
//                banners[i].player?.pause()
//                banners[i].player = nil
//            }
//        }
//
////        pagerView.automaticSlidingInterval = 0
//
//        let banner = banners[pagerView.currentIndex]
//        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: banner.player?.currentItem)
//
//        if banners[pagerView.currentIndex].player != nil {
//            banners[pagerView.currentIndex].player?.play()
//        }
//
//        banner.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
//        self.pageControl.currentPage = pagerView.currentIndex
    }
    
    func playVideo(index: Int, videoView: UIView) {
        let playerLayer = AVPlayerLayer(player: banners[index].player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = videoView.layer.frame
        videoView.layer.addSublayer(playerLayer)
        playerLayer.player?.play()
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        if let playerItem = notification.object as? AVPlayerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
        
//        pagerView.automaticSlidingInterval = 1.0
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus", let change = change, let newValue = change[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
            let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
            if newStatus != oldStatus {
                DispatchQueue.main.async {[weak self] in
                    guard let this = self else {
                        return
                    }
                    
                    if newStatus == .playing || newStatus == .paused {
                        if newStatus == .paused {
                            print("PAUSE")
                            
                            if let player = object as? AVPlayer {
                                player.removeObserver(this, forKeyPath: "timeControlStatus")
                            }
                            
                        }
                        else {
                            print("pLAY")
                        }
                        
                        
//                        this.activityIndicator.stopAnimating()
                    } else {
                        print("OTHERS")
                        
//                        this.activityIndicator.color = .white
//                        this.activityIndicator.startAnimating()
                    }
                }
            }
        }
    }
}


// MARK: - MOVIES CELL
class HomeMoviesTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    weak var homeDetailVC: HomeDetailVC?
    var recentWatchModel = [RecentlyWatched]()
    var homeList: HomeContent? {
        didSet {
            if collectionView != nil {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


extension HomeMoviesTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeList?.content?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMoviesCollectionCell", for: indexPath) as! HomeMoviesCollectionCell
        cell.configure(content: homeList!.content![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 140, height: collectionView.frame.size.height)
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            if !self.homeList!.content![indexPath.row].isMovie {
                if let vc = self.homeDetailVC?.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
                    vc.selectedSeries = self.homeList?.content?[indexPath.row]
                    self.homeDetailVC?.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if let vc = self.homeDetailVC?.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                    vc.selectedMovie = self.homeList?.content?[indexPath.row]
                    self.homeDetailVC?.pauseOtherTrailers()
                    self.homeDetailVC?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}


class HomeMoviesCollectionCell: UICollectionViewCell {
    @IBOutlet weak var premiumLbl: UILabel!
    @IBOutlet weak var movieImgView: UIImageView!
    func configure(content: HomeContent.Content) {
        movieImgView.showImage(imgURL: content.videoImageThumb ?? "")
        movieImgView.contentMode = .scaleToFill
        if content.access_message == nil || content.access_message == ""{
            premiumLbl.text = (content.type ?? "") != "" ? content.type! : "Free"

        }else{
            premiumLbl.text = (content.access_message ?? "") //(content.access_message ?? "") != "" ? content.access_message! : "Free"

        }
    }
}



// MARK: - PAGER VIEW CELL
class PagerViewCell: FSPagerViewCell {
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var videoView: UIView = {
        let videoView = UIView()
        videoView.backgroundColor = .black
        videoView.isHidden = true
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
    }()
    
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgView)
        addSubview(videoView)
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imgView.topAnchor.constraint(equalTo: self.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            videoView.topAnchor.constraint(equalTo: self.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(imgView)
        addSubview(videoView)
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imgView.topAnchor.constraint(equalTo: self.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            videoView.topAnchor.constraint(equalTo: self.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
