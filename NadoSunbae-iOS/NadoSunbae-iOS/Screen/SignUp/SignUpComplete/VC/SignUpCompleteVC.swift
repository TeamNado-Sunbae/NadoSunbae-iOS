//
//  SignUpCompleteVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/12.
//

import UIKit

class SignUpCompleteVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var enterBtn: NadoSunbaeBtn!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Custom Method
    private func configureUI() {
        messageLabel.text = """
후배들을 위한 학과 후기를 남기고
다른 선배들에게 도움을 받으세요.
"""
        enterBtn.isActivated = true
    }
    
    // MARK: IBAction
    

}
