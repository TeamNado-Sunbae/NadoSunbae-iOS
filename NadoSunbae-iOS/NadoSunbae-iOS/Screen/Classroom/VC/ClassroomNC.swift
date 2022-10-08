//
//  ClassroomNC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit

class ClassroomNC: BaseNC {

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        
        let classroomVC = ClassroomVC()
//        classroomVC.reactor = ClassroomReactor()

        self.setViewControllers([classroomVC], animated: true)
    }
}
