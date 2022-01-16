//
//  CodeBaseCVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/16.
//

import UIKit

class CodeBaseCVC: UICollectionViewCell {
    
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

// MARK: - CVRegisterable
extension CodeBaseCVC: CVRegisterable {
    
    static var isFromNib: Bool {
        get {
            return true
        }
    }
}
