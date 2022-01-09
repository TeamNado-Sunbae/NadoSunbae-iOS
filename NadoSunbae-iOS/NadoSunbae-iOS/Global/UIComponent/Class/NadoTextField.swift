//
//  NadoTextField.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/08.
//

import UIKit
/**
 - Description:
 나도선배에서 자주 사용되는 텍스트필드
 */
//@IBDesignable
class NadoTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaultStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setDefaultStyle()
    }
    
    // MARK: Private Methods
    private func setDefaultStyle() {
        self.makeRounded(cornerRadius: 8.adjusted)
        self.font = .PretendardR(size: 15)
        self.addLeftPadding(16)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray1.cgColor
    }
}
