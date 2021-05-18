//
//  AddEditTableViewCell.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-18.
//

import UIKit

class AddEditTableViewCell: BaseTableViewCell<AddEditCellSetting> {
    override var settingModel: AddEditCellSetting? {
        didSet {
            guard let settingModel = self.settingModel else { return }
            switch settingModel.type {
            case .title:
                self.titleTextField = UITextField()
                self.titleTextField?.translatesAutoresizingMaskIntoConstraints = false
                self.titleTextField?.text = settingModel.value
                self.titleTextField?.layer.borderWidth = 1
                self.titleTextField?.borderStyle = .roundedRect
                self.titleTextField?.clipsToBounds = true
                self.contentView.addSubview(self.titleTextField!)
            case .description:
                self.descriptionTextView = UITextView()
                self.descriptionTextView?.translatesAutoresizingMaskIntoConstraints = false
                self.descriptionTextView?.contentInsetAdjustmentBehavior = .automatic
                self.descriptionTextView?.textAlignment = .justified
                self.descriptionTextView?.text = settingModel.value
                self.contentView.addSubview(self.descriptionTextView!)
            case .priority:
                self.prioritySegment = UISegmentedControl(items: ["High", "Medium", "Low"])
                self.prioritySegment?.translatesAutoresizingMaskIntoConstraints = false
                self.prioritySegment?.selectedSegmentIndex = 1
                self.contentView.addSubview(self.prioritySegment!)
            }
            
            layoutUI()
        }
    }
    
    var titleTextField: UITextField?
    var descriptionTextView: UITextView?
    var prioritySegment: UISegmentedControl?
    
    override func layoutUI() {
        if let titleTF = self.titleTextField {
            titleTF.fillSuperView(padding: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
        }
        
        if let descriptonTV = self.descriptionTextView {
            descriptonTV.fillSuperView(padding: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
        }
        
        if let segment = self.prioritySegment {
            segment.fillSuperView(padding: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
        }
    }
}

struct AddEditCellSetting {
    var value: String?
    var intValue: Int?
    var type: AddEditTableViewCellType
}

enum AddEditTableViewCellType {
    case title
    case description
    case priority
}
