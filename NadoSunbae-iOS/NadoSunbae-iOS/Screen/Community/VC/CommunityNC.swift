//
//  CommunityNC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/07/11.
//

import UIKit

class CommunityNC: BaseNC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        
        let communityVC = CommunityMainVC()
        communityVC.reactor = CommunityMainReactor()
        
        self.setViewControllers([communityVC], animated: true)
    }
}
