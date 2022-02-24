//
//  EditProfileVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/24.
//

import UIKit

class EditProfileVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefaultWithNadoBtn)
            navView.configureTitleLabel(title: "프로필 수정")
            navView.rightActivateBtn.setTitleWithStyle(title: "저장", size: 14)
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nickNameChangeBtn: UIButton!
    @IBOutlet weak var nickNameRuleLabel: UILabel!
    @IBOutlet weak var nickNameTextField: NadoTextField!
    @IBOutlet weak var nickNameInfoLabel: UILabel!
    @IBOutlet weak var isQuestionOnToggleBtn: UIButton! {
        didSet {
            isQuestionOnToggleBtn.setImage(UIImage(named: "toggle_off"), for: .normal)
            isQuestionOnToggleBtn.setImage(UIImage(named: "toggle_on"), for: .selected)
            isQuestionOnToggleBtn.press {
                self.isQuestionOnToggleBtn.isSelected.toggle()
            }
        }
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Custom Methods
}

// MARK: - UI
extension EditProfileVC {
    
}

// MARK:- Network
extension EditProfileVC {
    
}
