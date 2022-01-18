//
//  ReviewDetailPostTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailPostTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.makeRounded(cornerRadius: 40.adjusted)
        }
    }
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.sizeToFit()
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    // MARK: Custom Methods
    
    /// 리스트 데이터 세팅 함수
    func setData(postData: ReviewDetailData) {
        iconImgView.image = postData.makeImg()
        titleLabel.text = postData.title
        contentLabel.text = postData.content
    }
}

