//
//  NHomeCatCollCell.swift
//  WooW
//
//  Created by Rahul Chopra on 05/12/21.
//

import Foundation
import UIKit

struct DummyHomeCatModel {
    let name: String
    var isSelected: Bool = false
    
    static func data() -> [DummyHomeCatModel] {
        var dd = [DummyHomeCatModel]()
        dd.append(DummyHomeCatModel(name: "Home", isSelected: true))
        dd.append(DummyHomeCatModel(name: "Movies"))
        dd.append(DummyHomeCatModel(name: "Series"))
        dd.append(DummyHomeCatModel(name: "TV Channels"))
        return dd
    }
}


extension NHomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NHomeCatCollCell", for: indexPath) as! NHomeCatCollCell
        cell.configure(data: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<data.count {
            data[i].isSelected = false
        }
        data[indexPath.row].isSelected = true
        self.catCollectionView.reloadData()
        
        if indexPath.row == 2 {
            self.selectedTab = .Series
            vcs[2].add(self, containerView: containerView)
            if let homeSeriesVC = vcs[2] as? HomeSeriesVC {
                homeSeriesVC.isRefresh = true
            }
        } else if indexPath.row == 1 {
            self.selectedTab = .Movies
            vcs[1].add(self, containerView: containerView)
            if let homeMovieVC = vcs[1] as? HomeMoviesVC {
                homeMovieVC.isRefresh = true
            }
        } else if indexPath.row == 0 {
            self.selectedTab = .Home
            vcs[0].add(self, containerView: containerView)
            self.apiCalled(api: .home, param: [:], method: .get)
        } else if indexPath.row == 3 {
            self.selectedTab = .TVShows
            vcs[3].add(self, containerView: containerView)
        }
        
        if indexPath.row != 0 {
            if let homeDetailVC = vcs[0] as? HomeDetailVC {
                if banners.count > 0 {
                    homeDetailVC.pauseOtherTrailers()
                }
            }
        } else {
            if let homeDetailVC = vcs[0] as? HomeDetailVC {
                if banners.count > 0 {
                    banners[0].isPlayed = true
                    if let cell = homeDetailVC.playerView.cellForItem(at: 0) as? PagerViewCell {
                        homeDetailVC.playBannerVideo(index: 0, cellView: cell.videoView)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let font = UIFont(name: "SFProText-Regular", size: 18) {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let myText = data[indexPath.row].name
            let size = (myText as NSString).size(withAttributes: fontAttributes)
//            return CGSize(width: size.width, height: 40)
            return CGSize(width: collectionView.frame.size.width * 0.27, height: 40)
        }
        return .zero
    }
    
}


class NHomeCatCollCell: UICollectionViewCell {
    @IBOutlet weak var catLbl: UILabel!
    @IBOutlet weak var lineLbl: UILabel!
    
    func configure(data: DummyHomeCatModel) {
        catLbl.text = data.name
        lineLbl.isHidden = !data.isSelected
        catLbl.textColor = data.isSelected ? UIColor(named: "Color2") : .white
    }
}


