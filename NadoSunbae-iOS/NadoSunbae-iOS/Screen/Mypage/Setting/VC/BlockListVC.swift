//
//  BlockListVC.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/28.
//

import UIKit

class BlockListVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.configureTitleLabel(title: "차단 사용자 목록")
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
