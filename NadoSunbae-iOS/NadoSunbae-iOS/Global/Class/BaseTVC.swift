//
//  BaseTVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/11.
//

import UIKit

class BaseTVC: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension BaseTVC: UITableViewRegisterable {
    
    static var isFromNib: Bool {
        get {
            return true
        }
    }
}
