//
//  ReviewWriteVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/13.
//

import UIKit

class ReviewWriteVC: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var reviewWriteNaviBar: NadoSunbaeNaviBar!
    @IBOutlet weak var essentialTagView: UIView!
    @IBOutlet weak var choiceTagView: UIView!
    @IBOutlet weak var majorNameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNaviUI()
        configureTagViewUI()
        configureMajorNameViewUI()
    }
}

// MARK: - UI
extension ReviewWriteVC {
    func customNaviUI() {
        reviewWriteNaviBar.setUpNaviStyle(state: .dismissWithNadoBtn)
        reviewWriteNaviBar.configureTitleLabel(title: "후기작성")
    }
    
    func configureTagViewUI() {
        essentialTagView.layer.cornerRadius = 4
        choiceTagView.layer.cornerRadius = 4
    }
    
    func configureMajorNameViewUI() {
        majorNameView.layer.cornerRadius = 8
        majorNameView.layer.borderColor = UIColor.gray0.cgColor
        majorNameView.layer.borderWidth = 1
    }
}
