//
//  NadoMaskedImgView.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/07/10.
//

import UIKit

class NadoMaskedImgView: UIImageView {
    
    // MARK: Properties
    private var maskImgView = UIImageView()
    
    var maskImg: UIImage? {
        didSet {
            maskImgView.image = maskImg
            updateImgView()
        }
    }
    
    // MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImgView()
        
    }
    
    /// mask가 적용된 이미지로 업데이트 해주는 메서드
    private func updateImgView() {
        if maskImgView.image != nil {
            maskImgView.frame = bounds
            mask = maskImgView
        }
    }
}
