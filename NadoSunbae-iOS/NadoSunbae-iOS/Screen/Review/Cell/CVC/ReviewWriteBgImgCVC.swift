//
//  ReviewWriteBgImgCVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/14.
//

import UIKit

class ReviewWriteBgImgCVC: BaseCVC {

    // MARK: UI Component
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var checkBtn: UIButton! {
        didSet {
            checkBtn.isHidden = true
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: Custom Method
    func setData(imgData: ReviewWriteBgImgData) {
        bgImgView.image = imgData.makeImg()
    }
}

// MARK: - UI
extension ReviewWriteBgImgCVC {
    func configureUI() {
        bgImgView.makeRounded(cornerRadius: 8.adjusted)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkBtn.isHidden = false
            } else {
                checkBtn.isHidden = true
            }
        }
    }
}
