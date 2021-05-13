//
//  ListTableViewCell.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-17.
//

import Foundation
import UIKit

class ListTableViewCell: BaseTableViewCell<Todo> {
    override var settingModel: Todo? {
        didSet {
            guard let setting = self.settingModel else { return }
            self.titleLabel.text = setting.title
            self.titleLabel.textColor = setting.isDone ? .lightGray : .black
//            self.descriptionLabel.text = setting.description
//            self.descriptionLabel.textColor = setting.isDone ? .lightGray : .black
            self.checkMarkLabel.frame.origin = CGPoint(x: 8, y: self.contentView.frame.height/2 - 18)
            self.checkMarkLabel.frame.size.width = setting.isDone ? 36 : 0
            self.checkMarkLabel.text = setting.isDone ? "✓" : ""
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .left
        return label
    }()
    
//    let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        return label
//    }()
    
    let checkMarkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    override func layoutUI() {
//        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.descriptionLabel])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.distribution = .fill
//        stackView.spacing = 8
        
//        self.contentView.addSubview(stackView)
        self.contentView.addSubview(self.checkMarkLabel)
        self.contentView.addSubview(self.titleLabel)
        
        
        self.checkMarkLabel.frame = CGRect(origin: .zero, size: CGSize(width: 0, height: 36))
        self.titleLabel.leadingAnchor.constraint(equalTo: self.checkMarkLabel.trailingAnchor, constant: 8).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        
//        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: self.checkMarkLabel.trailingAnchor, constant: 8).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
    }
}
