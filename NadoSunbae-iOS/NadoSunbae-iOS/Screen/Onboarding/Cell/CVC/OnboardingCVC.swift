//
//  OnboardingCVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/03/08.
//

import UIKit

class OnboardingCVC: BaseCVC {

    // MARK: IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var mainImgView: UIImageView!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
}

// MARK: - UI
extension OnboardingCVC {
    private func configureUI() {
        subTitleLabel.setLineSpacing(lineSpacing: 5)
        subTitleLabel.textAlignment = .center
    }
}

// MARK: - Custom Methods
extension OnboardingCVC {
    
    /// 데이터 세팅 함수
    func setData(contentData: OnboardingContentData) {
        titleLabel.text = contentData.title
        subTitleLabel.text = contentData.subtitle
        mainImgView.image = contentData.makeImg()
    }
}

