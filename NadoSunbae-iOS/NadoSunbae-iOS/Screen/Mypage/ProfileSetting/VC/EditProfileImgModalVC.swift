//
//  EditProfileImgModalVC.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/10/10.
//

import UIKit
import SnapKit
import Then

final class EditProfileImgModalVC: BaseVC {
    
    // MARK: Properties
    private let titleLabel = UILabel().then {
        $0.text = "프로필 사진 변경"
        $0.textColor = .black
        $0.font = .PretendardM(size: 16)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .mainDefault
    }
    
    private let cancelBtn = UIButton().then {
        $0.setImage(UIImage(named: "btnX"), for: .normal)
    }
    
    private let completeBtn = NadoSunbaeBtn().then {
        $0.isActivated = false
        $0.setTitle("선택 완료", for: .normal)
    }
    
    private let profileImgBtn1 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage1", selectedName: "grayProfileImage1")
    }
    
    private let profileImgBtn2 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage2", selectedName: "grayProfileImage2")
    }
    
    private let profileImgBtn3 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage3", selectedName: "grayProfileImage3")
    }
    
    private let profileImgBtn4 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage4", selectedName: "grayProfileImage4")
    }
    
    private let profileImgBtn5 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage5", selectedName: "grayProfileImage5")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tapCancelBtnAction()
    }
}

// MARK: - UI
extension EditProfileImgModalVC {
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews([titleLabel, lineView, cancelBtn, completeBtn, profileImgBtn1, profileImgBtn2, profileImgBtn3, profileImgBtn4, profileImgBtn5])
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        
        cancelBtn.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        profileImgBtn2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(lineView.snp.bottom).offset(56)
            $0.width.height.equalTo(72)
        }
        
        profileImgBtn1.snp.makeConstraints {
            $0.trailing.equalTo(profileImgBtn2.snp.leading).offset(-16)
            $0.centerY.equalTo(profileImgBtn2.snp.centerY)
            $0.width.height.equalTo(72)
        }
        
        profileImgBtn3.snp.makeConstraints {
            $0.leading.equalTo(profileImgBtn2.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImgBtn2.snp.centerY)
            $0.width.height.equalTo(72)
        }
        
        profileImgBtn4.snp.makeConstraints {
            $0.top.equalTo(profileImgBtn2.snp.bottom).offset(24)
            $0.trailing.equalTo(view.snp.centerX).offset(-8)
            $0.width.height.equalTo(72)
        }
        
        profileImgBtn5.snp.makeConstraints {
            $0.top.equalTo(profileImgBtn2.snp.bottom).offset(24)
            $0.leading.equalTo(view.snp.centerX).offset(8)
            $0.width.height.equalTo(72)
        }
        
        completeBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(34)
            $0.height.equalTo(60)
        }
    }
}

// MARK: - Custom Methods
extension EditProfileImgModalVC {
    
    /// x 버튼 액션 설정 메서드
    private func tapCancelBtnAction() {
        cancelBtn.press { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
