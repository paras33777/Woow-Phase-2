//
//  NSearchVC.swift
//  WooW
//
//  Created by Rahul Chopra on 22/11/21.
//

import UIKit
import Alamofire
import IBAnimatable
import DropDown
import Lottie

class NSearchVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var animationView:LottieAnimationView!
    var searchModel: SearchListModel?
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTxtField.attributedPlaceholder = NSAttributedString(string: "Type title, categories, years etc", attributes: [NSAttributedString.Key.foregroundColor: UIColor.rgb(red: 106, green: 108, blue: 110)])
        self.collectionView.isHidden = true
        self.apiCalled(api: .search("a"), param: [:], method: .get)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextField.textDidChangeNotification, object: searchTxtField)
        
//        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapCollection))
//        tap.numberOfTapsRequired = 1
//        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCalled(api: .search(searchTxtField.text! == "" ? "a" : searchTxtField.text!), param: [:], method: .get)
    }
    
    // MARK: - CORE METHODS
    @objc func textDidChange(notification: NSNotification) {
        if let txtField = notification.object as? UITextField {
            if txtField == searchTxtField {
                self.apiCalled(api: .search(txtField.text!), param: [:], method: .get)
                
                self.hideAllDropdownList()
                if txtField.text! == "" {
                    collectionView.isHidden = true
//                    tableView.isHidden = false
                } else {
                    collectionView.isHidden = false
//                    tableView.isHidden = true
                }
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: - TABLE DATA SOURCE METHODS
extension NSearchVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let contianerView = UIView()
        
        let label = UILabel()
        if searchTxtField.text! == "" {
            label.text = "Popular Search"
        } else {
            label.text = "Result for '\(searchTxtField.text!)'"
        }
        
        label.font = UIFont(name: "Poppins-Regular", size: 17.0)
        label.textColor = UIColor.white
        contianerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contianerView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: contianerView.trailingAnchor, constant: -16.0),
            label.centerYAnchor.constraint(equalTo: contianerView.centerYAnchor, constant: 7.0),
        ])
        
        return contianerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchModel?.body?.movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NSearchTableCell", for: indexPath) as! NSearchTableCell
        cell.parentVC = self
        cell.dropdownBtn.tag = indexPath.row
        cell.dropDown.anchorView = cell.dropdownBtn
        if (self.searchModel?.body?.movies[indexPath.row].isFavorite ?? 0) == 1 {
            cell.dropDown.dataSource = ["Remove from wishlist"]
        } else {
            cell.dropDown.dataSource = ["Add to wishlist"]
        }
        
        cell.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0 {
                if (self.searchModel?.body?.movies[indexPath.row].isFavorite ?? 0) == 1 {
                    // Remove from Wishlist
                    let param = ["type"     : 1,
                                 "id"       : self.searchModel?.body?.movies[indexPath.row].id ?? 0,
                                 "status"   : 0]
                    self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                } else {
                    // Add to Wishlist
                    let param = ["type"     : 1,
                                 "id"       : self.searchModel?.body?.movies[indexPath.row].id ?? 0,
                                 "status"   : 1]
                    self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                }
            }
        }
        cell.dropdownBtn.addTarget(self, action: #selector(infoBtn(button:)), for: .touchUpInside)
        cell.configure(movie: searchModel!.body!.movies[indexPath.row])
        /*cell.dropdownBtn.closureDidSelectItem = { (item: ItemModel) in
            if item.index == 0 {
                if (self.searchModel?.body?.movies[indexPath.row].isFavorite ?? 0) == 1 {
                    // Add to Wishlist
                    let param = ["type"     : 1,
                                 "id"       : self.searchModel?.body?.movies[indexPath.row].id ?? 0,
                                 "status"   : 0]
                    self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                } else {
                    // Add to Wishlist
                    let param = ["type"     : 1,
                                 "id"       : self.searchModel?.body?.movies[indexPath.row].id ?? 0,
                                 "status"   : 1]
                    self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                }
            }
        }*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
            vc.movieDetail = searchModel!.body!.movies[indexPath.row]
            vc.selectedMovieId = searchModel?.body?.movies[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    @objc func infoBtn(button: UIButton) {
        /*self.hideAllDropdownList()
        if let cell = self.tableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? NSearchTableCell {
            cell.dropdownBtn.showSwitchList()
            searchModel?.body?.movies[button.tag].isShown = true
        }*/
        
        
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? NSearchTableCell {
            
            if (self.searchModel?.body?.movies[button.tag].isFavorite ?? 0) == 1 {
                print("Remove from wishlist")
                cell.dropDown.dataSource = ["Remove from wishlist"]
            } else {
                print("Add to wishlist")
                cell.dropDown.dataSource = ["Add to wishlist"]
            }
            
            cell.dropDown.show()
        }
    }
    
    func hideAllDropdownList() {
        for i in 0..<searchModel!.body!.movies.count {
            if searchModel!.body!.movies[i].isShown {
                if let cell = self.tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? NSearchTableCell {
                    cell.dropdownBtn.hideList()
                    searchModel?.body?.movies[i].isShown = false
                }
            }
        }
    }
    
    @objc func tapCollection() {
        self.hideAllDropdownList()
    }
}

// MARK: - TABLE DATA SOURCE METHODS
extension NSearchVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (searchModel?.body?.movies.count ?? 0) + (searchModel?.body?.series.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVShowLargeCollectionCell", for: indexPath) as! TVShowLargeCollectionCell
        
        if (searchModel?.body?.movies.count ?? 0) > 0  && (searchModel?.body?.movies.count ?? 0) > indexPath.row {
            cell.channelImgView.showImage(imgURL: searchModel!.body!.movies[indexPath.row].videoImage ?? "")
            cell.dropdownView.isHidden = !searchModel!.body!.movies[indexPath.row].isShown
//            cell.premiumLbl.text = searchModel!.body!.movies[indexPath.row].type ?? "Free"
            if searchModel!.body!.movies[indexPath.row].access_message  == nil || searchModel!.body!.movies[indexPath.row].access_message == ""{
                cell.premiumLbl.text = (searchModel!.body!.movies[indexPath.row].type ?? "") != "" ? searchModel!.body!.movies[indexPath.row].type! : "Free"

            }else{
                cell.premiumLbl.text = (searchModel!.body!.movies[indexPath.row].access_message ?? "") //(content.access_message ?? "") != "" ? content.access_message! : "Free"

            }
            if (searchModel!.body!.movies[indexPath.row].isFavorite ?? 0) == 1 {
                cell.dropdown.dataSource = ["Remove from wishlist"]
            } else {
                cell.dropdown.dataSource = ["Add to wishlist"]
            }
            
            cell.dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                if index == 0 {
                    if (self.searchModel?.body?.movies[indexPath.row].isFavorite ?? 0) == 1 {
                        // Remove from Wishlist
                        let param = ["type"     : 1,
                                     "id"       : self.searchModel?.body?.movies[indexPath.row].id ?? 0,
                                     "status"   : 0]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    } else {
                        // Add to Wishlist
                        let param = ["type"     : 1,
                                     "id"       : self.searchModel?.body?.movies[indexPath.row].id ?? 0,
                                     "status"   : 1]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    }
                }
            }
        } else if (searchModel?.body?.series.count ?? 0) > 0 {
            let movieCount = (searchModel?.body?.movies.count ?? 0)
            cell.channelImgView.showImage(imgURL: searchModel!.body!.series[indexPath.row - movieCount].seriesPoster )
            cell.dropdownView.isHidden = !searchModel!.body!.series[indexPath.row - movieCount].isShown
            cell.premiumLbl.text = searchModel!.body!.series[indexPath.row - movieCount].type ?? "Free"
            if searchModel!.body!.series[indexPath.row - movieCount].access_message  == nil || searchModel!.body!.series[indexPath.row - movieCount].access_message == ""{
                cell.premiumLbl.text = (searchModel!.body!.series[indexPath.row - movieCount].type ?? "") != "" ? searchModel!.body!.series[indexPath.row - movieCount].type! : "Free"

            }else{
                cell.premiumLbl.text = (searchModel!.body!.series[indexPath.row - movieCount].access_message ?? "") //(content.access_message ?? "") != "" ? content.access_message! : "Free"

            }
            if (searchModel!.body!.series[indexPath.row - movieCount].isFavorite ?? 0) == 1 {
                cell.dropdown.dataSource = ["Remove from wishlist"]
            } else {
                cell.dropdown.dataSource = ["Add to wishlist"]
            }
            
            cell.dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
                if index == 0 {
                    if (searchModel!.body!.series[index - movieCount].isFavorite ?? 0) == 1 {
                        // Remove from Wishlist
                        let param = ["type"     : 2,
                                     "id"       : self.searchModel?.body?.series[indexPath.row - movieCount].id ?? 0,
                                     "status"   : 0]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    } else {
                        // Add to Wishlist
                        let param = ["type"     : 2,
                                     "id"       : self.searchModel?.body?.series[indexPath.row - movieCount].id ?? 0,
                                     "status"   : 1]
                        self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                    }
                }
            }
        }
        
        cell.dropdownBtn.tag = indexPath.row
        cell.dropdownBtn.addTarget(self, action: #selector(hideUnhideDropdownView(btn:)), for: .touchUpInside)
        
        cell.addWishlistBtn.tag = indexPath.row
        cell.addWishlistBtn.addTarget(self, action: #selector(addWishlist(btn:)), for: .touchUpInside)
        
        cell.dropdown.anchorView = cell.dropdownBtn
        
        return cell
    }
    
    @objc func addWishlist(btn: UIButton) {
        // Add to Wishlist
        
        
        
        if (searchModel?.body?.movies.count ?? 0) > 0  && (searchModel?.body?.movies.count ?? 0) > btn.tag {
            
            let param = ["type"     : 1,
                         "id"       : self.searchModel?.body?.movies[btn.tag].id ?? 0,
                         "status"   : 1]
            self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
        } else {
            let movieCount = (searchModel?.body?.movies.count ?? 0)
            let param = ["type"     : 1,
                         "id"       : self.searchModel?.body?.movies[btn.tag - movieCount].id ?? 0,
                         "status"   : 1]
            self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
        }
        
        self.apiCalled(api: .search(searchTxtField.text!), param: [:], method: .get)
    }
    
    @objc func hideUnhideDropdownView(btn: UIButton) {
        let a = (searchModel?.body?.movies.count ?? 0) + (searchModel?.body?.series.count ?? 0)
        let movieCount = (searchModel?.body?.movies.count ?? 0)
        for each in 0..<a {
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: each, section: 0)) as? TVShowLargeCollectionCell {
                cell.dropdownView.isHidden = true
                if (searchModel?.body?.movies.count ?? 0) > 0  && (searchModel?.body?.movies.count ?? 0) > each {
                    searchModel!.body!.movies[each].isShown = false
                } else {
                    searchModel!.body!.series[each - movieCount].isShown = false
                }
            }
        }
        
        if let cell = self.collectionView.cellForItem(at: IndexPath(row: btn.tag, section: 0)) as? TVShowLargeCollectionCell {
            if (searchModel?.body?.movies.count ?? 0) > 0  && (searchModel?.body?.movies.count ?? 0) > btn.tag {
                searchModel!.body!.movies[btn.tag].isShown = !searchModel!.body!.movies[btn.tag].isShown
                
                cell.dropdownView.isHidden = !searchModel!.body!.movies[btn.tag].isShown
            } else {
                searchModel!.body!.series[btn.tag - movieCount].isShown = !searchModel!.body!.series[btn.tag - movieCount].isShown
                cell.dropdownView.isHidden = !searchModel!.body!.series[btn.tag - movieCount].isShown
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width - 45) / 3
        return CGSize(width: width, height: width * 9 / 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (searchModel?.body?.movies.count ?? 0) > 0  && (searchModel?.body?.movies.count ?? 0) > indexPath.row {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                vc.movieDetail = searchModel!.body!.movies[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if (searchModel?.body?.series.count ?? 0) > 0 {
            // SERIES
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
                let moviesCOunt = searchModel?.body?.movies.count ?? 0
                vc.seriesId = searchModel?.body?.series[indexPath.row - moviesCOunt].id ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}


class NSearchTableCell: UITableViewCell {
    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var premiumLbl: UILabel!
    @IBOutlet weak var movieImgView: AnimatableImageView!
    @IBOutlet weak var categoryAgeLbl: UILabel!
    @IBOutlet weak var myListDropdownBtn: UIButton!
    @IBOutlet weak var dropdownBtn: DropDownButton! {
        didSet {
            self.perform(#selector(updateUIAfterDelay), with: nil, afterDelay: 1.0)
        }
    }
    var parentVC: UIViewController?
    var movie: MovieDetailModel.Body?
    
    let dropDown = DropDown()
    
    
    @objc private func updateUIAfterDelay() {
        dropdownBtn.parentVC = parentVC
//        dropdownBtn.optionArray = ["Add to Wishlist"]
        dropdownBtn.optionArray = (movie?.isFavorite ?? 0) == 1 ? ["Remove Wishlist"] : ["Add to Wishlist"]
        dropdownBtn.trailingAnchorView = dropdownBtn
    }
    
    func configure(movie: MovieDetailModel.Body) {
        self.movie = movie
        movieImgView.showImage(imgURL: movie.videoImage ?? "", isMode: true)
        movieNameLbl.text = movie.videoTitle
//        yearLbl.text = "\(movie.releaseDate ?? 0)"
        categoryAgeLbl.text = (movie.adult ?? "") == "1" ? "18+" : "12+"
        premiumLbl.text = (movie.type ?? "") == "" ? "Free" : movie.type!
        
        if (movie.access_message ?? "")  == nil || (movie.access_message ?? "") == ""{
            premiumLbl.text = (movie.type ?? "") != "" ? (movie.type ?? "") : "Free"

        }else{
            premiumLbl.text = (movie.access_message ?? "") //(content.access_message ?? "") != "" ? content.access_message! : "Free"

        }
        let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
        let textData = String(format: font, movie.videoDescription ?? "").data(using: .utf8)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html]
        do {
            let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
            self.yearLbl.attributedText = attText
        } catch {
            print(error)
        }
    }
    
    func configure(favorite: FavoriteModel) {
        movieImgView.showImage(imgURL: favorite.image ?? "", isMode: true)
        movieNameLbl.text = favorite.name
        categoryAgeLbl.text = "18+"
        
        let font = "<font face='SFProText-Regular' size='4.8' color= 'darkGray'>%@"
        let textData = String(format: font, favorite.bodyDescription ?? "").data(using: .utf8)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                        NSAttributedString.DocumentType.html]
        do {
            let attText = try NSMutableAttributedString(data: textData!, options: options, documentAttributes: nil)
            yearLbl.attributedText = attText
        } catch {
            print(error)
        }
    }
}



// MARK: - API IMPLEMENTATIONS
extension NSearchVC {
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
                case .search:
                    let searchListModel = try JSONDecoder().decode(SearchListModel.self, from: jsonData)
                    if (searchListModel.success ?? false) {
                        self.searchModel = searchListModel
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    } else {
                        Alert.show(message: searchListModel.message ?? "")
                    }
                    
                case .addToFavorite:
                    self.hideAllDropdownList()
                    let favModel = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                    if let code = favModel["code"] as? Int {
                        let message = favModel["message"] as? String ?? ""
                        if code == 200 {
                            self.view.makeToast(message)
                        } else {
                            self.view.makeToast(message)
                        }
                    }
                    
                default: break
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
