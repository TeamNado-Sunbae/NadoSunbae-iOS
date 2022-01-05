//
//  UITextView+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/06.
//

import UIKit

extension UITextView {
    
    /// 자간 설정 메서드
    func setCharacterSpacing(_ spacing: CGFloat){
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
    }
}
