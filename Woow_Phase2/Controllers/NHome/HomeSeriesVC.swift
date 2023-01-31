//
//  HomeSeriesVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 28/03/22.
//

import UIKit
import Alamofire
import IBAnimatable
import Lottie

class HomeSeriesVC: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var hiLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: LottieAnimationView!
    static let TABLE_ROW_HEIGHT = 140.0
    var seriesList = [SeriesListModel.Body]()
    let refreshControl = UIRefreshControl()
    var isRefresh: Bool = false {
        didSet {
            if isRefresh && tableView != nil {
                self.apiCalled(api: .seriesByCategory, param: [:], method: .get)
            }
        }
    }
    
    
    // MARK: - VIEW LUFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        hiLbl.text = "Hi, \(UserData.User?.name ?? "")"
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [.foregroundColor: UIColor.white])
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCalled(api: .seriesByCategory, param: [:], method: .get)
    }

    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.apiCalled(api: .seriesByCategory, param: [:], method: .get)
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func actionAllMovies(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
            vc.isAllMovies = false
            vc.action = .allSeries
            vc.isLanguageOptionHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK: - TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension HomeSeriesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return seriesList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        
        let label1 = UILabel()
        label1.text = seriesList[section].title //"Popular Movies"
//        label1.font = AppFonts.SFProDisplayMedium.withSize(20.0)
        label1.textColor = .white
        containerView.addSubview(label1)
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        let viewMoreBtn = UIButton()
        viewMoreBtn.setTitle("View More", for: .normal)
//        viewMoreBtn.titleLabel?.font = AppFonts.SFProTextRegular.withSize(13.0)
        viewMoreBtn.setTitleColor(UIColor(white: 1.0, alpha: 0.4), for: .normal)
        containerView.addSubview(viewMoreBtn)
        viewMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        viewMoreBtn.tag = section
        viewMoreBtn.addTarget(self, action: #selector(viewMoreAction(btn:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            label1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            label1.trailingAnchor.constraint(equalTo: viewMoreBtn.leadingAnchor, constant: 10.0),
            label1.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            viewMoreBtn.centerYAnchor.constraint(equalTo: label1.centerYAnchor),
            viewMoreBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0)
        ])
        
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSeriesTableCell", for: indexPath) as! HomeSeriesTableCell
        cell.homeSeriesVC = self
        cell.configure(series: seriesList[indexPath.section].content!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeSeriesVC.TABLE_ROW_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func viewMoreAction(btn: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
            vc.selectedSeries = seriesList[btn.tag]
            vc.isAllMovies = false
            vc.action = .seriesListing
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class HomeSeriesTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var seriesContent = [SeriesListModel.Content]()
    weak var homeSeriesVC: HomeSeriesVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeMovieReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeMovieReusableView")
    }
    
    func configure(series: [SeriesListModel.Content]) {
        self.seriesContent = series
        self.collectionView.reloadData()
    }
}


extension HomeSeriesTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seriesContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeSeriesCollectionCell", for: indexPath) as! HomeSeriesCollectionCell
        cell.configure(series: seriesContent[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width * 0.6, height: HomeSeriesVC.TABLE_ROW_HEIGHT)
        return CGSize(width: 100, height: HomeSeriesVC.TABLE_ROW_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let vc = homeMovieVC?.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
//            vc.selectedMovie = movieContent?.content?[indexPath.row]
//            homeMovieVC?.navigationController?.pushViewController(vc, animated: true)
//        }
        if let vc = homeSeriesVC?.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
            vc.seriesId = seriesContent[indexPath.row].id ?? 0
            homeSeriesVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class HomeSeriesCollectionCell: UICollectionViewCell {
    @IBOutlet weak var ratingView: AnimatableView!
    @IBOutlet weak var raitngLbl: UILabel!
    @IBOutlet weak var movieImgView: AnimatableImageView!
    
    func configure(series: SeriesListModel.Content) {
        movieImgView.showImage(imgURL: series.seriesPoster ?? "")
//        raitngLbl.text = series.imdbRating ?? "0.0"
        raitngLbl.text =  (series.type ?? "") != "" ? series.type! : "Free"
        if series.access_message == nil || series.access_message == ""{
            raitngLbl.text = (series.type ?? "") != "" ? series.type! : "Free"

        }else{
            raitngLbl.text = (series.access_message ?? "") //(content.access_message ?? "") != "" ? content.access_message! : "Free"

        }
    }
}



// MARK: - API IMPLEMENTATIONS
extension HomeSeriesVC {
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
    func apiCalled(api: Api, param: [String:Any], method: HTTPMethod) {
//        Hud.show(message: "", view: self.view)
        self.playAnimation()
        WebServices.post(url: api, jsonObject: param, method: method, isEncoding: false) { jsonData in
//            Hud.hide(view: self.view)
            self.stopAnimation()
            self.refreshControl.endRefreshing()
            
            do {
                let seriesModel = try JSONDecoder().decode(SeriesListModel.self, from: jsonData)
                if (seriesModel.success ?? false) {
                    switch api {
                    case .seriesByCategory:
                        self.seriesList = seriesModel.body ?? []
                        self.tableView.reloadData()
                        
                    default:
                        break
                    }
                } else {
                    Alert.show(message: seriesModel.message ?? "")
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
