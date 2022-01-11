//
//  ReviewMainLinkTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewMainLinkTVC: UITableViewCell, UITableViewRegisterable {
    
    /// Register할 Nib get
    static var isFromNib: Bool {
        get {
            return true
        }
    }

    // MARK: Life Cycle Part
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
