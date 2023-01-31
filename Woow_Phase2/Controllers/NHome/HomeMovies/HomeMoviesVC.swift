//
//  HomeMoviesVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 23/02/22.
//

import UIKit
import Alamofire
import IBAnimatable
import Lottie
class HomeMoviesVC: UIViewController {
    @IBOutlet weak var animationView: LottieAnimationView!

    @IBOutlet weak var hiLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    static let TABLE_ROW_HEIGHT = 140.0
    var moviesList = [HomeContent]()
    let refreshControl = UIRefreshControl()
    var isRefresh: Bool = false {
        didSet {
            if isRefresh && tableView != nil {
                self.apiCalled(api: .moviesByCategory, param: [:], method: .get)
            }
        }
    }
    
    
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
        self.apiCalled(api: .moviesByCategory, param: [:], method: .get)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        self.apiCalled(api: .moviesByCategory, param: [:], method: .get)
    }

    
    @IBAction func actionAllMovies(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
            vc.isAllMovies = true
            vc.action == .allMovies
            vc.isLanguageOptionHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension HomeMoviesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return moviesList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        
        let label1 = UILabel()
        label1.text = moviesList[section].title //"Popular Movies"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMovieTableCell", for: indexPath) as! HomeMovieTableCell
        cell.homeMovieVC = self
        cell.configure(movieContent: moviesList[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeMoviesVC.TABLE_ROW_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func viewMoreAction(btn: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PopularMoviesVC") as? PopularMoviesVC {
            vc.selectedMovie = moviesList[btn.tag]
            vc.isAllMovies = false
            vc.action = .movieListing
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class HomeMovieTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var movieContent: HomeContent?
    weak var homeMovieVC: HomeMoviesVC?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeMovieReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeMovieReusableView")
    }
    
    func configure(movieContent: HomeContent) {
        self.movieContent = movieContent
        self.collectionView.reloadData()
    }
}


extension HomeMovieTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieContent?.content?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMovieCollectionCell", for: indexPath) as! HomeMovieCollectionCell
        cell.configure(movie: movieContent!.content![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: HomeMoviesVC.TABLE_ROW_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = homeMovieVC?.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
            vc.selectedMovie = movieContent?.content?[indexPath.row]
            homeMovieVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class HomeMovieCollectionCell: UICollectionViewCell {
    @IBOutlet weak var ratingView: AnimatableView!
    @IBOutlet weak var raitngLbl: UILabel!
    @IBOutlet weak var movieImgView: AnimatableImageView!
    
    func configure(movie: HomeContent.Content) {
        movieImgView.showImage(imgURL: movie.videoImageThumb ?? "")
//        raitngLbl.text =  (movie.type ?? "") != "" ? movie.type! : "Free" //movie.imdbRating ?? ""
        
        if movie.access_message == nil || movie.access_message == ""{
            raitngLbl.text = (movie.type ?? "") != "" ? movie.type! : "Free"

        }else{
            raitngLbl.text = (movie.access_message ?? "") //(content.access_message ?? "") != "" ? content.access_message! : "Free"

        }
    }
}



// MARK:- API IMPLEMENTATIONS
extension HomeMoviesVC {
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
            self.refreshControl.endRefreshing()
//            Hud.hide(view: self.view)
            self.stopAnimation()
            
            do {
                let moviesModel = try JSONDecoder().decode(MoviesListModel.self, from: jsonData)
                if (moviesModel.success ?? false) {
                    switch api {
                    case .moviesByCategory:
                        self.moviesList = moviesModel.body ?? []
                        self.tableView.reloadData()
                        
                    default:
                        break
                    }
                } else {
                    Alert.show(message: moviesModel.message ?? "")
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
