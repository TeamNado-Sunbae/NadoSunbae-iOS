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
 */
class NadoTextView: UITextView {
    
    func setDefaultStyle(isUsePlaceholder: Bool, placeholderText: String) {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray0.cgColor
        self.font = .PretendardR(size: 14.0)
        self.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        if isUsePlaceholder {
            self.text = placeholderText
            self.textColor = .gray2
        } else {
            self.textColor = .mainText
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        let attributes = [NSAttributedString.Key.paragraphStyle: style,
                          NSAttributedString.Key.font: UIFont.PretendardR(size: 14.0),
                          NSAttributedString.Key.foregroundColor: UIColor.gray2]
        self.attributedText = NSAttributedString(string: self.text, attributes: attributes)
    }
}
