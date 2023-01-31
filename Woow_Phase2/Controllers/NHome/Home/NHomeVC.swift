//
//  NHomeVC.swift
//  WooW
//
//  Created by Rahul Chopra on 05/12/21.
//

import UIKit
import Alamofire
import AVKit
import Lottie

enum SelectedSegmentAction {
    case Home
    case Movies
    case Series
    case TVShows
}

class NHomeVC: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var animationView: LottieAnimationView!
    var data = DummyHomeCatModel.data()
    var banners = [Banner]()
    var recentWatched = [RecentlyWatched]()
    var homeList = [HomeContent]()
    var vcs = [UIViewController]()
    var selectedTab: SelectedSegmentAction = .Home
    var isRefreshAPI: Bool = false {
        didSet {
            if isRefreshAPI {
                self.apiCalled(api: .home, param: [:], method: .get)
            }
        }
    }
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeDetailVC = storyboard?.instantiateViewController(withIdentifier: "HomeDetailVC") as! HomeDetailVC
        let tvShowsVC = storyboard?.instantiateViewController(withIdentifier: "TVShowsVC") as! TVShowsVC
        let homeMoviesVC = storyboard?.instantiateViewController(withIdentifier: "HomeMoviesVC") as! HomeMoviesVC
        let homeSeriesVC = storyboard?.instantiateViewController(withIdentifier: "HomeSeriesVC") as! HomeSeriesVC
        vcs = [homeDetailVC, homeMoviesVC, homeSeriesVC, tvShowsVC]
        
        vcs[0].add(self, containerView: containerView)
        self.apiCalled(api: .home, param: [:], method: .get)
        
        Location.shared.configure()
    }
    
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Player.shared.pause()
    }
    
    func playAnimation(){
        self.animationView.isHidden = false
        //        animationView = .init(name: "loading")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFill
        animationView!.loopMode = .loop
        animationView!.animationSpeed = 0.5
        view.addSubview(animationView!)
        animationView!.play()
    }
    // MARK: - IBACTIONS
    @IBAction func actionNotifications(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NNotificationsVC") as? NNotificationsVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK: - API IMPLEMENTATIONS
extension NHomeVC {
    func apiCalled(api: Api, param: [String:Any], method: HTTPMethod) {
//        Hud.show(message: "", view: self.view)
        playAnimation()
        WebServices.post(url: api, jsonObject: param, method: method, isEncoding: false) { jsonData in
//            Hud.hide(view: self.view)
            self.animationView.isHidden = true

            self.animationView.stop()

            do {
                let homeModel = try JSONDecoder().decode(HomeListModel.self, from: jsonData)
                if (homeModel.success ?? false) {
                    if self.banners.count > 0 {
                        for i in 0..<self.banners.count {
                            self.banners[i].player?.pause()
                            self.banners[i].player = nil
                        }
                    }
                    
//                    if Double(homeModel.body?.builds?.ios_build as? String ?? "") ?? 0.0 > Double(Bundle.main.releaseVersionNumber as? String ?? "") ?? 0.0 {
//                        Alert.showSimple("Please update new version") {
//                            if let url = URL(string: "itms-apps://itunes.apple.com/app/id1629135515") {
//                                UIApplication.shared.open(url)
//                            }
//                        }
//                        return
//                    }
                        
                    
                    
                    self.banners = homeModel.body?.banner ?? []
                    if self.banners.count > 0 {
                        self.banners[0].isPlayed = true
                        
                        for each in 0..<self.banners.count {
                            if (self.banners[each].videoURL ?? "") != "" {
                                
                                let videlURL = (self.banners[each].videoURL ?? "").replacingOccurrences(of: " ", with: "%20")
                                self.banners[each].player = AVPlayer(url: URL(string: videlURL)!)
                            }
                        }
                    }
                    self.homeList = homeModel.body?.homeContent ?? []
                    
                    
                    if (homeModel.body?.recentlyWatched ?? []).count > 0 {
                        var recentContent = HomeContent(id: 0, title: "Recent Watched", type: "recent_watch", values: "", isEditable: "false", app: "", tv: "", appSlot: 0, tvSlot: 0, status: "", createdAt: "", updatedAt: "", content: nil)
                        
                        var arr = [HomeContent.Content]()
                        for each in (homeModel.body?.recentlyWatched ?? []) {
                            arr.append(HomeContent.Content(id: each.id, appType: nil, webShow: nil, seriesLangID: 0, seriesGenres: "", seriesName: each.title, seriesSlug: "", seriesInfo: each.videoDescription, seriesPoster: each.image, imdbID: "", imdbRating: "", imdbVotes: "", seoTitle: "", seoDescription: "", seoKeyword: "", status: 0, familyContent: nil, videoAccess: nil, movieLangID: 0, movieGenreID: "", videoTitle: each.title, releaseDate: 0, duration: "", videoDescription: each.videoDescription, videoSlug: "", videoImageThumb: each.image, videoImage: each.image, videoType: nil, videoQuality: 0, videoURL: "", videoURL480: "", videoURL720: "", videoURL1080: "", downloadEnable: 0, downloadURL: "", subtitleOnOff: 0, subtitleLanguage1: "", subtitleUrl1: "", subtitleLanguage2: "", subtitleUrl2: "", subtitleLanguage3: "", subtitleUrl3: "", createdAt: "", adult: each.adult, updatedAt: "", type: each.videoType?.rawValue.lowercased() ?? "free", access_message: each.access_message ?? "", isFavorite: 0, isMovie: (each.type ?? "").lowercased() == "series" ? false : true, isShown: false))
                        }
                        recentContent.content = arr
                        self.homeList.insert(recentContent, at: 0)
                    }
                    self.recentWatched = homeModel.body?.recentlyWatched ?? []
                    
                    
                    self.catCollectionView.reloadData()
                    
                    if let homeDetailVC = self.vcs[0] as? HomeDetailVC {
                        homeDetailVC.refreshControl.endRefreshing()
                        homeDetailVC.parentVC = self
                        homeDetailVC.isBannerLoad = true
                        homeDetailVC.tableView.reloadData()
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                            homeDetailVC.tblViewHeightConst.constant = homeDetailVC.tableView.contentSize.height //+ 50
//                            homeDetailVC.view.layoutIfNeeded()
//                        })
//                        homeDetailVC.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
                    }
                } else {
                    if homeModel.code == 402{
                        Alert.showSimple("Someone use this account") {
                            UserData.User = nil
                            UserData.Token = nil
                            self.openSignInScreen()
                        }
                    }    else{
                        Alert.show(message: homeModel.message ?? "")

                    }
                }
            } catch {
                print(error)
            }
        } failureHandler: { errorJson in
//            Hud.hide(view: self.view)
            self.animationView.isHidden = true

            self.animationView.stop()

        }
    }
}
