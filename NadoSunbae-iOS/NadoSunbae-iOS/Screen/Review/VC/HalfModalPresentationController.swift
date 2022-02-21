//
//  HalfModalPresentationController.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit

class HalfModalPresentationController: UIPresentationController {
    
    // MARK: Properties
    let backView = UIView()
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    /// 뒷 배경 블랙 블러 처리
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        backView.backgroundColor = UIColor.black
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        backView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.backView.isUserInteractionEnabled = true
        self.backView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// 보여질 하프 모달 뷰 프레임 설정(높이 180 ~ 632 슬라이드, 보여지는 높이는 632)
    override var frameOfPresentedViewInContainerView: CGRect {
        CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 180/812),
               size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
                            632/812))
    }
    
    /// present 시작할 때
    override func presentationTransitionWillBegin() {
        self.backView.alpha = 0
        self.containerView?.addSubview(backView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.backView.alpha = 0.5
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
    }
    
    /// dismiss 시작될 때
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.backView.alpha = 0
        }, completion: { (UIViewControllerTransitionCoordinatorContext) in
            self.backView.removeFromSuperview()
        })
    }
    
    /// 하프 모달 뷰 radius 설정
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.makeRounded(cornerRadius: 8.adjusted)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
        backView.frame = containerView!.bounds
    }
    
    /// dismiss처리
    @objc func dismissController(){
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}

