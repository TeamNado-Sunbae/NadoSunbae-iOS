//
//  ThirdOnboardingCVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/03/08.
//

import UIKit

class ThirdOnboardingCVC: BaseCVC {

    // MARK: IBOutlet
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
}

// MARK: - UI
extension ThirdOnboardingCVC {
    private func configureUI() {
        subTitleLabel.setLineSpacing(lineSpacing: 5)
        subTitleLabel.textAlignment = .center
        
        subTitleLabel.text = "궁금한게 있는 학과 선배에겐 1:1 질문을,\n학과 구성원 모두의 의견을 듣고 싶을 땐\n전체에게 질문을 해보세요."
        let attr = NSMutableAttributedString(string: subTitleLabel.text!)
        attr.addAttribute(.font, value: UIFont.PretendardSB(size: 14), range: (subTitleLabel.text! as NSString).range(of: "1:1 질문"))
        attr.addAttribute(.font, value: UIFont.PretendardSB(size: 14), range: (subTitleLabel.text! as NSString).range(of: "전체에게 질문"))
        
        subTitleLabel.attributedText = attr
    }
}
