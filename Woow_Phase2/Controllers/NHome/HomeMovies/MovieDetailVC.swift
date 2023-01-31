//
//  MovieDetailModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 18/02/22.
//

import UIKit
import Alamofire
import IBAnimatable
import MobileVLCKit
import JioAdsFramework
import Lottie
class MovieDetailVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var navBarHeightConst: NSLayoutConstraint!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var mainContentTopConst: NSLayoutConstraint!
    @IBOutlet weak var playerViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var navBarTopConst: NSLayoutConstraint!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var watchTrailerLblTopConst: NSLayoutConstraint!
    @IBOutlet weak var trailorImgBottomConst: NSLayoutConstraint!
    @IBOutlet weak var recommendedMovieCollCell: UICollectionView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var trailorImgView: AnimatableImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var trailerImgView: AnimatableImageView!
    @IBOutlet weak var trailerPlayBtn: UIButton!
    @IBOutlet weak var watchTrailerLbl: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!
    @IBOutlet weak var likeDislikeView:UIView!
    var selectedMovie: HomeContent.Content?
    var movieDetail: MovieDetailModel.Body?
    var watchModel: WatchMovieModel.Body?
    var selectedMovieId = 0
    var recommendedMovies = [RecommendedMoviesModel.Body]()
    var player = VGPlayer()
    var isPaused = false
    var isTrailor: Bool = false
//    var adView: JioAdView?
    var adspotId: String?
    let mediaPlayer = VLCMediaPlayer()
    override var shouldAutorotate: Bool { return false }
    var playCount = 0
    var isAlertShown = false
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showInfoOnUI()
        if UserData.User == nil {
            self.likeDislikeView.isHidden = true
        }else{
            self.likeDislikeView.isHidden = false

        }
        if selectedMovie != nil {
            selectedMovieId = selectedMovie?.id ?? 0
        } else if movieDetail != nil {
            selectedMovieId = movieDetail?.id ?? 0
        } else {
        }
        self.apiCalled(api: .movieDetail(selectedMovieId), param: [:], method: .get)
        self.apiCalled(api: .watchMovie(selectedMovieId), param: [:], method: .get)
        self.apiCalled(api: .recommandedMovies(selectedMovieId), param: [:], method: .get)
        configurePlayer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            self.configCacheAds()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            
            self.mainContentTopConst.constant = UIScreen.main.bounds.height - thumbnailImgView.frame.size.height
            self.navBarView.isHidden = true
            self.navBarHeightConst.constant = 0
        } else {
            print("Portrait")
            self.mainContentTopConst.constant = -100
            self.navBarView.isHidden = false
            self.navBarHeightConst.constant = 60
        }
//        self.configCacheAds()
    }
    
    
    // MARK: - CORE METHODS
//    func configCacheAds() {
//        self.title = "InstreamVideo"
//        self.setValueInUserDefaults(objValue: "Production", for: "currentEnvironment")
//
//        JioAdSdk.setPackageName(packageName: "com.woow")
//        self.adView = JioAdView.init(adSpotId: "lhx0g6oj", adType: .InstreamVideo, delegate: self, forPresentionClass: self, publisherContainer: self.playerView)
////        self.adView = JioAdView.init(adSpotId: "y5a83vx7", adType: .InstreamVideo, delegate: self, forPresentionClass: self, publisherContainer: self.playerView)
//
//        self.adView?.setCustomInstreamAdContainer(container: self.playerView)// container view
//        self.playerView.isHidden = false
//
////        self.adView?.setRequestedAdDuration(adPodDuration: 5)
//        self.adView?.autoPlayMediaEnalble = true
//        self.adView?.setRefreshRate(refreshRate: 15)
//        self.adView?.cacheAd()
//    }
    
    func configurePlayer() {
//        player.displayView.portraitPlayerVC = self
        playerView.addSubview(self.player.displayView)
        player.displayView.isDisplayControl = false
        self.player.backgroundMode = .suspend
        
        self.player.delegate = self
        self.player.displayView.delegate = self
        self.player.displayView.snp.makeConstraints { [weak self] (make) in
            guard let strongSelf = self else { return }
            make.top.equalTo(strongSelf.playerView.snp.top)
            make.left.equalTo(strongSelf.playerView.snp.left)
            make.right.equalTo(strongSelf.playerView.snp.right)
            make.bottom.equalTo(strongSelf.playerView.snp.bottom)
        }
        self.player.displayView.isCloseBtnHidden = true
    }
    @IBAction func likeButtonAction(_ sender: UIButton){
//        var param = [String:Any]()
//        param["movie_id"] = selectedMovieId
//        param["status"] = 1
//        self.apiCalled(api: .likeDisLikeMovie, param: param, method: .post)
        
//        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\n    \"movie_id\": \(selectedMovieId),\n    \"status\": 1\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(baseUrl)movies/movie-like-dislike")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(UserData.Token ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let stringData = (String(data: data, encoding: .utf8)!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                do{
                    if let json = stringData.data(using: String.Encoding.utf8){
                        if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                            print(jsonData)
                            let message = jsonData["message"] as? String ?? ""
                            self.apiCalled(api: .movieDetail(self.selectedMovieId), param: [:], method: .get)
                            self.view.makeToast(message)

                        }
                    }
                }catch {
                    print(error.localizedDescription)

                }
            }
        }

        task.resume()
        
        
        
    }
    
    @IBAction func disLikeButtonAction(_ sender: UIButton){
//        var param = [String:Any]()
//        param["movie_id"] = selectedMovieId
//        param["status"] = 2
//        self.apiCalled(api: .likeDisLikeMovie, param: param, method: .post)
        
        let parameters = "{\n    \"movie_id\": \(selectedMovieId),\n    \"status\": 2\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(baseUrl)movies/movie-like-dislike")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(UserData.Token ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            let stringData = (String(data: data, encoding: .utf8)!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                do{
                    if let json = stringData.data(using: String.Encoding.utf8){
                        if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                            print(jsonData)
                            let message = jsonData["message"] as? String ?? ""
                            self.apiCalled(api: .movieDetail(self.selectedMovieId), param: [:], method: .get)
                            self.view.makeToast(message)

                        }
                    }
                }catch {
                    print(error.localizedDescription)

                }
            }
        }

        task.resume()
    }
    func showInfoOnUI() {
        self.thumbnailImgView.showImage(imgURL: selectedMovie?.videoImageThumb ?? "")
        self.movieNameLbl.text = selectedMovie?.videoTitle
        self.descLbl.attributedText = (selectedMovie?.videoDescription ?? "").htmlToAttributedString
        self.ratingLbl.text = selectedMovie?.imdbRating
        self.ageLbl.text = (self.movieDetail?.adult ?? "") == "1" ? "18+" : "12+"
        self.yearLbl.text = "2020"
        
        let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
        let textData = String(format: font, selectedMovie?.videoDescription ?? "").data(using: .utf8)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html]
        do {
            let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
            self.descLbl.attributedText = attText
        } catch {
            print(error)
        }
        
        
        if let movDetail = self.movieDetail {
            if movDetail.is_liked == 0{
                self.likeButton.isUserInteractionEnabled = true
                self.disLikeButton.isUserInteractionEnabled = true

            }else{
                self.likeButton.isUserInteractionEnabled = false
                self.disLikeButton.isUserInteractionEnabled = false
            }
            
            if movDetail.is_liked_status == 0{
                self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                self.disLikeButton.setImage(UIImage(named: "dislike"), for: .normal)

            }else if movDetail.is_liked_status == 1{
                self.likeButton.setImage(UIImage(named: "like-2"), for: .normal)
                self.disLikeButton.setImage(UIImage(named: "dislike"), for: .normal)
            }else if movDetail.is_liked_status == 2{
                self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                self.disLikeButton.setImage(UIImage(named: "dislike-2"), for: .normal)
            }
            self.likeButton.imageView?.setImageColor(color: UIColor(named: "Color2")!)
            self.disLikeButton.imageView?.setImageColor(color: UIColor(named: "Color2")!)

            self.movieNameLbl.text = movDetail.videoTitle
            self.descLbl.text = movDetail.videoDescription
            self.thumbnailImgView.showImage(imgURL: movDetail.videoImageThumb ?? "")
            self.favoriteBtn.tintColor = (movDetail.isFavorite ?? 0) == 1 ? .yellow : .lightGray
            
            let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
            let textData = String(format: font, movDetail.videoDescription ?? "").data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                self.descLbl.attributedText = attText
            } catch {
                print(error)
            }
            
            if (movDetail.trailer ?? "") == "" {
                watchTrailerLbl.text = ""
                trailerImgView.isHidden = true
                trailerPlayBtn.isHidden = true
                
                trailerImgView.translatesAutoresizingMaskIntoConstraints = true
                trailerImgView.frame.size.height = 0
                trailorImgBottomConst.constant = 0
                watchTrailerLblTopConst.constant = 0
                self.view.layoutIfNeeded()
            } else {
                trailerImgView.showImage(imgURL: movDetail.videoImage ?? "", isMode: true)
            }
            
        }
    }
    
    func addFavorite() {
        let param = ["type"     : 1,
                     "id"       : selectedMovieId,
                     "status"   : 1]
        print(param)
        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
    }
    
    func removeFavorite() {
        let param = ["type"     : 1,
                     "id"       : selectedMovieId,
                     "status"   : 0]
        print(param)
        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
    }


    // MARK: - IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.apiCalled(api: .watchMovie(selectedMovieId), param: ["movie_watch_id": watchModel?.id ?? 0, "timer": 1], method: .post, isEncoding: true)
        
        self.player.pause()
        self.player.stopPlayerBuffering()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionWatchTrailor(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortraitPlayerVC") as? PortraitPlayerVC {
            vc.isTrailor = true
            vc.movieDetail = self.movieDetail
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionSeeAll(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
            vc.isAllMovies = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        if (self.movieDetail?.isFavorite ?? 0) == 1 {
            self.removeFavorite()
        } else {
            self.addFavorite()
        }
        
//        WebServices.downloadVideoWith(url: URL(string: self.movieDetail?.videoURL ?? "")!)
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        if UserData.User == nil {
            self.openSignInScreen()
            return
        } else {
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortraitPlayerVC") as? PortraitPlayerVC {
//                vc.movieDetail = self.movieDetail
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            
            
            if (movieDetail?.type ?? "").lowercased() == "premium" {
                
                if (movieDetail?.subscription ?? 0) == 0 {
                    
                    self.player.pause()
                    self.thumbnailImgView.isHidden = false
                    self.playerView.isHidden = true
                    self.playBtn.isHidden = false
                    
                    Alert.show(message: "To watch this video, you have to purchase subscription.", actionTitle1: "Subscription", actionTitle2: "Cancel", completionOK: {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionsVC") as! SubscriptionsVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                } else {
                    if !isAlertShown && (self.movieDetail?.adult ?? "") == "1"{
                        
                        isAlertShown = true
                        
                        self.player.pause()
                        self.thumbnailImgView.isHidden = false
                        self.playerView.isHidden = true
                        self.playBtn.isHidden = false
                        
                        // Restrict adult content
                        self.showAlert()
                        
                    } else {
                        self.playVideo()
                    }
                }
            } else {
                
                if !isAlertShown && (self.movieDetail?.adult ?? "") == "1"{
                    
                    isAlertShown = true
                    
                    self.player.pause()
                    self.thumbnailImgView.isHidden = false
                    self.playerView.isHidden = true
                    self.playBtn.isHidden = false
                    
                    // Restrict adult content
                    self.showAlert()
                    
                } else {
                    self.playVideo()
                }
            }
        }
    }
    
    func playVideo() {
//        if adView == nil {
//            configCacheAds()
//        }
        
        self.playerView.isHidden = false
        self.playBtn.isHidden = true
        self.thumbnailImgView.isHidden = true
        self.player.play()
//        self.adView?.loadAd()
    }
}


// MARK: - API IMPLEMENTATIONS
extension MovieDetailVC {
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
    func stopAnimation(){
        self.animationView.isHidden = true
        animationView!.stop()
    }
    func apiCalled(api: Api, param: [String:Any], method: HTTPMethod, isEncoding: Bool = false) {
//        Hud.show(message: "", view: self.view)
        self.playAnimation()
        WebServices.post(url: api, jsonObject: param, method: method, isEncoding: isEncoding) { jsonData in
//            Hud.hide(view: self.view)
            self.stopAnimation()
            
            do {
                switch api {
                case .likeDisLikeMovie:
                    print(jsonData)
                    
                case .movieDetail:
                    let movieModel = try JSONDecoder().decode(MovieDetailModel.self, from: jsonData)
                    if (movieModel.success ?? false) {
                        self.movieDetail = movieModel.body
                        self.showInfoOnUI()
                        let movieURL = (self.movieDetail?.videoURL ?? "").replacingOccurrences(of: " ", with: "%20")
                        self.player.replaceVideo(URL(string: movieURL)!)
                    } else {
                        if movieModel.code == 402{
                            Alert.showSimple("Someone use this account") {
                                UserData.User = nil
                                UserData.Token = nil
                                self.openSignInScreen()
                            }
                        }    else{
                            Alert.show(message: movieModel.message ?? "")

                        }
                    }
                case .addToFavorite:
                    let favModel = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                    if let code = favModel["code"] as? Int {
                        let message = favModel["message"] as? String ?? ""
                        if code == 200 {
                            self.apiCalled(api: .movieDetail(self.selectedMovieId), param: [:], method: .get)
                            self.view.makeToast(message)
                        } else {
                            self.view.makeToast(message)
                        }
                    }
                case .recommandedMovies:
                    let movieModel = try JSONDecoder().decode(RecommendedMoviesModel.self, from: jsonData)
                    if (movieModel.success ?? false) {
                        self.recommendedMovies = movieModel.body ?? []
                        self.recommendedMovieCollCell.reloadData()
                    } else {
                        
                    }
                case .watchMovie(self.selectedMovieId):
                    let movieModel = try JSONDecoder().decode(WatchMovieModel.self, from: jsonData)
                    if (movieModel.success ?? false) {
                        self.watchModel = movieModel.body
                    } else {
                        
                    }
                default:
                    break
                }
            } catch {
                print(error)
            }
        } failureHandler: { errorJson in
//            Hud.hide(view: self.view)
            self.stopAnimation()
        }
    }
}


class RecommendedMovieCollectionCell: UICollectionViewCell {
    @IBOutlet weak var movieImgView: RoundImageView!
}


// MARK: - COLLECTION VIEW DATA SOURCE METHODS
extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedMovieCollectionCell", for: indexPath) as! RecommendedMovieCollectionCell
        cell.movieImgView.showImage(imgURL: recommendedMovies[indexPath.row].videoImageThumb ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.player.pause()
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
            vc.selectedMovieId = recommendedMovies[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



extension MovieDetailVC: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
        
        switch state {
        case .playing:
//            self.playCount += 1
//            if self.playCount == 2 {
//                self.player.pause()
//                self.thumbnailImgView.isHidden = false
//                self.playerView.isHidden = true
//                self.playBtn.isHidden = false
//
//                // Restrict adult content
//                if (self.movieDetail?.adult ?? "") == "1" {
//                    self.showAlert()
//                }
//        }
            break
            
        default:
            break
        }
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "This video contains adult content marked as age restricted. Do you wish to proceed?", preferredStyle: .alert)
        let actionProceed = UIAlertAction(title: "Proceed", style: .default) { _ in
            self.player.play()
//            self.adView?.loadAd()
            self.thumbnailImgView.isHidden = true
            self.playerView.isHidden = false
            self.playBtn.isHidden = true
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default) { _ in
            self.isAlertShown = false
        }
        alert.addAction(actionProceed)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension MovieDetailVC: VGPlayerViewDelegate {
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
    }
    
    func vgPlayerView(didDoubleTap: TapSide) {
        
    }
}


// MARK: - JIO ADS DELEGATE METHODS
//extension MovieDetailVC: JIOAdViewProtocol {
//    func onAdReceived(adView: JioAdView) {
//        print("onAdReceived")
//    }
//
//    func onAdPrepared(adView: JioAdView) {
//        print("onAdPrepared")
//
////        if playCount == 2 {
////            self.adView?.loadAd()
////        }
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
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
