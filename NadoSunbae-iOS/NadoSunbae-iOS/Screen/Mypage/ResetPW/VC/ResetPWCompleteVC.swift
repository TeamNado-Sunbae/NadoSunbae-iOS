//
//  ResetPWCompleteVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class ResetPWCompleteVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var goSignInBtn: NadoSunbaeBtn! {
        didSet {
            goSignInBtn.isActivated = true
            goSignInBtn.isEnabled = true
            goSignInBtn.press {
                guard let signInVC = UIStoryboard.init(name: "SignInSB", bundle: nil).instantiateViewController(withIdentifier: SignInVC.className) as? SignInVC else { return }
                self.navigationController?.pushViewController(signInVC, animated: true)
            }
        }
    }
    @IBOutlet weak var resendBtn: UIButton! {
        didSet {
            resendBtn.press {
                self.resendEmail()
            }
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// MARK: - Network
extension ResetPWCompleteVC {
    private func resendEmail() {
        
    }
}
