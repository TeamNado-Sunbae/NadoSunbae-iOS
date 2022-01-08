//
//  SignInVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/08.
//

import UIKit

class SignInVC: BaseVC {
    // MARK: Properties
    @IBOutlet weak var emailTextField: NadoTextField!
    @IBOutlet weak var pwTextField: NadoTextField!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private func configureUI() {
        
    }
    
    // MARK: IBAction
    @IBAction func tapEmailClearBtn(_ sender: Any) {
        emailTextField.text = ""
    }
    
    @IBAction func tapPWClearBtn(_ sender: Any) {
        pwTextField.text = ""
    }
    
    @IBAction func tapSignUpBtn(_ sender: Any) {
    }
    
    @IBAction func tapFindPWBtn(_ sender: Any) {
    }
    
    @IBAction func tapContactBtn(_ sender: Any) {
    }
}
