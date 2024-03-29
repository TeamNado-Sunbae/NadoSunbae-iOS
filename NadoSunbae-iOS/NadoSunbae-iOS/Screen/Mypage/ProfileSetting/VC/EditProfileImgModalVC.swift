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
        $0.setTitle("선택 완료", for: .normal)
    }
    
    private let profileImgBtn1 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage1", selectedName: "Frame 922")
        $0.tag = 1
    }
    
    private let profileImgBtn2 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage2", selectedName: "Frame 924")
        $0.tag = 2
    }
    
    private let profileImgBtn3 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage3", selectedName: "Frame 921")
        $0.tag = 3
    }
    
    private let profileImgBtn4 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage4", selectedName: "Frame 923")
        $0.tag = 4
    }
    
    private let profileImgBtn5 = UIButton().then {
        $0.setImgByName(name: "grayProfileImage5", selectedName: "Frame 920")
        $0.tag = 5
    }
    
    private lazy var checkImgView1 = UIImageView().then {
        $0.image = UIImage(named: "icon_check_img")
    }
    
    private lazy var checkImgView2 = UIImageView().then {
        $0.image = UIImage(named: "icon_check_img")
    }
    
    private lazy var checkImgView3 = UIImageView().then {
        $0.image = UIImage(named: "icon_check_img")
    }
    
    private lazy var checkImgView4 = UIImageView().then {
        $0.image = UIImage(named: "icon_check_img")
    }
    
    private lazy var checkImgView5 = UIImageView().then {
        $0.image = UIImage(named: "icon_check_img")
    }
    
    var originProfileImgID = 0
    var changedProfileImgID = 0
    var defaultSelectedBtn = UIButton()
    var selectedProfileID = 0
    var selectNewProfileDelegate: SendUpdateModalDelegate?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureDefaultProfileUI()
        tapCancelBtnAction()
        tapCompleteBtnAction()
        tapProfile1BtnAction()
        tapProfile2BtnAction()
        tapProfile3BtnAction()
        tapProfile4BtnAction()
        tapProfile5BtnAction()
    }
}

// MARK: - UI
extension EditProfileImgModalVC {
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews([titleLabel, lineView, cancelBtn, completeBtn, profileImgBtn1, profileImgBtn2, profileImgBtn3, profileImgBtn4, profileImgBtn5, checkImgView1, checkImgView2, checkImgView3, checkImgView4, checkImgView5])
        
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
        
        checkImgView2.snp.makeConstraints {
            $0.centerX.equalTo(profileImgBtn2.snp.centerX)
            $0.top.equalTo(profileImgBtn2.snp.bottom).offset(-10)
            $0.width.height.equalTo(20)
        }
        
        profileImgBtn1.snp.makeConstraints {
            $0.trailing.equalTo(profileImgBtn2.snp.leading).offset(-16)
            $0.centerY.equalTo(profileImgBtn2.snp.centerY)
            $0.width.height.equalTo(72)
        }
        
        checkImgView1.snp.makeConstraints {
            $0.centerX.equalTo(profileImgBtn1.snp.centerX)
            $0.top.equalTo(profileImgBtn1.snp.bottom).offset(-10)
            $0.width.height.equalTo(20)
        }
        
        profileImgBtn3.snp.makeConstraints {
            $0.leading.equalTo(profileImgBtn2.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImgBtn2.snp.centerY)
            $0.width.height.equalTo(72)
        }
        
        checkImgView3.snp.makeConstraints {
            $0.centerX.equalTo(profileImgBtn3.snp.centerX)
            $0.top.equalTo(profileImgBtn3.snp.bottom).offset(-10)
            $0.width.height.equalTo(20)
        }
        
        profileImgBtn4.snp.makeConstraints {
            $0.top.equalTo(profileImgBtn2.snp.bottom).offset(24)
            $0.trailing.equalTo(view.snp.centerX).offset(-8)
            $0.width.height.equalTo(72)
        }
        
        checkImgView4.snp.makeConstraints {
            $0.centerX.equalTo(profileImgBtn4.snp.centerX)
            $0.top.equalTo(profileImgBtn4.snp.bottom).offset(-10)
            $0.width.height.equalTo(20)
        }
        
        profileImgBtn5.snp.makeConstraints {
            $0.top.equalTo(profileImgBtn2.snp.bottom).offset(24)
            $0.leading.equalTo(view.snp.centerX).offset(8)
            $0.width.height.equalTo(72)
        }
        
        checkImgView5.snp.makeConstraints {
            $0.centerX.equalTo(profileImgBtn5.snp.centerX)
            $0.top.equalTo(profileImgBtn5.snp.bottom).offset(-10)
            $0.width.height.equalTo(20)
        }
        
        completeBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(34)
            $0.height.equalTo(60)
        }
        
        [checkImgView1, checkImgView2, checkImgView3, checkImgView4, checkImgView5].forEach {
            $0.isHidden = true
        }
        
        completeBtn.isActivated = originProfileImgID == changedProfileImgID ? false : true
    }
    
    /// 원래 프로필 이미지 선택되어있도록 하는 메서드
    private func configureDefaultProfileUI() {
        switch originProfileImgID {
        case 1:
            defaultSelectedBtn = profileImgBtn1
        case 2:
            defaultSelectedBtn = profileImgBtn2
        case 3:
            defaultSelectedBtn = profileImgBtn3
        case 4:
            defaultSelectedBtn = profileImgBtn4
        case 5:
            defaultSelectedBtn = profileImgBtn5
        default:
            break
        }
        
        switch changedProfileImgID {
        case 1:
            profileImgBtn1.isSelected = true
            checkImgView1.isHidden = false
        case 2:
            profileImgBtn2.isSelected = true
            checkImgView2.isHidden = false
        case 3:
            profileImgBtn3.isSelected = true
            checkImgView3.isHidden = false
        case 4:
            profileImgBtn4.isSelected = true
            checkImgView4.isHidden = false
        case 5:
            profileImgBtn5.isSelected = true
            checkImgView5.isHidden = false
        default:
            break
        }
    }
    
    /// 선택완료 버튼 활성화 조건 설정 메서드
    private func configureCompleteBtnUI(sender: UIButton) {
        completeBtn.isActivated = sender != defaultSelectedBtn
        selectedProfileID = sender.tag
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
    
    /// 선택완료 버튼 클릭 시 데이터 전달
    private func tapCompleteBtnAction() {
        completeBtn.press { [weak self] in
            guard let self = self else { return }
            
            self.selectNewProfileDelegate?.sendUpdate(data: self.selectedProfileID)
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
            })
        }
    }
    
    /// 프로필이미지버튼1 액션 설정 메서드
    private func tapProfile1BtnAction() {
        profileImgBtn1.press { [weak self] in
            guard let self = self else { return }
            
            self.profileImgBtn1.isSelected.toggle()
            self.checkImgView1.isHidden.toggle()
            [self.profileImgBtn2, self.profileImgBtn3, self.profileImgBtn4, self.profileImgBtn5].forEach {
                $0.isSelected = false
            }
            [self.checkImgView2, self.checkImgView3, self.checkImgView4, self.checkImgView5].forEach {
                $0.isHidden = true
            }
            self.configureCompleteBtnUI(sender: self.profileImgBtn1)
        }
    }
    
    /// 프로필이미지버튼2 액션 설정 메서드
    private func tapProfile2BtnAction() {
        profileImgBtn2.press { [weak self] in
            guard let self = self else { return }
            
            self.profileImgBtn2.isSelected.toggle()
            self.checkImgView2.isHidden.toggle()
            [self.profileImgBtn1, self.profileImgBtn3, self.profileImgBtn4, self.profileImgBtn5].forEach {
                $0?.isSelected = false
            }
            [self.checkImgView1, self.checkImgView3, self.checkImgView4, self.checkImgView5].forEach {
                $0.isHidden = true
            }
            self.configureCompleteBtnUI(sender: self.profileImgBtn2)
        }
    }
    
    /// 프로필이미지버튼3 액션 설정 메서드
    private func tapProfile3BtnAction() {
        profileImgBtn3.press { [weak self] in
            guard let self = self else { return }
            
            self.profileImgBtn3.isSelected.toggle()
            self.checkImgView3.isHidden.toggle()
            [self.profileImgBtn1, self.profileImgBtn2, self.profileImgBtn4, self.profileImgBtn5].forEach {
                $0.isSelected = false
            }
            [self.checkImgView1, self.checkImgView2, self.checkImgView4, self.checkImgView5].forEach {
                $0.isHidden = true
            }
            self.configureCompleteBtnUI(sender: self.profileImgBtn3)
        }
    }
    
    /// 프로필이미지버튼4 액션 설정 메서드
    private func tapProfile4BtnAction() {
        profileImgBtn4.press { [weak self] in
            guard let self = self else { return }
            
            self.profileImgBtn4.isSelected.toggle()
            self.checkImgView4.isHidden.toggle()
            [self.profileImgBtn1, self.profileImgBtn2, self.profileImgBtn3, self.profileImgBtn5].forEach {
                $0.isSelected = false
            }
            [self.checkImgView1, self.checkImgView2, self.checkImgView3, self.checkImgView5].forEach {
                $0.isHidden = true
            }
            self.configureCompleteBtnUI(sender: self.profileImgBtn4)
        }
    }
    
    /// 프로필이미지버튼5 액션 설정 메서드
    private func tapProfile5BtnAction() {
        profileImgBtn5.press { [weak self] in
            guard let self = self else { return }
            
            self.profileImgBtn5.isSelected.toggle()
            self.checkImgView5.isHidden.toggle()
            [self.profileImgBtn1, self.profileImgBtn2, self.profileImgBtn3, self.profileImgBtn4].forEach {
                $0.isSelected = false
            }
            [self.checkImgView1, self.checkImgView2, self.checkImgView3, self.checkImgView4].forEach {
                $0?.isHidden = true
            }
            self.configureCompleteBtnUI(sender: self.profileImgBtn5)
        }
    }
}
