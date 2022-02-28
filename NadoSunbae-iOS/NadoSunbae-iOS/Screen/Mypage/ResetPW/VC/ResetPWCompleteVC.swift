//
//  ResetPWCompleteVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class ResetPWCompleteVC: BaseVC {
    
    @IBOutlet weak var goSignInBtn: NadoSunbaeBtn! {
        didSet {
            goSignInBtn.isActivated = true
            goSignInBtn.isEnabled = true
            goSignInBtn.press {
                // TODO: 로그아웃 요청
            }
        }
    }
    @IBOutlet weak var resendBtn: UIButton! {
        didSet {
            resendBtn.press {
                // TODO: 재전송 요청
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
