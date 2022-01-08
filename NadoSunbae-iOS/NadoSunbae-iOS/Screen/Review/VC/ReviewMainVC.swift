//
//  ReviewMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class ReviewMainVC: UIViewController {

    // MARK: IBOutlet
    @IBOutlet weak var naviBarView: UIView!
    
    // MARK: Life Cycle Part
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowToNaviBar()
    }
    
    /// 만들어 둔 HalfModalView 보여주는 함수
    @objc func showHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    // MARK: IBAction
    @IBAction func tapNaviBarBtn(_ sender: Any) {
        showHalfModalView()
    }
}

// MARK: - Extension Part
extension ReviewMainVC {
    
    /// NaviBar dropShadow 설정 함수
    private func addShadowToNaviBar() {
        naviBarView.layer.shadowColor = UIColor(red: 0.898, green: 0.898, blue: 0.91, alpha: 0.16).cgColor
        naviBarView.layer.shadowOffset = CGSize(width: 0, height: 9)
        naviBarView.layer.shadowRadius = 18
        naviBarView.layer.shadowOpacity = 1
        naviBarView.layer.masksToBounds = false
    }
}

extension ReviewMainVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}


