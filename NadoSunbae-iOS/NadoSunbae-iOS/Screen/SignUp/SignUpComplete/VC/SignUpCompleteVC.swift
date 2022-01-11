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
    @IBAction func tapEnterBtn(_ sender: UIButton) {
        // TODO: 회원가입 성공 시 이전 화면에서 메일/비번 정보 UserDefault에 저장, 여기에서 자동로그인 구현
        let vc = NadoSunbaeTBC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
