//
//  ReviewDetailPostWithImgTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit
import SnapKit

class ReviewDetailPostWithImgTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var postContentView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.sizeToFit()
        }
    }
    
    @IBOutlet weak var tagLabel: UILabel!
    
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
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(bgImgView)
            $0.centerX.equalTo(bgImgView.frame.size.height - 40)
            $0.width.equalTo(312.adjusted)
        }
    }  
}

// MARK: - Custom Methods
extension ReviewDetailPostWithImgTVC {
    
    /// 리스트 데이터 세팅 함수
    func setData(postData: ReviewPostDetailData) {
        if postData.backgroundImage.imageID == 6 {
            bgImgView.image = UIImage(named: "backgroundMint")
        } else if postData.backgroundImage.imageID == 7 {
            bgImgView.image = UIImage(named: "backgroundBlack")
        } else if postData.backgroundImage.imageID == 8 {
            bgImgView.image = UIImage(named: "backgroundSkyblue")
        } else if postData.backgroundImage.imageID == 9 {
            bgImgView.image = UIImage(named: "backgroundPink")
        } else if postData.backgroundImage.imageID == 10 {
            bgImgView.image = UIImage(named: "backgroundNavy")
        } else if postData.backgroundImage.imageID == 11 {
            bgImgView.image = UIImage(named: "backgroundOrange")
        } else if postData.backgroundImage.imageID == 12 {
            bgImgView.image = UIImage(named: "backgroundPurple")
        } else {
            bgImgView.image = UIImage(named: "backgroundMint")
        }
        titleLabel.text = postData.post.oneLineReview
        tagLabel.text = postData.post.contentList[0].title
        contentLabel.text = postData.post.contentList[0].content
    }
}
