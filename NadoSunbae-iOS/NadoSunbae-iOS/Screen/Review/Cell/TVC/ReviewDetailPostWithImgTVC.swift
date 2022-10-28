//
//  ReviewDetailPostWithImgTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit
import SnapKit

class ReviewDetailPostWithImgTVC: BaseTVC {
    
    // MARK: Properties
    var tapPresentProfileBtnAction: (() -> ())?

    // MARK: IBOutlet
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var profileContainertView: UIView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.sizeToFit()
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var majorInfoLabel: UILabel!
    @IBOutlet weak var secondMajorInfoLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: IBAction
    @IBAction func tapPresentProfileBtn(_ sender: UIButton) {
        tapPresentProfileBtnAction?()
    }
    
}

// MARK: - UI
extension ReviewDetailPostWithImgTVC {
    private func configureUI() {
        profileContainertView.makeRounded(cornerRadius: 40.adjusted)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(bgImgView)
            $0.width.equalTo(312.adjusted)
        }
    }
    
    private func configureMyReviewUI() {
        bgImgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12)
        }
    }
}

// MARK: - Custom Methods
extension ReviewDetailPostWithImgTVC {
    
    /// 리스트 데이터 세팅 함수
    func setData(postData: ReviewPostDetailData) {
        titleLabel.text = postData.review.oneLineReview
        profileImgView.image = UIImage(named: "grayProfileImage\(postData.writer.profileImageId)")
        nicknameLabel.text = postData.writer.nickname
        majorInfoLabel.text = postData.writer.firstMajorName + " (\(postData.writer.firstMajorStart))"
        secondMajorInfoLabel.text = postData.writer.secondMajorName + " (\(postData.writer.secondMajorStart))"
        statusLabel.text = postData.writer.isOnQuestion ? "선배에게 1:1 질문을 남겨보세요!" : "지금 이 선배에겐 질문할 수 없어요."

        switch postData.backgroundImage.imageID {
        case 6:
            bgImgView.image = UIImage(named: "backgroundMint")
        case 7:
            bgImgView.image = UIImage(named: "backgroundBlack")
        case 8:
            bgImgView.image = UIImage(named: "backgroundSkyblue")
        case 9:
            bgImgView.image = UIImage(named: "backgroundPink")
        case 10:
            bgImgView.image = UIImage(named: "backgroundNavy")
        case 11:
            bgImgView.image = UIImage(named: "backgroundOrange")
        case 12:
            bgImgView.image = UIImage(named: "backgroundPurple")
        default:
            bgImgView.image = UIImage(named: "backgroundMint")
        }
        
        if postData.writer.writerID == UserDefaults.standard.integer(forKey:UserDefaults.Keys.UserID) {
            configureMyReviewUI()
            profileContainertView.isHidden = true
        } else {
            profileContainertView.isHidden = false
        }
    }
}
