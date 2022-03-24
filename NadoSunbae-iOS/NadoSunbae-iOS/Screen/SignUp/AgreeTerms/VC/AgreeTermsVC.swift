//
//  AgreeTermsVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/09.
//

import UIKit

class AgreeTermsVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var allCheckView: UIView! {
        didSet {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAllCheckView(gestureRecognizer:)))
            allCheckView.addGestureRecognizer(tapRecognizer)
        }
    }
    @IBOutlet weak var allCheckBtn: UIButton!
    @IBOutlet weak var checkPrivacyBtn: UIButton!
    @IBOutlet weak var checkServiceTermBtn: UIButton!
    @IBOutlet weak var nextBtn: NadoSunbaeBtn!
    
    // MARK: Properties
    var appLink: AppLinkResponseModel?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getAppLink { appLink in
            self.appLink = appLink
        }
    }
    
    // MARK: IBAction
    @IBAction func tapCheckPrivacyBtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        changeAllBtnState()
    }
    
    @IBAction func tapCheckServiceTermBtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        changeAllBtnState()
    }
    
    @IBAction func tapNextBtn(_ sender: UIButton) {
        guard let majorInfoVC = UIStoryboard.init(name: SignUpMajorInfoVC.className, bundle: nil).instantiateViewController(withIdentifier: SignUpMajorInfoVC.className) as? SignUpMajorInfoVC else { return }
        self.navigationController?.pushViewController(majorInfoVC, animated: true)
    }
    
    @IBAction func tapDismissBtn(_ sender: UIButton) {
        guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
        alert.cancelBtn.press {
            self.dismiss(animated: true, completion: nil)
        }
        alert.showNadoAlert(vc: self, message: """
페이지를 나가면
회원가입이 취소돼요.
"""
                            , confirmBtnTitle: "계속 작성", cancelBtnTitle: "나갈래요")
    }
    
    @IBAction func tapOpenTermBtn(_ sender: UIButton) {
        presentSafariVC(link: sender.tag == 0 ? appLink?.personalInformationPolicy ?? "" : appLink?.termsOfService ?? "")
    }
}

// MARK: - UI
extension AgreeTermsVC {
    private func configureUI() {
        allCheckView.layer.borderColor = UIColor.gray0.cgColor
        allCheckView.layer.borderWidth = 1
        allCheckView.makeRounded(cornerRadius: 8.adjusted)
        [allCheckBtn, checkPrivacyBtn, checkServiceTermBtn].forEach { btn in
            btn.setImgByName(name: "btn_check", selectedName: "btn_check_selected")
        }
        nextBtn.isActivated = false
        nextBtn.isEnabled = false
    }
    
    @objc func tapAllCheckView(gestureRecognizer: UIGestureRecognizer) {
        allCheckBtn.isSelected.toggle()
        [checkPrivacyBtn, checkServiceTermBtn].forEach { btn in
            btn?.isSelected = allCheckBtn.isSelected
        }
        nextBtn.isActivated = allCheckBtn.isSelected
        nextBtn.isEnabled = allCheckBtn.isSelected
    }
}

// MARK: - Custom Methods
extension AgreeTermsVC {
    
    /// 모든 버튼의 상태를 체크하여 반영
    private func changeAllBtnState() {
        if checkPrivacyBtn.isSelected == checkServiceTermBtn.isSelected {
            allCheckBtn.isSelected = checkPrivacyBtn.isSelected
        } else {
            allCheckBtn.isSelected = false
        }
        nextBtn.isActivated = allCheckBtn.isSelected
        nextBtn.isEnabled = allCheckBtn.isSelected
    }
    
    private func presentSafariVC(link: String) {
        presentToSafariVC(url: NSURL(string: link)! as URL)
    }
}
