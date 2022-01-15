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
    @IBOutlet weak var userStateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var questionTableVIewHeight: NSLayoutConstraint!
    @IBOutlet weak var floatingBtn: UIButton!
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.configureTitleLabel(title: "선배 닉네임")
            navView.rightActivateBtn.isActivated = false
            navView.dismissBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: Properties
    var isQuestionable = false
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpTV()
    }
    
    // MARK: @IBAction
    @IBAction func tapSortBtn(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let latestAction = UIAlertAction(title: "최신순", style: .default, handler: nil)
        let moreLikeAction = UIAlertAction(title: "좋아요순", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        [latestAction, moreLikeAction, cancelAction].forEach { action in
            optionMenu.addAction(action)
        }

        self.present(optionMenu, animated: true, completion: nil)
    }
    
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
            if self.isQuestionable {
                self.floatingBtn.imageView?.image = UIImage(named: "btnFloating")
                self.userStateView.alpha = 0
                self.userStateViewHeight.constant = 0
            } else {
                self.floatingBtn.imageView?.image = UIImage(named: "btnFloating_x")!
            }
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
