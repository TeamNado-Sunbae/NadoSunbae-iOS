//
//  BaseCVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class BaseCVC: UICollectionViewCell {
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupViews() {
        
    }
}

// MARK: - UICollectionViewRegisterable
extension BaseCVC: UICollectionViewRegisterable {
    
    static var isFromNib: Bool {
        get {
            return true
        }
    }
}
