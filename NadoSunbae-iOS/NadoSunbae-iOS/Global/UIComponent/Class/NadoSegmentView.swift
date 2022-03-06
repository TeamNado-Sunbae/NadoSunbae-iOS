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
    
    let firstBtn = NadoSunbaeBtn().then {
        $0.setBtnColors(normalBgColor: .paleGray, normalFontColor: .gray3, activatedBgColor: .mainLight, activatedFontColor: .mainDefault)
        $0.isActivated = true
        $0.isEnabled = true
    }
    
    let secondBtn = NadoSunbaeBtn().then {
        $0.setBtnColors(normalBgColor: .paleGray, normalFontColor: .gray3, activatedBgColor: .mainLight, activatedFontColor: .mainDefault)
        $0.isActivated = false
        $0.isEnabled = true
    }
    
    let thirdBtn = NadoSunbaeBtn().then {
        $0.setBtnColors(normalBgColor: .paleGray, normalFontColor: .gray3, activatedBgColor: .mainLight, activatedFontColor: .mainDefault)
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
        self.addSubviews([backView, firstBtn, secondBtn, thirdBtn])
        
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        firstBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(backView).offset(24)
            $0.width.equalTo(56)
            $0.height.equalToSuperview()
        }
        
        secondBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(firstBtn.snp.trailing).offset(16)
            $0.width.equalTo(56)
            $0.height.equalToSuperview()
        }
        
        thirdBtn.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(secondBtn.snp.trailing).offset(16)
            $0.width.equalTo(56)
            $0.height.equalToSuperview()
        }
    }
}

// MARK: - Custom Methods
extension NadoSegmentView {
    func setUpBtnVibrateAction() {
        [firstBtn, secondBtn, thirdBtn].forEach() {
            $0.press(vibrate: true, for: .touchUpInside) {
                return
            }
        }
    }
}
