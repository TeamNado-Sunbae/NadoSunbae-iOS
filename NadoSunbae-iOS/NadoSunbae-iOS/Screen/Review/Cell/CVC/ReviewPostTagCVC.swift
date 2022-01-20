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
    func setData(tagData: ReviewTagList) {
        if tagData.tagName == "추천 수업" {
            tagImgView.image = UIImage(named: "icReviewTag")
        } else if tagData.tagName == "비추 수업" {
            tagImgView.image = UIImage(named: "icBadClassTag")
        } else if tagData.tagName == "뭘 배우나요?" {
            tagImgView.image = UIImage(named: "property1Learning")
        } else if tagData.tagName == "향후 진로" {
            tagImgView.image = UIImage(named: "property1Career")
        } else if tagData.tagName == "꿀팁" {
            tagImgView.image = UIImage(named: "icTipTag")
        }
    }
}

