//
//  NadoSunbaeNaviBar.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/08.
//

import UIKit
import SnapKit
import Then

enum NaviState {
    case backDefault
    case backDefaultWithNadoBtn
    case backWithCenterTitle
    case dismissWithCustomRightBtn
    case dismissWithNadoBtn
}

/**
 나도선배에서 자주 사용되는 네비게이션바 UIView.
 - Note:
 - backDefault: 뒤로가기 버튼 + 바로 옆 텍스트 (디폴트)
 - backDefaultWithNadoBtn: 뒤로가기 버튼과 + 바로 옆 텍스트 + 우측 나도선배 버튼
 - backWithCenterTitle: 뒤로가기 버튼 + 중앙 텍스트 + 우측 버튼
 - dismissWithCustomRightBtn: 취소 버튼과 중앙 텍스트 + 우측 버튼
 - dismissWithNadoBtn: 취소 버튼과 중앙 텍스트 + 우측 나도선배 버튼
 
 - configureTitleLabel: titleLabel 텍스트 변경
 - configureRightCustomBtn: 우측 커스텀 버튼 이미지 변경
 - setUpNaviStyle: NaviState를 지정해 해당 스타일로 네비바를 구성
 */
class NadoSunbaeNaviBar: UIView {
    
    // MARK: Properties
    private lazy var backView = UIView().then {
        $0.backgroundColor = .systemBackground
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.setLabel(text: "제목", color: .black, size: 20, weight: .medium)
    }

    private (set) lazy var backBtn = UIButton().then {
        $0.setImgByName(name: "btnBack", selectedName: nil)
        $0.contentMode = .scaleAspectFit
    }
    
    private (set) lazy var dismissBtn = UIButton().then {
        $0.setImgByName(name: "btnX", selectedName: nil)
        $0.contentMode = .scaleAspectFit
    }
    
    private (set) lazy var rightCustomBtn = UIButton().then {
        $0.setImgByName(name: "icNoticeSmall", selectedName: "icNoticeSmallSelected")
        $0.contentMode = .scaleAspectFit
    }
    
    private (set) lazy var rightActivateBtn = NadoSunbaeBtn().then {
        $0.isActivated = false
        $0.setTitle("완료", for: .normal)
    }
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}

// MARK: - UI
extension NadoSunbaeNaviBar {
    
    // MARK: Private Methods
    /// 뒤로가기 버튼이 있는 디폴트 UI를 구성하는 메서드
    private func configureDefaultUI() {
        self.addSubviews([backView, backBtn, titleLabel])
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backBtn.snp.trailing)
            $0.centerY.equalTo(backBtn)
        }
    }
    
    /// 뒤로가기 버튼 + 나도선배 버튼 UI를 구성하는 메서드
    private func configureBackWithNadoBtnUI() {
        self.addSubviews([backView, backBtn, titleLabel, rightActivateBtn])
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backBtn.snp.trailing)
            $0.centerY.equalTo(backBtn)
        }
        
        rightActivateBtn.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).offset(-16)
            $0.height.equalTo(36)
            $0.width.equalTo(rightActivateBtn.snp.height).multipliedBy(52.0 / 36.0)
            $0.centerY.equalTo(backBtn)
        }
    }
    
    /// 뒤로가기 버튼 + 중앙 텍스트 + 우측 커스텀 버튼 UI를 구성하는 메서드
    private func configureBackWithCenterUI() {
        self.addSubviews([backView, backBtn, titleLabel, rightCustomBtn])
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        rightCustomBtn.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).offset(-8)
            $0.height.equalTo(44)
            $0.centerY.equalTo(backBtn)
        }
        titleLabel.setLabel(text: "제목", color: .black, size: 16, weight: .medium)
    }
    
    /// 취소 버튼 + 중앙 텍스트 + 우측 커스텀 버튼 UI를 구성하는 메서드
    private func configureDismissWithCustomRightBtnUI() {
        self.addSubviews([backView, dismissBtn, titleLabel, rightCustomBtn])
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        dismissBtn.snp.makeConstraints {
            $0.top.equalTo(self).offset(4)
            $0.leading.equalTo(self).offset(4)
            $0.height.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        rightCustomBtn.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).offset(-8)
            $0.height.equalTo(44)
            $0.centerY.equalTo(dismissBtn)
        }
        titleLabel.setLabel(text: "제목", color: .black, size: 16, weight: .medium)
    }
    
    /// 취소 버튼 + 중앙 텍스트 + 나도선배 버튼 UI를 구성하는 메서드
    private func configureDismissWithNadoBtnUI() {
        self.addSubviews([backView, dismissBtn, titleLabel, rightActivateBtn])
        backView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        dismissBtn.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.width.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        rightActivateBtn.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).offset(-16)
            $0.height.equalTo(36)
            $0.width.equalTo(rightActivateBtn.snp.height).multipliedBy(52.0 / 36.0)
            $0.centerY.equalTo(dismissBtn)
        }
        titleLabel.setLabel(text: "제목", color: .black, size: 16, weight: .medium)
    }
    
    // MARK: Public Methods
    /// 커스텀 네비 바 타이틀 설정하는 메서드
    func configureTitleLabel(title: String) {
        self.titleLabel.text = title
    }
    
    /// 커스텀 네비 바 우측 버튼 이미지 설정하는 메서드
    func configureRightCustomBtn(imgName: String, selectedImgName: String) {
        rightCustomBtn.setImgByName(name: imgName, selectedName: selectedImgName)
    }
}

// MARK: - Custom Methods
extension NadoSunbaeNaviBar {
    
    /// state에 따라 커스텀 네비 UI 스타일을 지정하는 메서드
    func setUpNaviStyle(state: NaviState) {
        switch state.self {
            
        case .backDefault:
            configureDefaultUI()
        case .backDefaultWithNadoBtn:
            configureBackWithNadoBtnUI()
        case .backWithCenterTitle:
            configureBackWithCenterUI()
        case .dismissWithCustomRightBtn:
            configureDismissWithCustomRightBtnUI()
        case .dismissWithNadoBtn:
            configureDismissWithNadoBtnUI()
        }
    }
}
