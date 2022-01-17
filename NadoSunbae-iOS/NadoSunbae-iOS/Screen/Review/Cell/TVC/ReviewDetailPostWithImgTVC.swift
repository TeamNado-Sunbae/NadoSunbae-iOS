//
//  ReviewDetailPostWithImgTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailPostWithImgTVC: BaseTVC {

    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var postContentView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(postData: ReviewEssentialData) {
        bgImgView.image = postData.makeImg()
        contentLabel.text = postData.content
    }
}

extension ReviewDetailPostWithImgTVC {
    private func configureUI() {
        postContentView.makeRounded(cornerRadius: 40.adjusted)
    }

}
