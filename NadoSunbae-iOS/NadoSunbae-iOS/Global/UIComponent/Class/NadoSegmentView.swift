//
//  NadoSegmentView.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then

class NadoSegmentView: UIView {
    
    // MARK: Properties
    private let backView = UIView().then {
        $0.backgroundColor = .paleGray
    }
    
    let questionBtn = NadoSunbaeBtn().then {
        $0.setBtnColors(normalBgColor: .paleGray, normalFontColor: .gray3, activatedBgColor: .mainLight, activatedFontColor: .mainDefault)
        $0.setTitleWithStyle(title: "질문", size: 14.0)
        $0.isActivated = true
        $0.isEnabled = true
    }
    
    let infoBtn = NadoSunbaeBtn().then {
        $0.setBtnColors(normalBgColor: .paleGray, normalFontColor: .gray3, activatedBgColor: .mainLight, activatedFontColor: .mainDefault)
        $0.setTitleWithStyle(title: "정보", size: 14.0)
        $0.isActivated = false
        $0.isEnabled = true
    }

    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        setUpBtnVibrateAction()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureUI()
    }
}

// MARK: - UI
extension NadoSegmentView {
    func configureUI() {
        self.addSubviews([backView, questionBtn, infoBtn])
        
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        questionBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(backView).offset(24)
            $0.width.equalTo(56)
            $0.height.equalToSuperview()
        }
        
        infoBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(questionBtn.snp.trailing).offset(16)
            $0.width.equalTo(56)
            $0.height.equalToSuperview()
        }
    }
}

// MARK: - Custom Methods
extension NadoSegmentView {
    func setUpBtnVibrateAction() {
        [questionBtn, infoBtn].forEach() {
            $0.press(vibrate: true, for: .touchUpInside) {
                return
            }
        }
    }
}
