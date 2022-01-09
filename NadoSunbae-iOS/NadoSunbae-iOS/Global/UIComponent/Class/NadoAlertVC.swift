//
//  NadoAlert.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/09.
//

import UIKit

class NadoAlertVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var confirmBtn: NadoSunbaeBtn!
    @IBOutlet weak var cancelBtn: NadoSunbaeBtn!
    
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
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    func showNadoAlert(vc: UIViewController, message: String, confirmBtnTitle: String, cancelBtnTitle: String) {
        messageLabel.text = message
        DispatchQueue.main.async {
            self.confirmBtn.setTitleWithStyle(title: confirmBtnTitle, size: 14, weight: .bold)
            self.cancelBtn.setTitleWithStyle(title: cancelBtnTitle, size: 14, weight: .bold)
        }
        view.present(self, animated: true, completion: nil)
    }
    
    // MARK: IBAction
    @IBAction func tapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapConfirmBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
