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
    @IBOutlet weak var questionTV: UITableView!
    @IBOutlet weak var questionTVHeight: NSLayoutConstraint!
    @IBOutlet weak var floatingBtn: UIButton!
    @IBOutlet weak var questionEmptyView: UIView!
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
    var isQuestionable = true
    var questionList = [
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다ㅏㅏㅏㅏ", nickName: "윈터내거", writeTime: "2022-01-18T19:00:42.040Z", commentCount: 2, likeCount: 5),
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다", nickName: "윈터내거", writeTime: "2022-01-18T19:00:42.040Z", commentCount: 2, likeCount: 5)
    ]
    
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
        profileView.makeRounded(cornerRadius: 8.adjusted)
        majorReviewView.makeRounded(cornerRadius: 8.adjusted)
        questionTV.makeRounded(cornerRadius: 8.adjusted)
        questionTV.removeSeparatorsOfEmptyCellsAndLastCell()
        questionEmptyView.makeRounded(cornerRadius: 8.adjusted)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        DispatchQueue.main.async {
            self.questionTVHeight.constant = self.questionTV.contentSize.height
            self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true
            self.questionTV.isHidden = self.questionList.isEmpty ? true : false
            
            if self.isQuestionable {
                self.floatingBtn.imageView?.image = UIImage(named: "btnFloating")
                self.userStateViewHeight.constant = 0
            } else {
                self.floatingBtn.imageView?.image = UIImage(named: "btnFloating_x")!
                self.userStateViewHeight.constant = 32.adjusted
            }
        }
    }
}

// MARK: - Custom Methods
extension MypageUserVC {
    private func setUpTV() {
        questionTV.delegate = self
        questionTV.dataSource = self
    }
}
