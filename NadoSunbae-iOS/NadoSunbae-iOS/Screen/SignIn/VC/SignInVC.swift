//
//  SignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/08.
//
// TODO: TextField clear Btn 에셋 나오면 수정

import UIKit

class SignInVC: BaseVC {
    // MARK: Properties
    @IBOutlet weak var emailTextField: NadoTextField!
    @IBOutlet weak var pwTextField: NadoTextField!
    @IBOutlet weak var signInBtn: NadoSunbaeBtn!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private func configureUI() {
        infoLabel.isHidden = true
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
    }
    
    @IBAction func tapFindPWBtn(_ sender: Any) {
    }
    
    @IBAction func tapContactBtn(_ sender: Any) {
    }
}
