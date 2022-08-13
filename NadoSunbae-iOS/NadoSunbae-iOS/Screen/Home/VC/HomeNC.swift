//
//  HomeNC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/07/11.
//

import UIKit

final class HomeNC: BaseNC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([HomeVC()], animated: true)
    }
}
