//
//  DropDownTableCell.swift
//  DropdownButton
//
//  Created by appsdeveloper Developer on 15/10/21.
//

import Foundation
import UIKit

class DropDownTableCell: UITableViewCell {
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    func setupUI() {
//        self.addSubview(imgView)
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
//            imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
//            imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            imgView.heightAnchor.constraint(equalToConstant: 18.0),
//            imgView.widthAnchor.constraint(equalToConstant: 18.0),
            
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15.0),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10.0),
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configure(name: String, iamge: String, font: UIFont, textColor: UIColor) {
        self.label.text = name
//        self.imgView.image = UIImage(named: iamge)
        self.label.font = font
        self.label.textColor = textColor
    }
}
