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
    }
}

// MARK: - Custom Methods
extension OnboardingCVC {
    
    /// 데이터 세팅 함수
    func setData(index: Int, contentData: OnboardingContentData) {
        titleLabel.text = contentData.title
        subTitleLabel.text = contentData.subtitle
        mainImgView.image = contentData.makeImg()
        
        switch index {
        case 2:
            subTitleLabel.setTextFontWithLineSpacing(targetStringList: ["1:1 질문", "기존에 나눴던 질의응답"], font: .PretendardSB(size: 14), lineSpacing: 5)
            subTitleLabel.textAlignment = .center
        case 3:
            subTitleLabel.setTextFontWithLineSpacing(targetStringList: ["각 학과 학생들로 구성된 커뮤니티"], font: .PretendardSB(size: 14), lineSpacing: 5)
            subTitleLabel.textAlignment = .center
        default:
            subTitleLabel.setLineSpacing(lineSpacing: 5)
            subTitleLabel.textAlignment = .center
        }
    }
}

