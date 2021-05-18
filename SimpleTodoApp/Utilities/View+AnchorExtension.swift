//
//  View+AnchorExtension.swift
//  SimpleTodoApp
//
//  Created by Jamie Chen on 2021-05-12.
//

import Foundation
import UIKit

/// This is the setting of the constraints that will be applied in each view
enum TargetAnchor {
    case width(constant: CGFloat?)
    case widthRatioToSuperView(ratio: CGFloat?)
    case height(constant: CGFloat?)
    case heightRatioToSuperView(ratio: CGFloat?)
    case top(constant: CGFloat?)
    case bottom(constant: CGFloat?)
    case leading(constant: CGFloat?)
    case trailing(constant: CGFloat?)
    case centerX(constant: CGFloat?)
    case centerY(constant: CGFloat?)
}

extension UIView {
    func fillSuperView(padding: UIEdgeInsets) {
        guard let superview = self.superview else { return }
        setAnchors(target: superview, with: [.top(constant: padding.top), .bottom(constant: -padding.bottom), .leading(constant: padding.left), .trailing(constant: -padding.right)])
    }
    
    func setAnchors(target view: UIView, with anchors: [TargetAnchor]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        anchors.forEach({
            switch $0 {
            case .top(let constant):
                self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant ?? 0).isActive = true
            case .bottom(let constant):
                self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant ?? 0).isActive = true
            case .width(let constant):
                self.widthAnchor.constraint(equalToConstant: constant ?? 0).isActive = true
            case .height(let constant):
                self.heightAnchor.constraint(equalToConstant: constant ?? 0).isActive = true
            case .leading(let constant):
                self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant ?? 0).isActive = true
            case .trailing(let constant):
                self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant ?? 0).isActive = true
            case .centerX(let constant):
                self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant ?? 0).isActive = true
            case .centerY(let constant):
                self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant ?? 0).isActive = true
            case .widthRatioToSuperView(let ratio):
                self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: ratio ?? 1).isActive = true
            case .heightRatioToSuperView(let ratio):
                self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: ratio ?? 1).isActive = true
            }
        })
    }
}
