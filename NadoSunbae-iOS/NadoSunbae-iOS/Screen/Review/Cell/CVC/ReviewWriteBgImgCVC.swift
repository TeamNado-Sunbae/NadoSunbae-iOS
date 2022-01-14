//
//  ReviewWriteBgImgCVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/14.
//

import UIKit

class ReviewWriteBgImgCVC: UICollectionViewCell, CVRegisterable {
    static var isFromNib: Bool {
        get {
            return true
        }
    }

    // MARK: UI Component
    @IBOutlet weak var bgImgView: UIImageView!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func setData(imgData: ReviewWriteBgImgData) {
        bgImgView.image = imgData.makeImg()
    }

}

extension ReviewWriteBgImgCVC {
    func configureUI() {
        bgImgView.layer.cornerRadius = 8
    }
}
