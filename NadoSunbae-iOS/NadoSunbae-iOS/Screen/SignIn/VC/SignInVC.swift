//
//  SignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/08.
//
// TODO: TextField clear Btn 에셋 나오면 수정

import UIKit
import RxSwift
import RxCocoa

class SignInVC: BaseVC {
    // MARK: Properties
    @IBOutlet weak var emailTextField: NadoTextField!
    @IBOutlet weak var pwTextField: NadoTextField!
    @IBOutlet weak var signInBtn: NadoSunbaeBtn!
    @IBOutlet weak var infoLabel: UILabel!
    
    let disposeBag = DisposeBag()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Private Methods
    private func configureUI() {
        infoLabel.isHidden = true
        signInBtn.isEnabled = false
        checkEmailIsValid()
    }
    
    /// 이메일 유효성 검사
    private func checkEmailIsValid() {
        emailTextField.rx.text
            .orEmpty
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                if changedText.contains("@") && changedText.contains(".") {
                    self.signInBtn.isActivated = true
                    self.signInBtn.isEnabled = true
                    self.infoLabel.isHidden = true
                } else {
                    self.infoLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: IBAction
    @IBAction func tapEmailClearBtn(_ sender: Any) {
        emailTextField.text = ""
    }
    
    @IBAction func tapPWClearBtn(_ sender: Any) {
        pwTextField.text = ""
    }
    
    @IBAction func tapSignInBtn(_ sender: Any) {
        let sb = NadoSunbaeTBC()
        sb.modalPresentationStyle = .fullScreen
        self.present(sb, animated: true, completion: nil)
    }
    
    @IBAction func tapSignUpBtn(_ sender: Any) {
        guard let vc = UIStoryboard.init(name: AgreeTermsVC.className, bundle: nil).instantiateViewController(withIdentifier: AgreeTermsVC.className) as? AgreeTermsVC else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapFindPWBtn(_ sender: Any) {
    }
    
    @IBAction func tapContactBtn(_ sender: Any) {
    }
}
