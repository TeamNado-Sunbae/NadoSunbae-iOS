//
//  ReviewDetailPostWithImgTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailPostWithImgTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var postContentView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UI
extension ReviewDetailPostWithImgTVC {
    private func configureUI() {
        postContentView.makeRounded(cornerRadius: 40.adjusted)
    }  
}

// MARK: - Custom Methods
extension ReviewDetailPostWithImgTVC {
    
    /// 리스트 데이터 세팅 함수
    func setData(postData: PostDetail) {
        bgImgView.image = UIImage(named: "cube")
        titleLabel.text = postData.oneLineReview
        contentLabel.text = postData.contentList[0].content
    }
}
