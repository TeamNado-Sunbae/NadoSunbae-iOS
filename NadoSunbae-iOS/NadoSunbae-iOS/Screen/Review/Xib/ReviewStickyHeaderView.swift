//
//  ReviewStickyHeaderView.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewStickyHeaderView: UITableViewHeaderFooterView {
    
    // MARK: IBOutlet
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var arrangeBtn: UIButton!
    
    // MARK: Properties
    var tapArrangeBtnAction : (() -> ())?
    var tapFilterBtnAction : (() -> ())?
    
    // MARK: IBAction
    @IBAction func tapArrangeBtn(_ sender: UIButton) {
        tapArrangeBtnAction?()
    }
    
    @IBAction func tapFilterBtn(_ sender: UIButton) {
        tapFilterBtnAction?()
    }
}
