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
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var confirmBtn: NadoSunbaeBtn!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabbar()
    }
}
