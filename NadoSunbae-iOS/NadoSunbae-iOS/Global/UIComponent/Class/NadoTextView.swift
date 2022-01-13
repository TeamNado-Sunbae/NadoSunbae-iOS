//
//  NadoTextView.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/14.
//

import UIKit
import SnapKit
import Then

/**
 나도선배에서 자주 사용되는 Scroll Indicator Custom TextView.
 - Note:
 - configureTitleLabel: titleLabel 텍스트 변경
 - configureRightCustomBtn: 우측 커스텀 버튼 이미지 변경
 - setUpNaviStyle: NaviState를 지정해 해당 스타일로 네비바를 구성
 */
class NadoTextView: UITextView {
    
    func setDefaultStyle(placeholderText: String) {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray0.cgColor
        self.text = placeholderText
        self.textColor = .gray2
        self.font = .PretendardR(size: 14.0)
        self.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        let attributes = [NSAttributedString.Key.paragraphStyle: style,
                          NSAttributedString.Key.font: UIFont.PretendardR(size: 14.0),
                          NSAttributedString.Key.foregroundColor: UIColor.gray2]
        self.attributedText = NSAttributedString(string: self.text, attributes: attributes)
    }
}
