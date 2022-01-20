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
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        print("hello hello")
//    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        print("callcall")
        tagImgView.image = nil
    }
}

// MARK: - Custom Methods
extension ReviewPostTagCVC {
    func setData(tagData: ReviewTagList) {
        
        if tagData.tagName == "추천 수업" {
            tagImgView.image = UIImage(named: "icReviewTag") ?? nil
        } else if tagData.tagName == "비추 수업" {
            tagImgView.image = UIImage(named: "icBadClassTag") ?? nil
        } else if tagData.tagName == "뭘 배우나요?" {
            tagImgView.image = UIImage(named: "property1Learning") ?? nil
        } else if tagData.tagName == "향후 진로" {
            tagImgView.image = UIImage(named: "property1Career") ?? nil
        } else if tagData.tagName == "꿀팁" {
            tagImgView.image = UIImage(named: "icTipTag") ?? nil
        }
        else {
            tagImgView.image = nil
        }
    }
}

