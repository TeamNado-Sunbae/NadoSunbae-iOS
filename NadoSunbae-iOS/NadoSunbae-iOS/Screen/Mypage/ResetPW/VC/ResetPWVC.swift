//
//  ResetPWVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit
import RxSwift
import RxCocoa

class ResetPWVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var backBtn: UIButton! {
        didSet {
            backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.text = """
                                본인 인증을 위해
                                가입 당시 입력한 정보를 입력해주세요.
                                """
        }
    }
    @IBOutlet weak var emailTextField: NadoTextField!
    @IBOutlet weak var emailClearBtn: UIButton!
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.isHidden = true
        }
    }
    @IBOutlet weak var confirmBtn: NadoSunbaeBtn! {
        didSet {
            confirmBtn.press {
                self.requestResetPW(email: self.emailTextField.text ?? "")
            }
        }
    }
    
    // MARK: Properties
    let disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldClearBtn(textField: emailTextField, clearBtn: emailClearBtn)
        checkEmailIsValid()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabbar()
    }
    
    // MARK: Custom Methods
    
    /// textField-btn 에 clear 기능 세팅하는 함수
    private func setTextFieldClearBtn(textField: UITextField, clearBtn: UIButton) {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                clearBtn.isHidden = !(changedText != "")
            })
            .disposed(by: disposeBag)
        
        /// Clear 버튼 액션
        clearBtn.rx.tap
            .bind {
                textField.text = ""
                clearBtn.isHidden = true
                self.confirmBtn.isActivated = false
                self.confirmBtn.isEnabled = false
            }
            .disposed(by: disposeBag)
    }
    
    /// 이메일 유효성 검사
    private func checkEmailIsValid() {
        emailTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                self.confirmBtn.isActivated = changedText.contains("@") && changedText.contains(".")
                self.confirmBtn.isEnabled = changedText.contains("@") && changedText.contains(".")
            })
            .disposed(by: disposeBag)
    }
    
    private func goResetPWComplete() {
        guard let resetPWCompleteVC = UIStoryboard.init(name: ResetPWCompleteVC.className, bundle: nil).instantiateViewController(withIdentifier: ResetPWCompleteVC.className) as? ResetPWCompleteVC else { return }
        resetPWCompleteVC.email = self.emailTextField.text ?? ""
        self.navigationController?.pushViewController(resetPWCompleteVC, animated: true)
    }
    
    /// 로그아웃 시 UserDefaults 지우는 함수
    private func setRemoveUserdefaultValues() {
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.RefreshToken)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.FirstMajorID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.FirstMajorName)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.SecondMajorID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.SecondMajorName)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.IsReviewed)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.UserID)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.Email)
        UserDefaults.standard.set(nil, forKey: UserDefaults.Keys.PW)
    }
    
    /// 로그인 상태 판단 함수
    private func isLogin() -> Bool {
        return UserDefaults.standard.value(forKey: UserDefaults.Keys.UserID) is Int ? true : false
    }
}

// MARK: - Network
extension ResetPWVC {
    private func requestResetPW(email: String) {
        self.activityIndicator.startAnimating()
        MypageSettingAPI.shared.requestResetPW(email: email) { networkResult in
            switch networkResult {
            case .success:
                self.infoLabel.isHidden = true
                self.activityIndicator.stopAnimating()
                self.isLogin() ? self.requestSignOut() : self.goResetPWComplete()
            case .requestErr:
                self.infoLabel.isHidden = false
                self.activityIndicator.stopAnimating()
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    private func requestSignOut() {
        self.activityIndicator.startAnimating()
        SignAPI.shared.requestSignOut { networkResult in
            switch networkResult {
            case .success:
                self.setRemoveUserdefaultValues()
                self.goResetPWComplete()
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}