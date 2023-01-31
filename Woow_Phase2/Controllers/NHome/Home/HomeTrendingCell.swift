//
//  HomeTrendingCell.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 16/02/22.
//

import Foundation
import UIKit


class HomeTrendingTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    weak var homeDetailVC: HomeDetailVC?
    var homeList: HomeContent? {
        didSet {
            if collectionView != nil {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}


extension HomeTrendingTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeList?.content?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeTrendingCollCell", for: indexPath) as! HomeTrendingCollCell
        cell.configure(content: homeList!.content![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 290, height: collectionView.frame.size.height)
//        return CGSize(width: 140, height: collectionView.frame.size.height)
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = homeDetailVC?.storyboard?.instantiateViewController(withIdentifier: "SeriesDetailVC") as? SeriesDetailVC {
            vc.selectedSeries = homeList?.content?[indexPath.row]
            homeDetailVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class HomeTrendingCollCell: UICollectionViewCell {
    @IBOutlet weak var premiumLbl: UILabel!
    @IBOutlet weak var seriesImgView: RoundImageView!
    func configure(content: HomeContent.Content) {
        seriesImgView.showImage(imgURL: content.seriesPoster ?? "")
        seriesImgView.contentMode = .scaleToFill
        if content.access_message == nil || content.access_message == ""{
            premiumLbl.text = (content.type ?? "") != "" ? content.type! : "Free"

        }else{
            premiumLbl.text = (content.access_message ?? "") //(content.access_message ?? "") != "" ? content.access_message! : "Free"

        }
    }
}
