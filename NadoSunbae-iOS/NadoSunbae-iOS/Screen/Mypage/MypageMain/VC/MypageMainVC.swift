//
//  MypageMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class MypageMainVC: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var navTitleBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var userStateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var likeListView: UIView!
    @IBOutlet weak var questionTV: UITableView!
    @IBOutlet weak var questionTVHeight: NSLayoutConstraint!
    @IBOutlet weak var questionEmptyView: UIView!
    
    // MARK: Properties
    var isQuestionable = false
    var questionList = [
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다ㅏㅏㅏㅏ", nickName: "윈터내거", writeTime: "오후 5:33", commentCount: 2, likeCount: 5),
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다", nickName: "윈터내거", writeTime: "오후 5:33", commentCount: 2, likeCount: 5)
    ]
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpTV()
    }
    
    // MARK: @IBAction
    @IBAction func goMypageUser(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: MypageUserVC.className, bundle: nil).instantiateViewController(withIdentifier: MypageUserVC.className) as? MypageUserVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UI
extension MypageMainVC {
    private func configureUI() {
        profileView.makeRounded(cornerRadius: 8.adjusted)
        likeListView.makeRounded(cornerRadius: 8.adjusted)
        questionEmptyView.makeRounded(cornerRadius: 8.adjusted)
        questionTV.makeRounded(cornerRadius: 8.adjusted)
        questionTV.removeSeparatorsOfEmptyCellsAndLastCell()
        
        DispatchQueue.main.async {
            self.questionTVHeight.constant = self.questionTV.contentSize.height
            self.navTitleBottomSpace.constant = 26.adjustedH
            self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true
            self.questionTV.isHidden = self.questionList.isEmpty ? true : false
            if self.isQuestionable {
                self.userStateViewHeight.constant = 0
            } else {
                self.userStateViewHeight.constant = 32.adjusted
            }
        }
    }
}

// MARK: - Custom Methods
extension MypageMainVC {
    private func setUpTV() {
        questionTV.delegate = self
        questionTV.dataSource = self
    }
}
