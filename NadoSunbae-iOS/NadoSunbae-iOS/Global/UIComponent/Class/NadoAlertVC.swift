//
//  NadoAlert.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/09.
//

import UIKit
import SnapKit
import Then

enum NadoAlertType {
    
    /// confirmBtn, cancelBtn 사용
    case withDoubleBtn
    
    /// confirmBtn만 사용
    case withSingleBtn
    
    /// confirmBtn, cancelBtn 사용
    case withTextField
}

class NadoAlertVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmBtn: NadoSunbaeBtn!
    @IBOutlet weak var cancelBtn: NadoSunbaeBtn!
    var textField = NadoTextField().then {
        $0.textAlignment = .center
        $0.layer.borderColor = UIColor.gray2.cgColor
    }
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Custom Method
    private func configureUI() {
        containerView.layer.cornerRadius = 8.adjusted
        containerView.makeRounded(cornerRadius: 8.adjusted)
        confirmBtn.isActivated = true
        cancelBtn.isActivated = false
        cancelBtn.isEnabled = true
        messageLabel.setLineSpacing(lineSpacing: 5)
        messageLabel.textAlignment = .center
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    func showNadoAlert(vc: UIViewController, message: String, confirmBtnTitle: String, cancelBtnTitle: String, type: NadoAlertType? = .withDoubleBtn) {
        messageLabel.text = message
        switch type {
        case .withSingleBtn:
            DispatchQueue.main.async {
                self.confirmBtn.setTitleWithStyle(title: confirmBtnTitle, size: 14, weight: .bold)
                self.cancelBtn.removeFromSuperview()
                self.confirmBtn.snp.makeConstraints {
                    $0.leading.equalTo(self.containerView.snp.leading).offset(14)
                    $0.trailing.equalTo(self.containerView.snp.trailing).offset(-14)
                    $0.bottom.equalTo(self.containerView.snp.bottom).offset(-14)
                    $0.height.equalTo(self.containerView.frame.height * 0.3095)
                }
            }
        case .withTextField:
            DispatchQueue.main.async {
                self.containerView.removeFromSuperview()
                self.view.addSubview(self.containerView)
                self.containerView.addSubview(self.textField)
                self.containerView.snp.makeConstraints {
                    $0.height.equalTo(self.view.frame.height * 0.258620)
                    $0.width.equalTo(self.view.frame.width * 0.704)
                    $0.center.equalTo(self.view.snp.center)
                }
                self.messageLabel.snp.makeConstraints {
                    $0.leading.equalTo(self.containerView.snp.leading).offset(24)
                    $0.trailing.equalTo(self.containerView.snp.trailing).offset(-24)
                    $0.top.equalTo(self.containerView.snp.top).offset(12)
                    $0.bottom.equalTo(self.textField.snp.top).offset(-12)
                }
                self.textField.snp.makeConstraints {
                    $0.leading.equalTo(self.containerView.snp.leading).offset(14)
                    $0.trailing.equalTo(self.containerView.snp.trailing).offset(-14)
                    $0.bottom.equalTo(self.confirmBtn.snp.top).offset(-24)
                    $0.height.equalTo(48.adjustedH)
                }
                self.cancelBtn.snp.makeConstraints {
                    $0.leading.equalTo(self.containerView.snp.leading).offset(14)
                    $0.trailing.equalTo(self.confirmBtn.snp.leading).offset(-12)
                    $0.bottom.equalTo(self.containerView.snp.bottom).offset(-14)
                    $0.height.equalTo(52.adjustedH)
                }
                self.confirmBtn.snp.makeConstraints {
                    $0.height.equalTo(self.cancelBtn.snp.height)
                    $0.width.equalTo(self.cancelBtn.snp.width)
                    $0.trailing.equalTo(self.containerView.snp.trailing).offset(-14)
                    $0.bottom.equalTo(self.containerView.snp.bottom).offset(-14)
                }
                self.confirmBtn.setTitleWithStyle(title: confirmBtnTitle, size: 14, weight: .bold)
                self.cancelBtn.setTitleWithStyle(title: cancelBtnTitle, size: 14, weight: .bold)
                self.textField.addRightPadding(16)
                self.textField.placeholder = "비밀번호 입력"
                self.textField.textContentType = .password
                self.textField.isSecureTextEntry = true
            }
        default:
            DispatchQueue.main.async {
                self.confirmBtn.setTitleWithStyle(title: confirmBtnTitle, size: 14, weight: .bold)
                self.cancelBtn.setTitleWithStyle(title: cancelBtnTitle, size: 14, weight: .bold)
            }
        }

        vc.present(self, animated: true, completion: nil)
    }
    
    // MARK: IBAction
    @IBAction func tapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapConfirmBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
