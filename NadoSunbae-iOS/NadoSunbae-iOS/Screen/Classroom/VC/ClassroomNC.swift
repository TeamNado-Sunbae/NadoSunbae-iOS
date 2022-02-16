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
        
        guard let classroomMainVC = self.storyboard?.instantiateViewController(withIdentifier: ClassroomMainVC.className) as? ClassroomMainVC else { return }
        self.setViewControllers([classroomMainVC], animated: true)
    }
}
