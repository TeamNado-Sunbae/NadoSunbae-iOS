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
    @IBOutlet weak var tagImgWidth: NSLayoutConstraint!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        tagImgView.image = nil
    }
}

// MARK: - Custom Methods
extension ReviewPostTagCVC {
    func setData(tagData: ReviewTagList) {
        
        if tagData.tagName == "추천 수업" {
            tagImgWidth.constant = 59
            tagImgView.image = UIImage(named: "icReviewTag") ?? nil
        } else if tagData.tagName == "힘든 수업" {
            tagImgWidth.constant = 59
            tagImgView.image = UIImage(named: "icBadClassTag") ?? nil
        } else if tagData.tagName == "뭘 배우나요?" {
            tagImgWidth.constant = 75
            tagImgView.image = UIImage(named: "property1Learning") ?? nil
        } else if tagData.tagName == "향후 진로" {
            tagImgWidth.constant = 59
            tagImgView.image = UIImage(named: "property1Career") ?? nil
        } else if tagData.tagName == "꿀팁" {
            tagImgWidth.constant = 35
            tagImgView.image = UIImage(named: "icTipTag") ?? nil
        }
        else {
            tagImgView.image = nil
        }
    }
}

