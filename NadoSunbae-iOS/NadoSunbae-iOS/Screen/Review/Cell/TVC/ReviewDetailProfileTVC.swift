//
//  ReviewDetailProfileTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailProfileTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var secondMajorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
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
extension ReviewDetailProfileTVC {
    private func configureUI() {
        contentView.makeRounded(cornerRadius: 40.adjusted)
    }
    
    /// TVC 사이 간격 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 16, bottom: 24, right: 16))
    }
}

// MARK: - Custom Methods
extension ReviewDetailProfileTVC {
    
    /// 리스트 데이터 세팅 함수
    func setData(profileData: PostWriter) {
        profileImgView.image = UIImage(named: "profileImage\(profileData.profileImageID)")
        nickNameLabel.text = profileData.nickname
        majorLabel.text = profileData.firstMajorName
        secondMajorLabel.text = profileData.secondMajorName
        messageLabel.text = "선배에게 1:1 질문을 남겨보세요!"
    }
}
