//
//  ClassroomMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then

class ClassroomMainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
}

// MARK: - UI
extension ClassroomMainVC {
    private func configureUI() {
        
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ClassroomMainVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
