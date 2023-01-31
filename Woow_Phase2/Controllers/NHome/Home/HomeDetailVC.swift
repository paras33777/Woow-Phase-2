//
//  HomeDetailVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 16/02/22.
//

import UIKit
import AVKit
import FSPagerView

class HomeDetailVC: UIViewController, FSPagerViewDataSource, FSPagerViewDelegate {

    // MARK: - VIEW LIFE CYCLE METHODS
    @IBOutlet weak var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playerView: FSPagerView! {
        didSet {
            playerView.register(PagerViewCell.self, forCellWithReuseIdentifier: "BannerPagerCell")
            playerView.dataSource = self
            playerView.delegate = self
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tableView: UITableView!
    weak var parentVC: NHomeVC?
    var isBannerLoad: Bool = false {
        didSet {
            if isBannerLoad {
                
                
                pageControl.numberOfPages = parentVC?.banners.count ?? 0
                if (parentVC?.banners.count ?? 0) > 0 {
                    playerView.reloadData()
                }
            }
        }
    }
    let refreshControl = UIRefreshControl()
    
    
    // MARK: - OUTLETS
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: UIColor.white])
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (parentVC?.banners.count ?? 0) > 0 && (parentVC?.selectedTab ?? .Home) == .Home {
            parentVC?.banners[0].isPlayed = true
//            parentVC?.banners[0].player?.play()
            if let cell = playerView.cellForItem(at: 0) as? PagerViewCell {
                playBannerVideo(index: 0, cellView: cell.videoView)
            }
        }
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as! UITableView) == self.tableView {
          if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
              let newsize = newvalue as! CGSize
              print(newsize.height)
                tblViewHeightConst.constant = (newsize.height)

              //yourtableview.height = newsize.height
            }
          }
        }
      }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let homeCount = parentVC?.homeList.count ?? 0
        tblViewHeightConst.constant = CGFloat((140 * homeCount) + (35 * homeCount) + 120)
        
//        tblViewHeightConst.constant = CGFloat((140 * (parentVC?.homeList.count ?? 0)) + (35 * (parentVC?.homeList.count ?? 0))) + CGFloat(120) //tableView.contentSize.height + 100
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (parentVC?.banners.count ?? 0) > 0 {
            pauseOtherTrailers()
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.parentVC?.isRefreshAPI = true
    }
    
    
    func playBannerVideo(index: Int, cellView: UIView) {
        let playerLayer = AVPlayerLayer(player: parentVC?.banners[index].player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = playerView.layer.frame
        cellView.layer.addSublayer(playerLayer)
        playerLayer.player?.play()
    }
    
    func pauseOtherTrailers() {
        for i in 0..<parentVC!.banners.count {
            parentVC!.banners[i].isPlayed = false
            parentVC?.banners[i].player?.pause()
            
//            if let cell = playerView.cellForItem(at: i) as? PagerViewCell {
//                if cell.videoView.layer.sublayers != nil {
//                    for i in 0..<cell.videoView.layer.sublayers!.count {
//                        print("+====== \(cell.videoView.layer.sublayers)")
//                        if cell.videoView.layer.sublayers![i].isKind(of: AVPlayerLayer.self) {
//                            print("Remove")
//                            cell.videoView.layer.sublayers![i].removeFromSuperlayer()
//                        }
//                    }
//                    cell.videoView.layer.removeFromSuperlayer()
//                }
//            }
        }
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return parentVC?.banners.count ?? 0
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerPagerCell", at: index) as! PagerViewCell
        
//        if pagerCells.contains(where: {$0 === cell}) {
//        } else {
//            pagerCells.append(cell)
//        }
        
        cell.imgView.showImage(imgURL: parentVC?.banners[index].thumbnail ?? "", isMode: true, isFullURL: true)
        if (parentVC?.banners[index].videoURL ?? "") == "" {
            cell.videoView.isHidden = true
            pauseOtherTrailers()
        } else {
            if parentVC?.banners[index].isPlayed ?? false {
                cell.videoView.isHidden = false
                playBannerVideo(index: index, cellView: cell.videoView)
            } else {
                cell.videoView.isHidden = true
                pauseOtherTrailers()
            }
        }
        
        return cell
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
        
        pauseOtherTrailers()
        self.parentVC?.banners[pagerView.currentIndex].isPlayed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.playerView.reloadData()
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let bannerType = self.parentVC?.banners[index]
        switch (bannerType?.bannerType ?? "").lowercased() {
        case "shows", "show", "series":
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
                vc.seriesId = bannerType?.bannerPostID ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case "movies", "movie":
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                vc.selectedMovieId = bannerType?.bannerPostID ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default: break
        }
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: parentVC?.banners[pagerView.currentIndex].player?.currentItem)
    }
    
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        if let playerItem = notification.object as? AVPlayerItem {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
        
//        pagerView.automaticSlidingInterval = 1.0
    }
}


// MARK: - TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension HomeDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return (parentVC?.homeList.count ?? 0) //+ 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        
        let label = UILabel()
//        label.text = section == 0 ? "" : parentVC?.homeList[section - 1].title ?? ""
        label.text = parentVC?.homeList[section].title ?? ""
//        label.font = AppFonts.SFProTextBold.withSize(15.0)
        label.textColor = .white
        containerView.addSubview(label)
        
        let viewMoreBtn = UIButton()
        viewMoreBtn.setTitle("View More", for: .normal)
//        viewMoreBtn.titleLabel?.font = AppFonts.SFProTextRegular.withSize(13.0)
        viewMoreBtn.setTitleColor(UIColor(white: 1.0, alpha: 0.4), for: .normal)
        containerView.addSubview(viewMoreBtn)
        viewMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        viewMoreBtn.tag = section
        viewMoreBtn.addTarget(self, action: #selector(viewMoreAction(btn:)), for: .touchUpInside)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15.0),
            
            viewMoreBtn.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            viewMoreBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0)
        ])
        
        return containerView
    }
    
    @objc func viewMoreAction(btn: UIButton) {
        if (parentVC?.homeList[btn.tag].type ?? "") == "movies" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
                vc.selectedMovie = parentVC?.homeList[btn.tag]
                vc.isAllMovies = false
                vc.action = .movieListing
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if (parentVC?.homeList[btn.tag].type ?? "") == "series" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
                let a = parentVC!.homeList[btn.tag]
                
                var seriesContents = [SeriesListModel.Content]()
                for each in (a.content ?? []) {
                    seriesContents.append(SeriesListModel.Content(id: each.id, creatorID: 0, appType: each.appType, webShow: each.webShow, seriesLangID: each.seriesLangID, seriesGenres: each.seriesGenres, seriesName: each.seriesName, seriesSlug: each.seriesSlug, seriesInfo: each.seriesInfo, seriesPoster: each.seriesPoster, imdbID: each.imdbID, imdbRating: each.imdbRating, imdbVotes: each.imdbVotes, seoTitle: each.seoTitle, seoDescription: each.seoDescription, seoKeyword: each.seoKeyword, status: each.status, familyContent: each.familyContent, trailer: "", adult: each.adult))
                }
                let content = a.content ?? []
                vc.selectedSeries = SeriesListModel.Body(id: 0, title: "", type: "", values: "", isEditable: "", app: "", tv: "", appSlot: 0, tvSlot: 0, createdAt: "", updatedAt: "", content: seriesContents)
                vc.isAllMovies = false
                vc.action = .seriesListing
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if (parentVC?.homeList[btn.tag].type ?? "") == "recent_watch" {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
                vc.selectedMovie = parentVC?.homeList[btn.tag]
                vc.isAllMovies = false
                vc.action = .recentWatched
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (parentVC?.homeList[indexPath.section].type ?? "").lowercased().contains("recent_watch") {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMoviesTableCell", for: indexPath) as! HomeMoviesTableCell
            cell.homeDetailVC = self
            cell.homeList = parentVC!.homeList[indexPath.section]
            cell.recentWatchModel = parentVC?.recentWatched ?? []
            return cell
        } else if (parentVC?.homeList[indexPath.section].type ?? "").lowercased().contains("movies") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMoviesTableCell", for: indexPath) as! HomeMoviesTableCell
            cell.homeDetailVC = self
            cell.homeList = parentVC!.homeList[indexPath.section]
            return cell
        } else if (parentVC?.homeList[indexPath.section].type ?? "").lowercased().contains("series") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTrendingTableCell", for: indexPath) as! HomeTrendingTableCell
            cell.homeDetailVC = self
            cell.homeList = parentVC!.homeList[indexPath.section]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NBannerTableCell", for: indexPath) as! NBannerTableCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140 //175
    }
}
