//
//  PopularMoviesVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 14/03/22.
//

import UIKit
import IBAnimatable
import Alamofire
import DropDown
import Lottie

enum PopularEnum {
    case none
    case allSeries
    case seriesListing
    case allMovies
    case movieListing
    case recentWatched
}

class PopularMoviesVC: UIViewController {

    @IBOutlet weak var tableVew: UITableView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var categoryCollView: UICollectionView!
    @IBOutlet weak var collHeightConst: NSLayoutConstraint!
    @IBOutlet weak var catCollBottomConst: NSLayoutConstraint!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var animationView: LottieAnimationView!

    var selectedMovie: HomeContent?
    var isAllMovies: Bool = false
    var allMovieList = [AllMovieModel.Body]()
    var searchMovieList = [AllMovieModel.Body]()
    var selectedSeries: SeriesListModel.Body?
    var seriesLists = [SeriesDetailModel.Series]()
    var searchSeriesLists = [SeriesDetailModel.Series]()
    var languages = [LanguageListModel.Body]()
//    var searchMovies = [
    var action: PopularEnum = .none
    var movieTitle = "All Movies"
    var isSearch = false
    var isLanguageOptionHidden = true
    let dropdown = DropDown()
    var genreId = "newest"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLbl.text = selectedMovie?.title 
//        searchTxtField.attributedPlaceholder = NSAttributedString(string: "Search here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 106, green: 108, blue: 110), .font: AppFonts.SFProDisplayRegular.withSize(16.0)])
//
        if isLanguageOptionHidden {
            categoryCollView.isHidden = !isAllMovies
            collHeightConst.constant = isAllMovies ? 50 : 0
            catCollBottomConst.constant = isAllMovies ? 15 : 0
        }
//        categoryCollView.isHidden = !isAllMovies
//        collHeightConst.constant = isAllMovies ? 50 : 0
//        catCollBottomConst.constant = isAllMovies ? 15 : 0
        
        if self.action != .recentWatched {
            self.apiCalled(api: .allLanguages, param: [:], method: .get)
            filterBtn.isHidden = false
        } else {
            filterBtn.isHidden = true
        }
        
        
        if isAllMovies {
//            self.apiCalled(api: .moviesByLanguages, param: [:], method: .get)
            titleLbl.text = "All Movies"
        } else if action == .seriesListing {
            titleLbl.text = selectedSeries?.title
            
        } else if action == .allSeries {
            titleLbl.text = "All Series"
        } else {
            titleLbl.text = self.selectedMovie?.title //"All Movies"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidCange(notification:)), name: UITextField.textDidChangeNotification, object: searchTxtField)
        
        dropdown.anchorView = filterBtn
        dropdown.dataSource = ["Newest", "Oldest", "A to Z", "Random"]
        dropdown.width = 150
        dropdown.selectionAction = { (index, selectedText) in
            if index == 0 {
                self.genreId = "newest"
            } else if index == 1 {
                self.genreId = "oldest"
            } else if index == 2 {
                self.genreId = "atoz"
            } else {
                self.genreId = "random"
            }
            
            if self.isAllMovies {
                self.apiCalled(api: .moviesByLanguages(self.genreId), param: [:], method: .get)
            } else if self.action == .allMovies || self.action == .movieListing {
                self.apiCalled(api: .moviesByLanguages(self.genreId), param: [:], method: .get)
            } else if self.action == .recentWatched {
                
            } else {
                self.apiCalled(api: .allSeries(self.languages[0].id ?? 1, self.genreId), param: [:], method: .get)
            }
        }
    }
    
    @objc func textDidCange(notification: NSNotification) {
        /*if let obj = notification.object as? UITextField {
            if obj == searchTxtField {
                self.isSearch = obj.text! != ""
                
                if action == .allSeries || action == .seriesListing {
                    self.searchSeriesLists = self.seriesLists.filter({($0.seriesName ?? "").lowercased().contains(obj.text!.lowercased())})
                } else if action == .allMovies {
                    if let selected = allMovieList.filter({$0.isSelected}).first {
//                        searchMovieList = selected.movies?.filter({($0.videoTitle ?? "").lowercased().contains(obj.text!.lowercased())}) ?? []
                    }
                    
                } else if action == .movieListing {
                    
                }
                self.tableView.reloadData()
            }
        }*/
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        dropdown.show()
    }
}


// MARK: - COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
extension PopularMoviesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isAllMovies ? allMovieList.count : languages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeSeriesCollCell", for: indexPath) as! EpisodeSeriesCollCell
        
        if isAllMovies {
            cell.episodeNameLbl.text = allMovieList[indexPath.row].languageName
            allMovieList[indexPath.row].isSelected ? cell.selectedCell() : cell.unselectedCell()
        } else {
            cell.episodeNameLbl.text = languages[indexPath.row].languageName
            languages[indexPath.row].isSelected ? cell.selectedCell() : cell.unselectedCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isAllMovies {
            for i in 0..<allMovieList.count {
                allMovieList[i].isSelected = false
                if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? EpisodeSeriesCollCell {
                    cell.unselectedCell()
                }
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? EpisodeSeriesCollCell {
                cell.selectedCell()
            }
            allMovieList[indexPath.row].isSelected = true
            
        } else {
            for i in 0..<languages.count {
                languages[i].isSelected = false
                if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? EpisodeSeriesCollCell {
                    cell.unselectedCell()
                }
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? EpisodeSeriesCollCell {
                cell.selectedCell()
            }
            languages[indexPath.row].isSelected = true
            
            self.apiCalled(api: .allSeries(languages[indexPath.row].id ?? 1, self.genreId), param: [:], method: .get)
        }
        
        
        self.tableVew.reloadData()
    }
}


// MARK: - TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension PopularMoviesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAllMovies || action == .allMovies || action == .movieListing {
            if let selected = allMovieList.filter({$0.isSelected}).first {
                return selected.movies?.count ?? 0
            }
            return 0
        } else if action == .seriesListing || action == .allSeries {
//            return selectedSeries?.content?.count ?? 0
            return seriesLists.count
        }
        
        print("🤬🤬🤬🤬🤬🤬🤬🤬🤬")
        return selectedMovie?.content?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularTableCell", for: indexPath) as! PopularTableCell
        
        cell.parentVC = self
        cell.dropdownBtn.tag = indexPath.row
        cell.dropdownBtn.addTarget(self, action: #selector(infoBtn(button:)), for: .touchUpInside)
        
        cell.dropdown.anchorView = cell.dropdownBtn
        cell.dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            
            if index == 0 {
                // Remove from Wishlist
                var id = 0
                if self.isAllMovies || action == .allMovies || action == .movieListing {
                    if let selected = self.allMovieList.filter({$0.isSelected}).first {
                        id = selected.movies![indexPath.row].id ?? 0
                        
                        if (selected.isFavorite ?? 0) == 1 {
                            let param = ["type"     : 1,
                                         "id"       : self.allMovieList[indexPath.row].id ?? 0,
                                         "status"   : 0]
                            self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                        } else {
                            let param = ["type"     : 1,
                                         "id"       : self.allMovieList[indexPath.row].id ?? 0,
                                         "status"   : 1]
                            self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                        }
                    }
                } else if action == .seriesListing || action == .allSeries  {
//                    id = self.selectedSeries!.content![indexPath.row].id ?? 0
                    id = self.seriesLists[indexPath.row].id ?? 0
                    
                    if (seriesLists[index].isFavorite ?? 0) == 1 {
                        let param = ["type"     : 2,
                                     "id"       : id,
                                     "status"   : 0]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    } else {
                        let param = ["type"     : 2,
                                     "id"       : id,
                                     "status"   : 1]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    }
                } else if self.action == .recentWatched {
                    id = self.selectedMovie!.content![indexPath.row].id ?? 0
                    let type = (selectedMovie!.content![indexPath.row].isMovie ) ? 1 : 2
                    
                    if (selectedMovie!.content![indexPath.row].isFavorite ?? 0) == 1 {
                        let param = ["type"     : type,
                                     "id"       : id,
                                     "status"   : 0]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    } else {
                        let param = ["type"     : type,
                                     "id"       : id,
                                     "status"   : 1]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    }
                } else {
                    id = self.selectedMovie!.content![indexPath.row].id ?? 0
                    
                    if (selectedMovie!.content![indexPath.row].isFavorite ?? 0) == 1 {
                        let param = ["type"     : 1,
                                     "id"       : id,
                                     "status"   : 0]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    } else {
                        let param = ["type"     : 1,
                                     "id"       : id,
                                     "status"   : 1]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    }
                }
            }
        }
        
        /*cell.dropdownBtn.closureDidSelectItem = { (item: ItemModel) in
            if item.index == 0 {
                // Add to Wishlist
                
                var id = 0
                if self.isAllMovies {
                    if let selected = self.allMovieList.filter({$0.isSelected}).first {
                        id = selected.movies![indexPath.row].id ?? 0
                    }
                } else if self.selectedSeries != nil {
                    id = self.selectedSeries!.content![indexPath.row].id ?? 0
                } else {
                    id = self.selectedMovie!.content![indexPath.row].id ?? 0
                }
                
                
                let param = ["type"     : 1,
                             "id"       : id,
                             "status"   : 1]
                self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                self.hideAllDropdownList()
            }
        }*/
        
        if isAllMovies || action == .allMovies || action == .movieListing {
            if let selected = allMovieList.filter({$0.isSelected}).first {
                cell.configure(content: selected.movies![indexPath.row])
            }
        } else if action == .seriesListing || action == .allSeries  {
            cell.configure(series: seriesLists[indexPath.row])
        } else {
            cell.configure(content: selectedMovie!.content![indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isAllMovies || action == .allMovies || action == .movieListing {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                if let selected = allMovieList.filter({$0.isSelected}).first {
                    vc.selectedMovie = selected.movies![indexPath.row]
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                    vc.selectedMovie = selectedMovie?.content?[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if action == .seriesListing || action == .allSeries {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
                vc.seriesId = self.seriesLists[indexPath.row].id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if action == .recentWatched {
            if selectedMovie?.content?[indexPath.row].isMovie ?? false {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                    vc.selectedMovie = selectedMovie?.content?[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
                    vc.seriesId = self.selectedMovie?.content?[indexPath.row].id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func infoBtn(button: UIButton) {
//        self.hideAllDropdownList()
        if let cell = self.tableVew.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? PopularTableCell {
//            cell.dropdownBtn.showSwitchList()
            
            if isAllMovies || action == .allMovies || action == .movieListing {
                if var selected = allMovieList.filter({$0.isSelected}).first {
//                    selected.movies![button.tag].isShown = true
                    cell.dropdown.dataSource = (selected.isFavorite ?? 0) == 1 ? ["Remove from wishlist"] : ["Add to wishlist"]
                }
            } else if action == .seriesListing || action == .allSeries {
//                selectedSeries!.content![button.tag].isShown = true
                cell.dropdown.dataSource = (seriesLists[button.tag].isFavorite ?? 0) == 1 ? ["Remove from wishlist"] : ["Add to wishlist"]
            } else {
//                selectedMovie!.content![button.tag].isShown = true
                cell.dropdown.dataSource = (selectedMovie!.content![button.tag].isFavorite ?? 0) == 1 ? ["Remove from wishlist"] : ["Add to wishlist"]
            }
            
            cell.dropdown.show()
        }
    }
    
    func hideAllDropdownList() {
        if isAllMovies || action == .allMovies || action == .movieListing {
            if var selected = allMovieList.filter({$0.isSelected}).first {
                for i in 0..<selected.movies!.count {
                    if selected.movies![i].isShown {
                        if let cell = self.tableVew.cellForRow(at: IndexPath(row: i, section: 0)) as? PopularTableCell {
                            cell.dropdownBtn.hideList()
                            selected.movies![i].isShown = false
                        }
                    }
                }
            }
        } else if action == .seriesListing || action == .allSeries {
            for i in 0..<selectedSeries!.content!.count {
                if selectedSeries!.content![i].isShown {
                    if let cell = self.tableVew.cellForRow(at: IndexPath(row: i, section: 0)) as? PopularTableCell {
                        cell.dropdownBtn.hideList()
                        selectedSeries!.content![i].isShown = false
                    }
                }
            }
        } else {
            for i in 0..<selectedMovie!.content!.count {
                if selectedMovie!.content![i].isShown {
                    if let cell = self.tableVew.cellForRow(at: IndexPath(row: i, section: 0)) as? PopularTableCell {
                        cell.dropdownBtn.hideList()
                        selectedMovie!.content![i].isShown = false
                    }
                }
            }
        }
    }
    
    @objc func tapCollection() {
        self.hideAllDropdownList()
    }
}

class PopularTableCell: UITableViewCell {
    @IBOutlet weak var movieImgView: AnimatableImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var dotsBtn: UIButton!
    @IBOutlet weak var dropdownBtn: DropDownButton! {
        didSet {
            self.perform(#selector(updateUIAfterDelay), with: nil, afterDelay: 1.0)
        }
    }
    var parentVC: UIViewController?
    let dropdown = DropDown()
    
    @objc private func updateUIAfterDelay() {
        dropdownBtn.parentVC = parentVC
        dropdownBtn.optionArray = ["Add to Wishlist"]
        dropdownBtn.trailingAnchorView = dropdownBtn
    }
    
    func configure(content: HomeContent.Content) {
        movieImgView.showImage(imgURL: content.videoImageThumb ?? "", isMode: true)
        nameLbl.text = content.videoTitle ?? ""
        yearLbl.text = "2017"
        ageLbl.text = content.adult ?? ""
        
        if (content.videoDescription ?? "") != "" {
            let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
            let textData = String(format: font, content.videoDescription ?? "").data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                self.detailLbl.attributedText = attText
            } catch {
                print(error)
            }
        } else {
            self.detailLbl.text = ""
        }
    }
    
    func configure(series: SeriesListModel.Content) {
        movieImgView.showImage(imgURL: series.seriesPoster ?? "", isMode: true)
        nameLbl.text = series.seriesName ?? ""
        yearLbl.text = "2017"
        
        if (series.seriesInfo ?? "") != "" {
            let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
            let textData = String(format: font, series.seriesInfo ?? "").data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                self.detailLbl.attributedText = attText
            } catch {
                print(error)
            }
        } else {
            self.detailLbl.text = ""
        }
    }
    
    func configure(series: SeriesDetailModel.Series) {
        movieImgView.showImage(imgURL: series.seriesPoster ?? "", isMode: true)
        nameLbl.text = series.seriesName ?? ""
        yearLbl.text = "2017"
        
        if (series.seriesInfo ?? "") != "" {
            let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
            let textData = String(format: font, series.seriesInfo ?? "").data(using: .utf8)
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                            NSAttributedString.DocumentType.html]
            do {
                let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
                self.detailLbl.attributedText = attText
            } catch {
                print(error)
            }
        } else {
            self.detailLbl.text = ""
        }
    }
}


// MARK:- API IMPLEMENTATIONS
extension PopularMoviesVC {
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
                let moviesModel = try JSONDecoder().decode(AllMovieModel.self, from: jsonData)
                if (moviesModel.success ?? false) {
                    switch api {
                    case .moviesByLanguages:
                        self.allMovieList = moviesModel.body ?? []
                        if self.allMovieList.count > 0 {
                            self.allMovieList[0].isSelected = true
                        }
                        self.categoryCollView.reloadData()
                        self.tableVew.reloadData()
                        
                    case .addToFavorite:
                        let favModel = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                        if let code = favModel["code"] as? Int {
                            let message = favModel["message"] as? String ?? ""
                            if code == 200 {
                                if self.isAllMovies {
                                    self.apiCalled(api: .moviesByLanguages(self.genreId), param: [:], method: .get)
                                }
                            } else {
                                self.view.makeToast(message)
                            }
                        }
                    case .allSeries:
                        let seriesModel = try JSONDecoder().decode(AllSeriesModel.self, from: jsonData)
                        if (seriesModel.success ?? false) {
                            self.seriesLists = seriesModel.body ?? []
                            self.tableVew.reloadData()
                        } else {
                            Alert.show(message: seriesModel.message ?? "")
                        }
                    case .allLanguages:
                        let langModel = try JSONDecoder().decode(LanguageListModel.self, from: jsonData)
                        if (langModel.success ?? false) {
                            self.languages = langModel.body ?? []
                            if self.languages.count > 0 {
                                self.languages[0].isSelected = true
                                
                                if self.isAllMovies {
                                    self.apiCalled(api: .moviesByLanguages(self.genreId), param: [:], method: .get)
                                } else if self.action == .allMovies || self.action == .movieListing {
                                    self.apiCalled(api: .moviesByLanguages(self.genreId), param: [:], method: .get)
                                } else {
                                    self.apiCalled(api: .allSeries(self.languages[0].id ?? 1, self.genreId), param: [:], method: .get)
                                }
                            }
                            self.categoryCollView.reloadData()
                        } else {
                            Alert.show(message: langModel.message ?? "")
                        }
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
