//
//  MypageQuestionListVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/15.
//

import UIKit

class MypageMyPostListVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var segmentView: NadoSegmentView! {
        didSet {
            switch postType {
            case .question:
                break
            case .information:
                segmentView.questionBtn.isActivated = false
                segmentView.questionBtn.isEnabled = true
                segmentView.infoBtn.isActivated = true
                segmentView.infoBtn.isEnabled = false
            }
        }
    }
    @IBOutlet weak var postListTV: UITableView!
    @IBOutlet weak var postListTVHeight: NSLayoutConstraint!
    
    // MARK: Properties
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    var postList: [MypageMyPostModel] = []
    var postType = MypageMyPostType.question
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMypageMyPostList()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTapSegmentBtn()
        setUpTV()
        registerCell()
    }
}

// MARK: - Custom Methods
extension MypageMyPostListVC {
    func setUpTapSegmentBtn() {
        segmentView.infoBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 1)
            }
        }
        segmentView.questionBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 0)
            }
        }
    }
    
    func setUpTV() {
        postListTV.delegate = self
        postListTV.dataSource = self
        postListTV.makeRounded(cornerRadius: 8)
        postListTV.separatorColor = .separatorGray
    }
    
    private func registerCell() {
        postListTV.register(MypagePostListTVC.self, forCellReuseIdentifier: MypagePostListTVC.className)
    }
}

// MARK: - UITableViewDataSource
extension MypageMyPostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MypagePostListTVC.className, for: indexPath) as? MypagePostListTVC else { return UITableViewCell() }
        cell.setMypageMyPostData(data: self.postList[indexPath.row])
        cell.layoutIfNeeded()
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MypageMyPostListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: post type에 따라 분기처리 필요
        let chatSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil)
        guard let chatVC = chatSB.instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
        
        chatVC.questionType = .group
        chatVC.naviStyle = .push
        chatVC.chatPostID = self.postList[indexPath.row].postID
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}

// MARK: - Network
extension MypageMyPostListVC {
    private func getMypageMyPostList() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getMypageMyPostList(postType: self.postType, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageMyPostListModel {
                    self.postList = data.classroomPostList
                    print(self.postList)
                    DispatchQueue.main.async {
                        self.postListTV.reloadData()

                        self.postListTV.isHidden = self.postList.isEmpty ? true : false
//                        self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true

                        self.postListTV.layoutIfNeeded()
                        self.postListTV.rowHeight = UITableView.automaticDimension
                        self.postListTVHeight.constant = self.postListTV.contentSize.height
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
