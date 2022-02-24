//
//  EditProfileVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/24.
//

import UIKit
import RxSwift
import RxCocoa

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
    @IBOutlet weak var nickNameChangeBtn: UIButton! {
        didSet {
            nickNameChangeBtn.setTitleColor(.mainDefault, for: .normal)
            nickNameChangeBtn.setTitleColor(.gray2, for: .disabled)
        }
    }
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
    let disposeBag = DisposeBag()
    var userInfo = MypageUserInfoModel()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNickNameIsValid()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMyInfo()
    }
    
    // MARK: @IBAction
    @IBAction func tapNickNameChangeBtn(_ sender: Any) {
        requestCheckNickName(nickName: nickNameTextField.text!)
    }
    
    
    // MARK: Custom Methods
    
    /// 닉네임 유효성 검사
    private func checkNickNameIsValid() {
        nickNameTextField.rx.text
            .orEmpty
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                //                self.isCompleteList[0] = false
                let regex = "[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9]{2,8}"
                if changedText.count == 0 {
                    self.changeLabelColor(isOK: true, label: self.nickNameRuleLabel)
                    self.nickNameChangeBtn.isEnabled = false
                } else if NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: changedText) {
                    self.changeLabelColor(isOK: true, label: self.nickNameRuleLabel)
                    self.nickNameChangeBtn.isEnabled = true
                    self.nickNameInfoLabel.text = ""
                } else {
                    self.changeLabelColor(isOK: false, label: self.nickNameRuleLabel)
                    self.nickNameChangeBtn.isEnabled = false
                    self.nickNameInfoLabel.text = ""
                }
            })
            .disposed(by: disposeBag)
    }
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
    
    private func changeLabelColor(isOK: Bool, label: UILabel) {
        label.textColor = isOK ? .gray3 : .red
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
    
    private func requestCheckNickName(nickName: String) {
        self.activityIndicator.startAnimating()
        SignAPI.shared.checkNickNameDuplicate(nickName: nickName) { networkResult in
            switch networkResult {
            case .success:
                self.activityIndicator.stopAnimating()
                self.nickNameInfoLabel.textColor = .mainDark
                self.nickNameInfoLabel.text = "사용 가능한 닉네임입니다."
//                self.isCompleteList[0] = true
                self.nickNameTextField.placeholder = nickName
                self.nickNameTextField.text = ""
            case .requestErr(let success):
                self.activityIndicator.stopAnimating()
                if success is Bool {
                    self.nickNameInfoLabel.textColor = .red
                    self.nickNameInfoLabel.text = "이미 사용중인 닉네임입니다."
//                    self.isCompleteList[0] = false
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
