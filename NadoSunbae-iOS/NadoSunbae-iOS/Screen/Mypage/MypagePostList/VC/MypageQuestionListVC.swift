//
//  MypageQuestionListVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/15.
//

import UIKit

class MypageQuestionListVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var questionSegmentView: NadoSegmentView! {
        didSet {
            questionSegmentView.backgroundColor = .bgGray
        }
    }
    @IBOutlet weak var questionTV: UITableView!
    @IBOutlet weak var questionTVHeight: NSLayoutConstraint!
    
    // MARK: Properties
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    var questionList: [MypageMyPostModel] = []
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTapInfoBtn()
        setUpTV()
        registerCell()
    }
}

// MARK: Custom Methods
extension MypageQuestionListVC {
    func setUpTapInfoBtn() {
        questionSegmentView.infoBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 1)
            }
        }
    }
    
    func setUpTV() {
        questionTV.delegate = self
        questionTV.dataSource = self
    }
    
    private func registerCell() {
        questionTV.register(MypagePostListTVC.self, forCellReuseIdentifier: MypagePostListTVC.className)
    }
}

// MARK: UITableViewDataSource
extension MypageQuestionListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MypagePostListTVC.className, for: indexPath) as? MypagePostListTVC else { return UITableViewCell() }
        cell.setMypageMyPostData(data: self.questionList[indexPath.row])
        cell.layoutIfNeeded()
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MypageQuestionListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil)
        guard let chatVC = chatSB.instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
        
        chatVC.questionType = .group
        chatVC.naviStyle = .push
        chatVC.chatPostID = self.questionList[indexPath.row].postID
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

