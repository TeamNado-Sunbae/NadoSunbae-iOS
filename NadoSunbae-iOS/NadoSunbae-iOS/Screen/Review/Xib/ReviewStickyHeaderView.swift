//
//  ReviewStickyHeaderView.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewStickyHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Properties
    var tapArrangeBtnAction : (() -> ())?
    
    // MARK: Custom Methods
    func addShadowToHeaderView() {
        
    }
    
    // MARK: IBAction
    @IBAction func tapArrangeBtn(_ sender: UIButton) {
        tapArrangeBtnAction?()
    }
}


