//
//  ReviewMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class ReviewMainVC: UIViewController {

    @IBOutlet weak var naviBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowToNaviBar()
    }
}

extension ReviewMainVC {
    private func addShadowToNaviBar() {
        naviBarView.layer.shadowColor = UIColor(red: 0.898, green: 0.898, blue: 0.91, alpha: 0.16).cgColor
        naviBarView.layer.shadowOffset = CGSize(width: 0, height: 9)
        naviBarView.layer.shadowRadius = 18
        naviBarView.layer.shadowOpacity = 1
        naviBarView.layer.masksToBounds = false
    }
}


