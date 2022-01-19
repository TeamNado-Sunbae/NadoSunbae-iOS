//
//  ReviewPostTagCVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import UIKit

class ReviewPostTagCVC: BaseCVC {

    // MARK: IBOutlet
    @IBOutlet weak var tagImgView: UIImageView!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Custom Methods
extension ReviewPostTagCVC {
    func setData(tagData: tagImgData) {
        tagImgView.image = tagData.makeImg()
    }
}
