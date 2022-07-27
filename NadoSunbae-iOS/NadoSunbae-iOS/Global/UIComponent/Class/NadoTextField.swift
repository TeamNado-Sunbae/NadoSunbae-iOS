//
//  NadoTextField.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/08.
//

import UIKit
import SnapKit
import Then

/**
 - Description:
 나도선배에서 자주 사용되는 텍스트필드
 */

// @IBDesignable
class NadoTextField: UITextField {
    
    private let changeLabel = UILabel().then {
        $0.text = "변경"
        $0.font = .PretendardR(size: 12.0)
        $0.textColor = .mainDefault
        $0.textAlignment = .center
    }
    
    private let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "icSearchMint")
    }
    
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
        self.layer.borderColor = UIColor.gray0.cgColor
        self.backgroundColor = .white
    }
}

// MARK: - Public Methods

extension NadoTextField {
    
    /// '선택' style 설정 메서드
    func setSelectStyle() {
        setDefaultStyle()
        self.isUserInteractionEnabled = false

        self.addSubview(changeLabel)
        changeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.equalTo(48)
        }
    }
    
    /// '검색' style 설정 메서드
    func setSearchStyle() {
        setDefaultStyle()
        self.addSubview(searchImageView)
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        self.addLeftPadding(56)
        self.placeholder = "학과 이름을 검색해보세요."
    }
    
    /// Placeholder 설정 메서드
    func setPlaceHolderText(placeholder: String) {
        self.placeholder = placeholder
    }
    
    /// text 설정 메서드
    func setText(text: String) {
        self.text = text
    }
}
