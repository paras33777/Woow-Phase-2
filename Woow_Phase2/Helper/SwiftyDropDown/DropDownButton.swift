//
//  DropDownButton.swift
//  DropdownButton
//
//  Created by appsdeveloper Developer on 15/10/21.
//

import Foundation
import UIKit

typealias ItemModel = (index: Int, itemName: String)

class DropDownButton: UIButton {
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.isHidden = true
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1.0).cgColor
        containerView.clipsToBounds = true
        return containerView
    }()
    @IBInspectable var width: CGFloat = 0.0 {
        didSet {
            if width == 0.0 {
                containerView.frame.size = CGSize(width: width, height: 100)
            } else {
                //                containerView.frame.size = frameSize
                containerView.frame.size = CGSize(width: width, height: 100)
            }
        }
    }
    @IBInspectable var frameOrigin: CGPoint = .zero {
        didSet {
            if frameOrigin == .zero {
                containerView.frame.origin = CGPoint(x: self.frame.origin.x, y: (self.frame.size.height + self.frame.origin.y))
            } else {
                //                containerView.frame.origin = frameOrigin
                containerView.frame.origin = CGPoint(x: frameOrigin.x, y: (frameOrigin.y))
            }
        }
    }
    @IBInspectable var fontStyle: UIFont = .systemFont(ofSize: 15.0) {
        didSet {
            self.tableView.reloadData()
        }
    }
    @IBInspectable var textColor: UIColor = .black {
        didSet {
            self.tableView.reloadData()
        }
    }
    @IBInspectable var rowHeight: CGFloat = 40.0 {
        didSet {
            self.containerView.frame.size.height = CGFloat(optionArray.count) * rowHeight
        }
    }
    @IBInspectable var bgColor: UIColor = .white {
        didSet {
            containerView.backgroundColor = bgColor
        }
    }
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DropDownTableCell.self, forCellReuseIdentifier: "DropDownCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            containerView.layer.cornerRadius = cornerRadius
        }
    }
    var parentVC: Any? {
        didSet {
            if parentVC != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.setupUI()
                }
            }
        }
    }
    
    @IBInspectable var names: String = "Edit,Remove" {
        didSet {
            optionArray = names.components(separatedBy: "")
        }
    }
    @IBInspectable var images: String = "edit_icon,trash_icon" {
        didSet {
            optionImages = images.components(separatedBy: "")
        }
    }
    var optionArray: [String] = ["Edit", "Remove"] {
        didSet {
            setupUI()
            // self.containerView.frame.size.height = CGFloat(optionArray.count) * rowHeight
            // self.tableView.reloadData()
        }
    }
    var optionImages: [String] = ["edit_icon", "trash_icon"] {
        didSet {
            setupUI()
            // self.containerView.frame.size.height = CGFloat(optionArray.count) * rowHeight
            // self.tableView.reloadData()
        }
    }
    var trailingAnchorView: UIView? {
        didSet {
            self.setupTrailingConstraints()
        }
    }
    var closureDidSelectItem: ((ItemModel) -> ())?
    
    
    // MARK:- LIFE CYCLE METHODS
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    
    // MARK:- CORE METHODS
    private func setupUI() {
        //        optionArray = optionArray.count == 0 ? ["Edit", "Remove"] : ["Clear Chat"]
        //        optionImages = optionArray.count == 0 ? ["edit_icon", "trash_icon"] : ["delete"]
        
        if let parVC = parentVC as? UIViewController {
            parVC.view.addSubview(containerView)
        } else if let parCollcell = parentVC as? UICollectionViewCell {
            parCollcell.addSubview(containerView)
        }
        
        containerView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func showSwitchList() {
        if trailingAnchorView != nil {
            self.setupTrailingConstraints()
        } else if frameOrigin == .zero {
            frameOrigin = self.frame.origin
            self.containerView.frame.size.height = CGFloat(optionArray.count) * rowHeight
        }
        self.tableView.reloadData()
        containerView.isHidden = !containerView.isHidden
    }
    
    func setupTrailingConstraints() {
        if trailingAnchorView != nil {
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.trailingAnchor.constraint(equalTo: trailingAnchorView!.leadingAnchor, constant: 18).isActive = true
            containerView.heightAnchor.constraint(equalToConstant: CGFloat(optionArray.count) * rowHeight).isActive = true
            containerView.topAnchor.constraint(equalTo: trailingAnchorView!.bottomAnchor, constant: -8).isActive = true
            containerView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func showList() {
        containerView.isHidden = false
    }
    func hideList() {
        containerView.isHidden = true
    }
    
}



// MARK:- TABLE VIEW DATA SOURCE & DELEGATE METHODS
extension DropDownButton : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! DropDownTableCell
        cell.selectionStyle = .none
        cell.configure(name: optionArray[indexPath.row], iamge: optionImages[indexPath.row], font: fontStyle, textColor: textColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.closureDidSelectItem != nil {
            self.closureDidSelectItem!((index: indexPath.row, itemName: optionArray[indexPath.row]))
        }
    }
}
