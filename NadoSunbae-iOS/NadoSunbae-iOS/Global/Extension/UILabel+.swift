//
//  UILabel+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

extension UILabel {
    
    /// 자간 설정 메서드
    func setCharacterSpacing(_ spacing: CGFloat){
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
    }
    
    /// 글씨의 오토레이아웃이 기본으로 되어있는 메서드
    func setLabel(text: String, color: UIColor = .nadoBlack, size: CGFloat, weight: FontWeight = .regular) {
        let font: UIFont
        switch weight {
        case .light:
            font = .PretendardL(size: size.adjusted)
        case .regular:
            font = .PretendardR(size: size.adjusted)
        case .medium:
            font = .PretendardM(size: size.adjusted)
        case .bold:
            font = .PretendardB(size: size.adjusted)
        case .semiBold:
            font = .PretendardSB(size: size.adjusted)
        }
        self.font = font
        self.textColor = color
        self.text = text
    }
    
    /// 행간 조정 메서드
    func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributeString.length))
            self.attributedText = attributeString
        }
    }
    
    /// 특정 문자열 컬러 변경 메서드
    func setTextColor(targetStringList: [String], color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        targetStringList.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes([.foregroundColor: color as Any], range: range)
        }
        attributedText = attributedString
    }
    
    /// 특정 문자열 컬러 변경 및 행간 조정 메서드
    func setTextColorWithLineSpacing(targetStringList: [String], color: UIColor, lineSpacing: CGFloat) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        targetStringList.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes([.foregroundColor: color as Any], range: range)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributedString.length))
        }
        attributedText = attributedString
    }
    
}
