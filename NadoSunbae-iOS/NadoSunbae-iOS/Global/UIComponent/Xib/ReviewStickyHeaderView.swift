//
//  ReviewStickyHeaderView.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewStickyHeaderView: UITableViewHeaderFooterView {
    
    func addShadowToHeaderView() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 12
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = UIBezierPath(roundedRect: UIView().bounds, cornerRadius: 0).cgPath
        self.layer.masksToBounds = false
    }
}

//self.layer.shadowColor = UIColor(red: 0.875, green: 0.874, blue: 0.908, alpha: 0.25).cgColor
