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
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: Custom Method
//    @IBDesignable
    private func configureUI() {
        allCheckView.layer.borderColor = UIColor.gray0.cgColor
        allCheckView.layer.borderWidth = 1
        allCheckView.makeRounded(cornerRadius: 8.adjusted)
        allCheckBtn.setImgByName(name: "btn_check", selectedName: "btn_check_selected")
    }
    
    // MARK: IBAction
    @IBAction func tapAllCheckBtn(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    

}
