//
//  AllChannelsVC.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 14/03/22.
//

import UIKit
import IBAnimatable
import Alamofire
import Lottie

class AllChannelsVC: UIViewController {
    
    // MARK: OUTLETS
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedChannel : ChannelListModel.Body?
    

    // MARK: VIEW LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.text = selectedChannel?.categoryName
    }

    
    // MARK:- IBACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: COLLECTION VIEW DATA SOURCE DELEGATE METHODS
extension AllChannelsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedChannel?.channelList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelTableCell", for: indexPath) as! ChannelTableCell
        cell.channelImgView.showImage(imgURL: selectedChannel?.channelList?[indexPath.row].channelThumb ?? "")
        cell.nameLbl.text = selectedChannel?.channelList?[indexPath.row].channelName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.collectionView.frame.size.width - 62) / 4.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TVShowDetailVC") as? TVShowDetailVC {
            vc.channelDetail = selectedChannel?.channelList?[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



class ChannelTableCell: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var channelImgView: AnimatableImageView!
    
}


// MARK:- API IMPLEMENTATIONS
extension AllChannelsVC {
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
//                        self.channelList = channelModel.body ?? []
//                        if self.allMovieList.count > 0 {
//                            self.allMovieList[0].isSelected = true
//                        }
//                        self.categoryCollView.reloadData()
//                        self.tableVew.reloadData()
                        break
                        
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
