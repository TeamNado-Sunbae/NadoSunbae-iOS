//
//  BaseCVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class BaseCVC: UICollectionViewCell {
}

// MARK: - CVRegisterable
extension BaseCVC: CVRegisterable {
    
    static var isFromNib: Bool {
        get {
            return true
        }
    }
}
