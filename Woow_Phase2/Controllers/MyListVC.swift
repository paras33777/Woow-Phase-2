//
//  MyListVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 13/12/21.
//

import UIKit
import Alamofire
import DropDown
import Lottie

class MyListVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet var headingBtns: [UIButton]!
    @IBOutlet var lineLbls: [UILabel]!
    @IBOutlet weak var downloadView: UIView!
    @IBOutlet weak var downloadTblView: UITableView!
    @IBOutlet weak var myListView: UIView!
    @IBOutlet weak var myListTableView: UITableView!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var animationView:LottieAnimationView!
    var favorites = [FavoriteModel]()
    
    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = UIButton()
        btn.tag = 0
        self.actionHeadingBtn(btn)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCalled(api: .favoriteList, param: [:], method: .get)
    }
    
    
    // MARK: - IBACTIONS
    @IBAction func actionHeadingBtn(_ sender: UIButton) {
        lineLbls.forEach({$0.isHidden = true})
        lineLbls[sender.tag].isHidden = false
        headingBtns.forEach({$0.setTitleColor(.white, for: .normal)})
        headingBtns[sender.tag].setTitleColor(UIColor(named: "Color2"), for: .normal)
        
        downloadView.isHidden = sender.tag == 0
        myListView.isHidden = sender.tag == 1
    }
}



// MARK: - TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension MyListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == downloadTblView ? 0 : favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == downloadTblView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadTableCell", for: indexPath) as! NSearchTableCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableCell", for: indexPath) as! NSearchTableCell
            cell.configure(favorite: favorites[indexPath.row])
            
            cell.myListDropdownBtn.tag = indexPath.row
            cell.myListDropdownBtn.addTarget(self, action: #selector(infoBtn(button:)), for: .touchUpInside)
            
            cell.dropDown.anchorView = cell.myListDropdownBtn
            cell.dropDown.dataSource = ["Remove from wishlist"]
            cell.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                print("Selected item: \(item) at index: \(index)")
                
                if index == 0 {
                    // Remove from Wishlist
                    var type = 1
                    if (self.favorites[indexPath.row].type ?? "").lowercased() == "series" || (self.favorites[indexPath.row].type ?? "").lowercased() == "episode" || (self.favorites[indexPath.row].type ?? "").lowercased() == "episodes" {
                        type = 2
                    }
                    
                    let param = ["type"     : type,
                                 "id"       : self.favorites[indexPath.row].id ?? 0,
                                 "status"   : 0]
                    self.apiCalled(api: .addToFavorite, param: param, method: .post, isEncoding: true)
                }
            }
            return cell
        }
    }
    
    @objc func infoBtn(button: UIButton) {
        if let cell = self.myListTableView.cellForRow(at: IndexPath(row: button.tag, section: 0)) as? NSearchTableCell {
            cell.dropDown.show()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == myListTableView {
            let selected = favorites[indexPath.row]
            
            if (selected.type ?? "").lowercased() == "movie" {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailVC") as? MovieDetailVC {
                    vc.selectedMovieId = selected.id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else if (selected.type ?? "").lowercased() == "series" || (selected.type ?? "").lowercased() == "episode" {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
                    vc.seriesId = selected.id ?? 0
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}


// MARK: - COLLECTION VIEW DATA SOURCE & DELEGATE METHODS
extension MyListVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyListRecommendCell", for: indexPath) as! MyListRecommendCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height)
    }
}


class MyListRecommendCell: UICollectionViewCell {
    @IBOutlet weak var imgView: RoundImageView!
    
}



// MARK: - API IMPLEMENTATIONS
extension MyListVC {
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
                case .favoriteList:
                    let favModel = try JSONDecoder().decode(FavoriteListModel.self, from: jsonData)
                    if (favModel.success ?? false) {
                        self.favorites = favModel.body ?? []
                        self.myListTableView.reloadData()
                    } else {
                        Alert.show(message: favModel.message ?? "")
                    }
                case .addToFavorite:
                    let favModel = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
                    if let code = favModel["code"] as? Int {
                        let message = favModel["message"] as? String ?? ""
                        if code == 200 {
                            self.apiCalled(api: .favoriteList, param: [:], method: .get)
                        } else {
                            self.view.makeToast(message)
                        }
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
