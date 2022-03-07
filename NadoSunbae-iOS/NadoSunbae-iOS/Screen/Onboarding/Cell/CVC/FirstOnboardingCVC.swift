//
//  FirstOnboardingCVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/03/07.
//

import UIKit

class FirstOnboardingCVC: BaseCVC {

    // MARK: IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
}

// MARK: - UI
extension FirstOnboardingCVC {
    private func configureUI() {
        titleLabel.setLineSpacing(lineSpacing: 10)
        contentView.backgroundColor = .mintBgColor
        
        titleLabel.text = "나도선배에서\n손쉽게 선배들의 생생 후기와\n질의응답을 확인하세요."
        let attr = NSMutableAttributedString(string: titleLabel.text!)
        attr.addAttribute(.font, value: UIFont.PretendardSB(size: 24), range: (titleLabel.text! as NSString).range(of: "나도선배"))
        attr.addAttribute(.font, value: UIFont.PretendardSB(size: 24), range: (titleLabel.text! as NSString).range(of: "생생 후기"))
        attr.addAttribute(.foregroundColor, value: UIColor.mainDefault, range: (titleLabel.text! as NSString).range(of: "생생 후기"))
        attr.addAttribute(.font, value: UIFont.PretendardSB(size: 24), range: (titleLabel.text! as NSString).range(of: "질의응답"))
        attr.addAttribute(.foregroundColor, value: UIColor.mainDefault, range: (titleLabel.text! as NSString).range(of: "질의응답"))
        
        titleLabel.attributedText = attr
    }
}
