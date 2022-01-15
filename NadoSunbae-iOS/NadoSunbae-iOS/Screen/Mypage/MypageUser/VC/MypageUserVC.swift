//
//  MyPageUserVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/14.
//

import UIKit

class MypageUserVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var majorReviewView: UIView!
    @IBOutlet weak var userStateView: UIView!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var questionTableVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.configureTitleLabel(title: "선배 닉네임")
            navView.rightActivateBtn.isActivated = false
            navView.rightActivateBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Properties
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpTV()
    }
    
    // MARK: @IBAction

}

// MARK: - UI
extension MypageUserVC {
    private func configureUI() {
        navigationBackSwipeMotion()
        self.profileView.makeRounded(cornerRadius: 8.adjusted)
        self.majorReviewView.makeRounded(cornerRadius: 8.adjusted)
        self.questionTableView.makeRounded(cornerRadius: 8.adjusted)
        DispatchQueue.main.async {
            self.questionTableVIewHeight.constant = self.questionTableView.contentSize.height
        }
    }
    
    /// 네비게이션 백 스와이프 모션으로도 뒤로가기가 가능하도록 만들어주는 함수
    private func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: - Custom Methods
extension MypageUserVC {
    private func setUpTV() {
        questionTableView.delegate = self
        questionTableView.dataSource = self
    }
}
