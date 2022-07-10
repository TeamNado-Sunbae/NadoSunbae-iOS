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
            segmentView.firstBtn.setTitleWithStyle(title: "질문", size: 14.0)
            segmentView.secondBtn.setTitleWithStyle(title: "정보", size: 14.0)
            segmentView.thirdBtn.isHidden = true
            
            switch postType {
            case .question:
                break
            case .information:
                segmentView.firstBtn.isActivated = false
                segmentView.firstBtn.isEnabled = true
                segmentView.secondBtn.isActivated = true
                segmentView.secondBtn.isEnabled = false
            }
        }
    }
    @IBOutlet weak var postListTV: UITableView!
    @IBOutlet weak var postListTVHeight: NSLayoutConstraint!
    @IBOutlet weak var postEmptyView: UIView! {
        didSet {
            postEmptyView.makeRounded(cornerRadius: 8.adjusted)
        }
    }
    @IBOutlet weak var postEmptyLabel: UILabel!
    
    // MARK: Properties
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    var postList: [MypageMyPostModel] = []
    var answerList: [MypageMyAnswerModel] = []
    var postType = MypageMyPostType.question
    var isPostOrAnswer = true
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPostOrAnswer ? getMypageMyPostList() : getMypageMyAnswerList()
        hideTabbar()
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
    private func setUpTapSegmentBtn() {
        segmentView.secondBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 1)
            }
        }
        segmentView.firstBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 0)
            }
        }
    }
    
    private func setUpTV() {
        postListTV.delegate = self
        postListTV.dataSource = self
        postListTV.makeRounded(cornerRadius: 8.adjusted)
        postListTV.separatorColor = .separatorGray
        postListTV.isScrollEnabled = false
    }
    
    private func registerCell() {
        postListTV.register(MypagePostListTVC.self, forCellReuseIdentifier: MypagePostListTVC.className)
    }
    
    private func setEmptyLabel() {
        switch postType {
        case .information:
            postEmptyLabel.text = "등록된 정보글이 없습니다."
        case .question:
            postEmptyLabel.text = "등록된 질문글이 없습니다."
        }
    }
}

// MARK: - UITableViewDataSource
extension MypageMyPostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPostOrAnswer ? postList.count : answerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MypagePostListTVC.className, for: indexPath) as? MypagePostListTVC else { return UITableViewCell() }
        isPostOrAnswer ? cell.setMypageMyPostData(data: self.postList[indexPath.row]) : cell.setMypageMyAnswerData(data: self.answerList[indexPath.row])
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
        switch postType {
        case .question:
            
            /// 유저의 권한 분기처리
            self.divideUserPermission() {
                self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                    questionDetailVC.questionType = .group
                    questionDetailVC.naviStyle = .push
                    
                    if self.isPostOrAnswer {
                        questionDetailVC.questionType = self.postList[indexPath.row].postTypeID == 3 ? .group : .personal
                    } else {
                        questionDetailVC.questionType = self.answerList[indexPath.row].postTypeID == 3 ? .group : .personal
                    }
                    
                    questionDetailVC.postID = self.isPostOrAnswer ? self.postList[indexPath.row].postID : self.answerList[indexPath.row].postID
                }
            }
        case .information:
            
            /// 유저의 권한 분기처리
            self.divideUserPermission() {
                self.navigator?.instantiateVC(destinationViewControllerType: InfoDetailVC.self, useStoryboard: true, storyboardName: Identifiers.InfoSB, naviType: .push) { infoDetailVC in
                    infoDetailVC.hidesBottomBarWhenPushed = true
                    infoDetailVC.postID = self.isPostOrAnswer ? self.postList[indexPath.row].postID : self.answerList[indexPath.row].postID
                }
            }
        }
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
                    DispatchQueue.main.async {
                        self.postListTV.reloadData()

                        self.postListTV.isHidden = self.postList.isEmpty ? true : false
                        self.postEmptyView.isHidden = self.postList.isEmpty ? false : true
                        self.setEmptyLabel()
                        
                        self.postListTV.layoutIfNeeded()
                        self.postListTV.rowHeight = UITableView.automaticDimension
                        self.postListTVHeight.constant = self.postListTV.contentSize.height
                        self.activityIndicator.stopAnimating()
                    }
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMypageMyPostList()
                    }
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    private func getMypageMyAnswerList() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getMypageMyAnswerList(postType: self.postType, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageMyAnswerListModel {
                    self.answerList = data.classroomPostListByMyCommentList
                    DispatchQueue.main.async {
                        self.postListTV.reloadData()

                        self.postListTV.isHidden = self.answerList.isEmpty ? true : false
                        self.postEmptyView.isHidden = self.answerList.isEmpty ? false : true
                        self.setEmptyLabel()

                        self.postListTV.layoutIfNeeded()
                        self.postListTV.rowHeight = UITableView.automaticDimension
                        self.postListTVHeight.constant = self.postListTV.contentSize.height
                        self.activityIndicator.stopAnimating()
                    }
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMypageMyAnswerList()
                    }
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                self.activityIndicator.stopAnimating()
            }
        })
    }
}
