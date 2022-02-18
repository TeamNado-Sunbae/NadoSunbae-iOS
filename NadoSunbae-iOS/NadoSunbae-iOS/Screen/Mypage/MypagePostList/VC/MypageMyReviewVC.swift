//
//  MypageMyReviewVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/19.
//

import UIKit

class MypageMyReviewVC: UIViewController {

    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.configureTitleLabel(title: "학과후기")
            navView.setUpNaviStyle(state: .backDefault)
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
