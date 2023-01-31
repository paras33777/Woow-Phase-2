//
//  SeriesDetailVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 21/02/22.
//

import UIKit
import Alamofire
import IBAnimatable
import Lottie
//import JioAdsFramework

class SeriesDetailVC: UIViewController,NetworkSpeedProviderDelegate {

    // MARK: - OUTLETS
    @IBOutlet weak var navBarHeightConst: NSLayoutConstraint!
    @IBOutlet weak var animationView: LottieAnimationView!

    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var mainContentTopConst: NSLayoutConstraint!
    @IBOutlet weak var playerViewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var navBarTopConst: NSLayoutConstraint!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var recommendedSeriesCollView: UICollectionView!
    @IBOutlet weak var selectedEpisodeLbl: UILabel!
    @IBOutlet weak var episodesTableView: UITableView!
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    @IBOutlet weak var trailorImgView: AnimatableImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var episodeCollView: UICollectionView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!
    @IBOutlet weak var likeDislikeView: UIView!
    var selectedSeries: HomeContent.Content?
    var seriesId = 0
    var watchModel: WatchMovieModel.Body?
    var seriesDetail: SeriesDetailModel.Series?
    var recommendedShows = [RecommendedSeriesModel.Body]()
    var player = VGPlayer()
    override var shouldAutorotate: Bool { return false }
//    var adView: JioAdView?
    var adspotId: String?
    var isAlertShown = false
    let test = NetworkSpeedTest()

    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        test.delegate = self
               test.networkSpeedTestStop()
               // Do any additional setup after loading the view.
        if UserData.User == nil {
            self.likeDislikeView.isHidden = true
        }else{
            self.likeDislikeView.isHidden = false

        }
        self.showInfoOnUI()
        self.apiCalled(api: .seriesDetail(seriesId), param: [:], method: .get)
        self.apiCalled(api: .watchSeries(seriesId), param: [:], method: .get)
        self.apiCalled(api: .recommandedSeries(seriesId), param: [:], method: .get)
        self.configurePlayer()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            
            self.navBarView.isHidden = true
            self.navBarHeightConst.constant = 0
            self.mainContentTopConst.constant = UIScreen.main.bounds.height - thumbnailImgView.frame.size.height
        } else {
            print("Portrait")
            self.navBarView.isHidden = false
            self.navBarHeightConst.constant = 60
            self.mainContentTopConst.constant = -100
        }
    }
    func callWhileSpeedChange(networkStatus: NetworkStatus) {
           switch networkStatus {
           case .poor:
               break
           case .good:
               break
           case .disConnected:
               break
           }
       }
    // MARK: - CORE METHODS
//    func configCacheAds() {
//        self.title = "InstreamVideo"
//        self.setValueInUserDefaults(objValue: "Production", for: "currentEnvironment")
//
//        JioAdSdk.setPackageName(packageName: "com.woow")
//        self.adView = JioAdView.init(adSpotId: "lhx0g6oj", adType: .InstreamVideo, delegate: self, forPresentionClass: self, publisherContainer: self.playerView)
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
//        param["series_id"] = seriesId
//        param["status"] = 1
//        self.apiCalled(api: .likeDisLikeSeries, param: param, method: .post)
        let parameters = "{\n    \"series_id\": \(seriesId),\n    \"status\": 1\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(baseUrl)series/series-like-dislike")!,timeoutInterval: Double.infinity)
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
                            self.apiCalled(api: .seriesDetail(self.seriesId), param: [:], method: .get)
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
//        param["series_id"] = seriesId
//        param["status"] = 2
//        self.apiCalled(api: .likeDisLikeSeries, param: param, method: .post)
        let parameters = "{\n    \"series_id\": \(seriesId),\n    \"status\": 2\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(baseUrl)series/series-like-dislike")!,timeoutInterval: Double.infinity)
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
                            self.apiCalled(api: .seriesDetail(self.seriesId), param: [:], method: .get)
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
        if selectedSeries != nil {
            self.seriesId = selectedSeries?.id ?? 0
            self.thumbnailImgView.showImage(imgURL: selectedSeries?.seriesPoster ?? "")
            self.movieNameLbl.text = selectedSeries?.seriesName
            self.ratingLbl.text = selectedSeries?.imdbRating
            self.ageLbl.text = "12+"
            self.yearLbl.text = "2020"
            
            let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
            let textData = String(format: font, selectedSeries?.seriesInfo ?? "").data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                self.descLbl.attributedText = attText
            } catch {
                print(error)
            }
        }
        
        if let selDetail = seriesDetail {
            
            if selDetail.is_liked == 0{
                self.likeButton.isUserInteractionEnabled = true
                self.disLikeButton.isUserInteractionEnabled = true

            }else{
                self.likeButton.isUserInteractionEnabled = false
                self.disLikeButton.isUserInteractionEnabled = false
            }
            
            if selDetail.is_liked_status == 0{
                self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                self.disLikeButton.setImage(UIImage(named: "dislike"), for: .normal)

            }else if selDetail.is_liked_status == 1{
                self.likeButton.setImage(UIImage(named: "like-2"), for: .normal)
                self.disLikeButton.setImage(UIImage(named: "dislike"), for: .normal)
            }else if selDetail.is_liked_status == 2{
                self.likeButton.setImage(UIImage(named: "like"), for: .normal)
                self.disLikeButton.setImage(UIImage(named: "dislike-2"), for: .normal)
            }
            self.likeButton.imageView?.setImageColor(color: UIColor(named: "Color2")!)
            self.disLikeButton.imageView?.setImageColor(color: UIColor(named: "Color2")!)
            
            self.thumbnailImgView.showImage(imgURL: selDetail.seriesPoster ?? "")
            self.movieNameLbl.text = selDetail.seriesName
            self.ratingLbl.text = selDetail.imdbRating
            self.ageLbl.text = "12+" //selDetail.ag
            self.yearLbl.text = selDetail.seasonListing?.first?.episodeListing?.first?.updatedAt?.convertToYear() ?? ""
            self.favoriteBtn.tintColor = (selDetail.isFavorite ?? 0) == 1 ? .yellow : .lightGray
            if let season = self.seriesDetail?.seasonListing?.filter({$0.isSelected}) {
                self.tableViewHeightConstraint.constant = CGFloat((season.first?.episodeListing?.count ?? 0) * 145)
            }
        
            self.episodeCollView.reloadData()
            self.episodesTableView.reloadData()
            
            if let firstEpis = selDetail.seasonListing?.first?.episodeListing?.first?.videoURL {
                self.player.replaceVideo(URL(string: firstEpis)!)
                test.networkSpeedTestStart(UrlForTestSpeed: firstEpis)

            }
            
            let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
            let textData = String(format: font, selDetail.seriesInfo ?? "").data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                self.descLbl.attributedText = attText
            } catch {
                print(error)
            }
            
        }
    }

    func addFavorite() {
        let param = ["type"     : 2,
                     "id"       : seriesId,
                     "status"   : 1]
        print(param)
        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
    }
    
    func removeFavorite() {
        let param = ["type"     : 2,
                     "id"       : seriesId,
                     "status"   : 0]
        print(param)
        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
    }
    

    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.apiCalled(api: .watchSeries(seriesId), param: ["movie_watch_id": watchModel?.id ?? 0, "timer": 1], method: .post, isEncoding: true)
        
//        Player.shared.pause()
        self.player.pause()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionWatchTrailor(_ sender: Any) {
    }
    
    @IBAction func actionFavorite(_ sender: Any) {
        if (self.seriesDetail?.isFavorite ?? 0) == 1 {
            self.removeFavorite()
        } else {
            self.addFavorite()
        }
    }
    
    @IBAction func actionSeeAll(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
            
            var a = [SeriesListModel.Content]()
            for each in recommendedShows {
                a.append(SeriesListModel.Content(id: each.id, creatorID: each.creatorID, appType: nil, webShow: nil, seriesLangID: each.seriesLangID, seriesGenres: each.seriesGenres, seriesName: each.seriesName, seriesSlug: each.seriesSlug, seriesInfo: each.seriesInfo, seriesPoster: each.seriesPoster, imdbID: each.imdbID, imdbRating: each.imdbRating, imdbVotes: each.imdbVotes, seoTitle: each.seoTitle, seoDescription: each.seoDescription, seoKeyword: each.seoKeyword, status: each.status, familyContent: each.familyContent, trailer: each.trailer, adult: each.adult, isFavorite: 0, isShown: false))
            }
            
            vc.selectedSeries = SeriesListModel.Body(id: selectedSeries?.id, title: selectedSeries?.videoTitle, type: nil, values: nil, isEditable: nil, app: nil, tv: nil, appSlot: nil, tvSlot: nil, createdAt: nil, updatedAt: nil, content: a)
            vc.isAllMovies = false
            vc.action = .allSeries
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionPlay(_ sender: Any) {
        if UserData.User == nil {
            self.openSignInScreen()
            return
        }
        
        for i in 0..<(seriesDetail?.seasonListing?.count ?? 0) {
            for j in 0..<(seriesDetail?.seasonListing?[i].episodeListing?.count ?? 0) {
                seriesDetail?.seasonListing?[i].episodeListing?[j].isSelected = false
            }
        }
        if let index = seriesDetail?.seasonListing?.firstIndex(where: {$0.isSelected}) {
            if (seriesDetail?.seasonListing?[index].episodeListing?.count ?? 0) != 0 {
                seriesDetail?.seasonListing?[index].episodeListing?[0].isSelected = true
            } else {
                self.view.makeToast("There is no episodes in this series.")
                return
            }
        }
        
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortraitPlayerVC") as? PortraitPlayerVC {
//            vc.playerType = .series
//            vc.previousVC = self
//            if let season = seriesDetail?.seasonListing?.filter({$0.isSelected}).first {
//                vc.seriesDetail = season.episodeListing![0]
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
//        if adView == nil {
//            configCacheAds()
//        }
        
        
        if (seriesDetail?.type ?? "").lowercased() == "premium" {
            if (seriesDetail?.subscription ?? 0) == 0 {
                self.player.pause()
                self.thumbnailImgView.isHidden = false
                self.playerView.isHidden = true
                self.playBtn.isHidden = false
                
                Alert.show(message: "To watch this video, you have to purchase subscription.", actionTitle1: "Subscription", actionTitle2: "Cancel", completionOK: {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionsVC") as! SubscriptionsVC
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            } else {
                if !isAlertShown && (self.seriesDetail?.adult ?? "") == "1"{
                    
                    isAlertShown = true
                    
                    self.player.pause()
                    self.thumbnailImgView.isHidden = false
                    self.playerView.isHidden = true
                    self.playBtn.isHidden = false
                    
                    // Restrict adult content
                    self.showAlert()
                    
                } else {
                    self.playerView.isHidden = false
                    self.playBtn.isHidden = true
                    self.thumbnailImgView.isHidden = true
                    self.player.play()
//                    self.adView?.loadAd()
                }
            }
            
        } else {
            if !isAlertShown && (self.seriesDetail?.adult ?? "") == "1"{
                isAlertShown = true
                
                self.player.pause()
                self.thumbnailImgView.isHidden = false
                self.playerView.isHidden = true
                self.playBtn.isHidden = false
                
                // Restrict adult content
                self.showAlert()
                
            } else {
                self.playerView.isHidden = false
                self.playBtn.isHidden = true
                self.thumbnailImgView.isHidden = true
                self.player.play()
//                self.adView?.loadAd()
            }
        }
    }
}


// MARK: - API IMPLEMENTATIONS
extension SeriesDetailVC {
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
                case .likeDisLikeSeries:
                    print(jsonData)
                    
                    
                case .seriesDetail(self.seriesId):
                    let seriesModel = try JSONDecoder().decode(SeriesDetailModel.self, from: jsonData)
                    if (seriesModel.success ?? false) {
                        self.seriesDetail = seriesModel.body
                        if (self.seriesDetail?.seasonListing?.count ?? 0) > 0 {
                            self.seriesDetail?.seasonListing?[0].isSelected = true
                        }
                  
                        self.showInfoOnUI()
                    }else{
                        if seriesModel.code == 402{
                            Alert.showSimple("Someone use this account") {
                                UserData.User = nil
                                UserData.Token = nil
                                self.openSignInScreen()
                            }
                        }    else{
                            Alert.show(message: seriesModel.message ?? "")

                        }
                    }
                case .recommandedSeries:
                    let seriesModel = try JSONDecoder().decode(RecommendedSeriesModel.self, from: jsonData)
                    if (seriesModel.success ?? false) {
                        self.recommendedShows = seriesModel.body ?? []
                        self.recommendedSeriesCollView.reloadData()
                    }
                case .addToFavorite:
                    let favModel = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                    if let code = favModel["code"] as? Int {
                        let message = favModel["message"] as? String ?? ""
                        if code == 200 {
                            self.apiCalled(api: .seriesDetail(self.seriesId), param: [:], method: .get)
                            self.view.makeToast(message)
                        } else {
                            self.view.makeToast(message)
                        }
                    }
                case .watchSeries(self.seriesId):
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


// MARK: - COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
extension SeriesDetailVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == recommendedSeriesCollView {
            return recommendedShows.count
        } else {
            return seriesDetail?.seasonListing?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommendedSeriesCollView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedMovieCollectionCell", for: indexPath) as! RecommendedMovieCollectionCell
            cell.movieImgView.showImage(imgURL: recommendedShows[indexPath.row].seriesPoster ?? "")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeSeriesCollCell", for: indexPath) as! EpisodeSeriesCollCell
            cell.episodeNameLbl.text = seriesDetail?.seasonListing?[indexPath.row].seasonName
            (seriesDetail?.seasonListing?[indexPath.row].isSelected ?? false) == true ? cell.selectedCell() : cell.unselectedCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recommendedSeriesCollView {
            self.player.pause()
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
                vc.seriesId = recommendedShows[indexPath.row].id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            for i in 0..<(self.seriesDetail?.seasonListing?.count ?? 0) {
                self.seriesDetail?.seasonListing?[i].isSelected = false
                if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? EpisodeSeriesCollCell {
                    cell.unselectedCell()
                }
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? EpisodeSeriesCollCell {
                self.seriesDetail?.seasonListing?[indexPath.row].isSelected = true
                cell.selectedCell()
            }
            self.episodesTableView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
}


extension SeriesDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let season = seriesDetail?.seasonListing?.filter({$0.isSelected}) {
            return season.first?.episodeListing?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableCell", for: indexPath) as! EpisodeTableCell
        if let season = seriesDetail?.seasonListing?.filter({$0.isSelected}).first {
            cell.configure(episode: season.episodeListing![indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserData.User == nil {
            self.openSignInScreen()
            return
        }
        
        if let season = seriesDetail?.seasonListing?.filter({$0.isSelected}).first {
            self.selectedEpisodeLbl.text = season.episodeListing![indexPath.row].videoTitle ?? "Trailer"
            
            if let epiURL = season.episodeListing![indexPath.row].videoURL, let url = URL(string: epiURL.replacingOccurrences(of: " ", with: "%20")) {
                self.player.replaceVideo(url)
                test.networkSpeedTestStart(UrlForTestSpeed: epiURL)

                self.player.play()
                self.playerView.isHidden = false
                self.playBtn.isHidden = true
                self.thumbnailImgView.isHidden = true
            }
        }
        
        for i in 0..<(seriesDetail?.seasonListing?.count ?? 0) {
            for j in 0..<(seriesDetail?.seasonListing?[i].episodeListing?.count ?? 0) {
                seriesDetail?.seasonListing?[i].episodeListing?[j].isSelected = false
            }
        }
        if let index = seriesDetail?.seasonListing?.firstIndex(where: {$0.isSelected}) {
            if (seriesDetail?.seasonListing?[index].episodeListing?.count ?? 0) == 0 {
                return
            }
            seriesDetail?.seasonListing?[index].episodeListing?[indexPath.row].isSelected = true
        }
        
        /*if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortraitPlayerVC") as? PortraitPlayerVC {
            vc.playerType = .series
            vc.previousVC = self
            if let season = seriesDetail?.seasonListing?.filter({$0.isSelected}).first {
                vc.seriesDetail = season.episodeListing![indexPath.row]
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
    }
    
    func increaseSeriesSelection() -> SeriesDetailModel.SeasonListing.EpisodeListing? {
        var selectedEpisodeIndex: Int = 0
        for i in 0..<(seriesDetail?.seasonListing?.count ?? 0) {
            for j in 0..<(seriesDetail?.seasonListing?[i].episodeListing?.count ?? 0) {
                if seriesDetail?.seasonListing?[i].episodeListing?[j].isSelected ?? false {
                    selectedEpisodeIndex = j
                }
                seriesDetail?.seasonListing?[i].episodeListing?[j].isSelected = false
            }
        }
        if let index = seriesDetail?.seasonListing?.firstIndex(where: {$0.isSelected}) {
            if (seriesDetail?.seasonListing?[index].episodeListing?.count ?? 0) > (selectedEpisodeIndex + 1) {
                seriesDetail?.seasonListing?[index].episodeListing?[selectedEpisodeIndex+1].isSelected = true
                return seriesDetail?.seasonListing?[index].episodeListing?[selectedEpisodeIndex+1]
            }
        }
        return nil
    }
    
    func decreaseSeriesSelection() -> SeriesDetailModel.SeasonListing.EpisodeListing? {
        var selectedEpisodeIndex: Int = 0
        for i in 0..<(seriesDetail?.seasonListing?.count ?? 0) {
            for j in 0..<(seriesDetail?.seasonListing?[i].episodeListing?.count ?? 0) {
                if seriesDetail?.seasonListing?[i].episodeListing?[j].isSelected ?? false {
                    selectedEpisodeIndex = j
                }
                seriesDetail?.seasonListing?[i].episodeListing?[j].isSelected = false
            }
        }
        if let index = seriesDetail?.seasonListing?.firstIndex(where: {$0.isSelected}) {
            if (seriesDetail?.seasonListing?[index].episodeListing?.count ?? 0) > (selectedEpisodeIndex - 1) {
                seriesDetail?.seasonListing?[index].episodeListing?[selectedEpisodeIndex-1].isSelected = true
                return seriesDetail?.seasonListing?[index].episodeListing?[selectedEpisodeIndex-1]
            }
        }
        return nil
    }
}


class EpisodeSeriesCollCell: UICollectionViewCell {
    @IBOutlet weak var episodeNameLbl: UILabel!
    
    func selectedCell() {
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor(named: "Color2")!.cgColor
        contentView.layer.borderWidth = 1.0
        episodeNameLbl.textColor = .white
        contentView.backgroundColor = UIColor(named: "Color2")!
    }
    
    func unselectedCell() {
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1.0
        episodeNameLbl.textColor = .white
        contentView.backgroundColor = UIColor.clear
    }
}


class EpisodeTableCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var episodeNoLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var episodeImgView: AnimatableImageView!
    
    func configure(episode: SeriesDetailModel.SeasonListing.EpisodeListing) {
        episodeImgView.showImage(imgURL: episode.videoImage ?? "")
        nameLbl.text = episode.seoTitle
        episodeNoLbl.text = episode.videoTitle
        yearLbl.text = episode.updatedAt?.convertToYear()
        ageLbl.text = "18+"
    }
}



extension SeriesDetailVC: VGPlayerDelegate {
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
//                if (self.seriesDetail?.adult ?? "") == "" {
//                    self.showAlert()
//                }
//            }
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

extension SeriesDetailVC: VGPlayerViewDelegate {
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {

    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.player.pause()
//            self.mediaPlayer.pause()
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


extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .allButUpsideDown
    }
}


// MARK: - JIO ADS DELEGATE METHODS
//extension SeriesDetailVC: JIOAdViewProtocol {
//    func onAdReceived(adView: JioAdView) {
//        print("onAdReceived")
//    }
//
//    func onAdPrepared(adView: JioAdView) {
//        print("onAdPrepared")
////        self.adView?.loadAd()
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
