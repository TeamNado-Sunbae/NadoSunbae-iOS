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
    @IBOutlet weak var isOnQuestionToggleBtn: UIButton! {
        didSet {
            isOnQuestionToggleBtn.setImage(UIImage(named: "toggle_off"), for: .normal)
            isOnQuestionToggleBtn.setImage(UIImage(named: "toggle_on"), for: .selected)
            isOnQuestionToggleBtn.press {
                self.isOnQuestionToggleBtn.isSelected.toggle()
            }
        }
    }
    @IBOutlet weak var firstMajorTextField: NadoTextField!
    @IBOutlet weak var firstMajorStartTextField: NadoTextField!
    @IBOutlet weak var secondMajorTextField: NadoTextField!
    @IBOutlet weak var secondMajorStartTextField: NadoTextField!
    
    // MARK: Properties
    var userInfo = MypageUserInfoModel()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyInfo()
    }
    
    // MARK: Custom Methods
}

// MARK: - UI
extension EditProfileVC {
    private func configureUI() {
        profileImgView.image = UIImage(named: "profileImage\(userInfo.profileImageID)")
        nickNameTextField.placeholder = userInfo.nickname
        isOnQuestionToggleBtn.isSelected = userInfo.isOnQuestion
        firstMajorTextField.text = userInfo.firstMajorName
        firstMajorStartTextField.text = userInfo.firstMajorStart
        secondMajorTextField.text = userInfo.secondMajorName
        secondMajorStartTextField.text = userInfo.secondMajorStart
    }
}

// MARK:- Network
extension EditProfileVC {
    private func getMyInfo() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getUserInfo(userID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID), completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageUserInfoModel {
                    self.userInfo = data
                    self.configureUI()
                }
                self.activityIndicator.stopAnimating()
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
}
