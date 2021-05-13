//
//  BaseTableViewCell.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-12.
//

import UIKit

/// basic blue print of the cell
/// T: the setting models which will be decleared under each cell
class BaseTableViewCell<T>: UITableViewCell {
    var settingModel: T?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        fatalError("Must Override")
    }
}
