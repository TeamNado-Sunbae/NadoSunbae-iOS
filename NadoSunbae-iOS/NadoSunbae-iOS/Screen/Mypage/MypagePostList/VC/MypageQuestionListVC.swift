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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserPersonalQuestionList()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTapInfoBtn()
        setUpTV()
        registerCell()
    }
}

// MARK: - Custom Methods
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
        questionTV.makeRounded(cornerRadius: 8)
        questionTV.separatorColor = .separatorGray
    }
    
    private func registerCell() {
        questionTV.register(MypagePostListTVC.self, forCellReuseIdentifier: MypagePostListTVC.className)
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - Network
extension MypageQuestionListVC {
    private func getUserPersonalQuestionList() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getMypageMyPostList(postType: .question, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageMyPostListModel {
                    self.questionList = data.classroomPostList
                    print(self.questionList)
                    DispatchQueue.main.async {
                        self.questionTV.reloadData()

                        self.questionTV.isHidden = self.questionList.isEmpty ? true : false
//                        self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true

                        self.questionTV.layoutIfNeeded()
                        self.questionTV.rowHeight = UITableView.automaticDimension
                        self.questionTVHeight.constant = self.questionTV.contentSize.height
                        self.activityIndicator.stopAnimating()
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                self.activityIndicator.stopAnimating()
            }
        })
    }
}
