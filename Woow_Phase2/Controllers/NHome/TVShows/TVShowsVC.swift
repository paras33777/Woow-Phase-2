//
//  TVShowsVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 15/03/22.
//

import UIKit
import Alamofire
import DropDown
import Lottie

enum PlayerType {
    case movie
    case channel
    case series
}

class TVShowsVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var animationView: LottieAnimationView!
    var channelList = [ChannelListModel.Body]()

    
    // MARK: - VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCalled(api: .channels, param: [:], method: .get)
    }

    
    // MARK: - IBACTIONS
    
}


// MARK: - API IMPLEMENTATIONS
extension TVShowsVC {
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
            
            do {
                let channelModel = try JSONDecoder().decode(ChannelListModel.self, from: jsonData)
                if (channelModel.success ?? false) {
                    switch api {
                    case .channels:
                        self.channelList = channelModel.body ?? []
                        self.tableView.reloadData()
                        
                    default:
                        break
                    }
                } else {
                    Alert.show(message: channelModel.message ?? "")
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



// MARK: - TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension TVShowsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return channelList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView()
        
        let label = UILabel()
//        label.font = AppFonts.SFProTextBold.withSize(16.0)
        label.text = channelList[section].categoryName
        label.textColor = .white
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let viewMoreBtn = UIButton()
        viewMoreBtn.setTitle("View More", for: .normal)
//        viewMoreBtn.titleLabel?.font = AppFonts.SFProTextRegular.withSize(13.0)
        viewMoreBtn.setTitleColor(UIColor(white: 1.0, alpha: 0.4), for: .normal)
        containerView.addSubview(viewMoreBtn)
        viewMoreBtn.translatesAutoresizingMaskIntoConstraints = false
        viewMoreBtn.tag = section
        viewMoreBtn.addTarget(self, action: #selector(viewMoreAction(btn:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: viewMoreBtn.leadingAnchor, constant: 10.0),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            viewMoreBtn.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            viewMoreBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0)
        ])
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowTableCell", for: indexPath) as! TVShowTableCell
        cell.tvShowVC = self
        cell.channel = channelList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    @objc func viewMoreAction(btn: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllChannelsVC") as? AllChannelsVC {
            vc.selectedChannel = channelList[btn.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class TVShowTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView   : UICollectionView!
    weak var tvShowVC                   : TVShowsVC?
    var channel: ChannelListModel.Body? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channel?.channelList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*if (channel?.id ?? 0) == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelTableCell", for: indexPath) as! ChannelTableCell
            cell.channelImgView.showImage(imgURL: channel?.channelList?[indexPath.row].channelThumb ?? "")
            cell.nameLbl.text = channel?.channelList?[indexPath.row].channelName
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVShowLargeCollectionCell", for: indexPath) as! TVShowLargeCollectionCell
            cell.channelImgView.showImage(imgURL: channel?.channelList?[indexPath.row].channelThumb ?? "")
            return cell
        }*/
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelTableCell", for: indexPath) as! ChannelTableCell
        cell.channelImgView.showImage(imgURL: channel?.channelList?[indexPath.row].channelThumb ?? "")
        cell.nameLbl.text = channel?.channelList?[indexPath.row].channelName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if (channel?.channelList?[indexPath.row].id ?? 0) == 2 {
//            return CGSize(width: 100, height: 100)
//        } else {
//            return CGSize(width: 100, height: 150)
//        }
        return CGSize(width: 120, height: 115)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = tvShowVC?.storyboard?.instantiateViewController(withIdentifier: "TVShowDetailVC") as? TVShowDetailVC {
            vc.channelDetail = channel?.channelList?[indexPath.row]
            tvShowVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



class TVShowLargeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var premiumLbl: UILabel!
    @IBOutlet weak var dropdownBtn: UIButton!
    @IBOutlet weak var dropdownView: RoundView!
    @IBOutlet weak var addWishlistBtn: UIButton!
    @IBOutlet weak var channelImgView: UIImageView!
    var parentVC: UIViewController?
    let dropdown = DropDown()
}
