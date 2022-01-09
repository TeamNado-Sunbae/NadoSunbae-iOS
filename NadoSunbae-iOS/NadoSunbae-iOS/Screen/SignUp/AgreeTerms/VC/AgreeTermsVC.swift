//
//  AgreeTermsVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/09.
//

import UIKit

class AgreeTermsVC: BaseVC {
    
    // MARK: Properties
    @IBOutlet weak var allCheckView: UIView!
    @IBOutlet weak var allCheckBtn: UIButton!
    @IBOutlet weak var checkPrivacyBtn: UIButton!
    @IBOutlet weak var checkServiceTermBtn: UIButton!
    @IBOutlet weak var nextBtn: NadoSunbaeBtn!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Custom Method
    private func configureUI() {
        allCheckView.layer.borderColor = UIColor.gray0.cgColor
        allCheckView.layer.borderWidth = 1
        allCheckView.makeRounded(cornerRadius: 8.adjusted)
        [allCheckBtn, checkPrivacyBtn, checkServiceTermBtn].forEach { btn in
            btn.setImgByName(name: "btn_check", selectedName: "btn_check_selected")
        }
        nextBtn.isActivated = false
    }
    
    private func changeAllBtnState() {
        if checkPrivacyBtn.isSelected == checkServiceTermBtn.isSelected {
            allCheckBtn.isSelected = checkPrivacyBtn.isSelected
        } else {
            allCheckBtn.isSelected = false
        }
        nextBtn.isActivated = allCheckBtn.isSelected
        nextBtn.isEnabled = allCheckBtn.isSelected
    }
    
    // MARK: IBAction
    @IBAction func tapAllCheckBtn(_ sender: UIButton) {
        sender.isSelected.toggle()
        [checkPrivacyBtn, checkServiceTermBtn].forEach { btn in
            btn?.isSelected = sender.isSelected
        }
        nextBtn.isActivated = sender.isSelected
        nextBtn.isEnabled = sender.isSelected
    }
    
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
    
    @IBAction func tapPrevBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapDismissBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapOpenTermBtn(_ sender: UIButton) {
        guard let termDetailVC = self.storyboard?.instantiateViewController(withIdentifier: TermDetailVC.className) as? TermDetailVC else { return }
        termDetailVC.termTag = sender.tag
        self.present(termDetailVC, animated: true, completion: nil)
    }
}
