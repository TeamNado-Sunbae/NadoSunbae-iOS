//
//  MypagePostListVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/14.
//

import UIKit
import Then
import SnapKit

class MypagePostListVC: BaseVC {
    
    // MARK: Components
    private lazy var naviView = NadoSunbaeNaviBar().then {
        $0.configureTitleLabel(title: isPostOrAnswer ? "내가 쓴 글" : "내가 쓴 답글")
        $0.setUpNaviStyle(state: .backDefault)
        $0.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private let postListSegmentControl = NadoSegmentedControl(items: ["1:1 질문", "커뮤니티"])
    private let postListSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    private let postListTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.contentInset = .zero
        $0.separatorColor = .gray0
        $0.isScrollEnabled = false
        $0.estimatedRowHeight = 121
        $0.rowHeight = UITableView.automaticDimension
    }
    private let emptyView = NadoEmptyView().then {
        $0.makeRounded(cornerRadius: 16)
    }
    
    // MARK: Properties
    var isPostOrAnswer = true
    var isPersonalQuestionOrCommunity = true
    private var personalQuestionData: [PostListResModel] = []
    private var communityData: [PostListResModel] = []
    private var personalQuestionDataForAnswer: [MypageMyAnswerListModel.PostList] = []
    private var communityDataForAnswer: [MypageMyAnswerListModel.PostList] = []
    private let contentSizeObserverKeyPath = "contentSize"

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeScreenAnalyticsForMyPostList()
        configureUI()
        setPostListTV()
        setSegmentedControl()
        isPostOrAnswer ? getMypageMyPersonalQuestionList() : getMypageMyAnswerList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.postListTV.removeObserver(self, forKeyPath: contentSizeObserverKeyPath)
    }
    
    private func setPostListTV() {
        postListTV.dataSource = self
        postListTV.delegate = self
        
        postListTV.register(CommunityTVC.self, forCellReuseIdentifier: CommunityTVC.className)
        postListTV.register(EntireQuestionListTVC.self, forCellReuseIdentifier: EntireQuestionListTVC.className)
        
        postListTV.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    private func setSegmentedControl() {
        postListSegmentControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        
        postListSegmentControl.selectedSegmentIndex = 0
        didChangeValue(segment: postListSegmentControl)
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        isPersonalQuestionOrCommunity = postListSegmentControl.selectedSegmentIndex == 0
        isPostOrAnswer ? (isPersonalQuestionOrCommunity ?  getMypageMyPersonalQuestionList() : getMypageCommunityPostList()) : getMypageMyAnswerList()
    }
    
    private func makeScreenAnalyticsForMyPostList() {
        if isPostOrAnswer {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MyPostListVC")
        } else {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MyAnswerListVC")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == contentSizeObserverKeyPath) {
            if let newValue = change?[.newKey] {
                let newSize  = newValue as! CGSize
                self.postListTV.layoutIfNeeded()
                self.postListTV.snp.updateConstraints {
                    $0.height.equalTo(newSize.height)
                }
            }
        }
    }
    
    /// emptyView의 Text를 분기처리하여 설정하는 메서드
    func setEmptyView(data: Array<Any>) {
        if data.isEmpty {
            emptyView.isHidden = false
            if isPostOrAnswer {
                if isPersonalQuestionOrCommunity {
                    emptyView.setTitleLabel(titleText: "내가 쓴 1:1 질문이 없습니다.")
                } else {
                    emptyView.setTitleLabel(titleText: "내가 쓴 커뮤니티 글이 없습니다.")
                }
            } else {
                if isPersonalQuestionOrCommunity {
                    emptyView.setTitleLabel(titleText: "내가 쓴 1:1 질문 답글이 없습니다.")
                } else {
                    emptyView.setTitleLabel(titleText: "내가 쓴 커뮤니티 답글이 없습니다.")
                }
            }
        } else {
            emptyView.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource
extension MypagePostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPostOrAnswer {
            return (isPersonalQuestionOrCommunity ? personalQuestionData.count : communityData.count)
        } else {
            return (isPersonalQuestionOrCommunity ? personalQuestionDataForAnswer.count : communityDataForAnswer.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isPostOrAnswer {
            if isPersonalQuestionOrCommunity {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className, for: indexPath) as? EntireQuestionListTVC else { return EntireQuestionListTVC() }
                cell.setPostData(data: personalQuestionData[indexPath.row])
                cell.layoutSubviews()
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath) as? CommunityTVC else { return CommunityTVC() }
                cell.setCommunityData(data: communityData[indexPath.row])
                return cell
            }
        } else {
            if isPersonalQuestionOrCommunity {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className, for: indexPath) as? EntireQuestionListTVC else { return EntireQuestionListTVC() }
                let data = personalQuestionDataForAnswer[indexPath.row]
                // TODO: MypageResModel에도 isAuthorized값 넣어달라고 요청하기.
                cell.setPostData(data: PostListResModel(postID: data.id, type: data.type, title: data.title, content: data.content, createdAt: data.createdAt, majorName: data.majorName, writer: CommunityWriter(writerID: data.writer.id, nickname: data.writer.nickname), isAuthorized: true, commentCount: data.commentCount, like: data.like))
                cell.layoutSubviews()
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath) as? CommunityTVC else { return CommunityTVC() }
                let data = communityDataForAnswer[indexPath.row]
                cell.setCommunityData(data: PostListResModel(postID: data.id, type: data.type, title: data.title, content: data.content, createdAt: data.createdAt, majorName: data.majorName, writer: CommunityWriter(writerID: data.writer.id, nickname: data.writer.nickname), isAuthorized: true, commentCount: data.commentCount, like: data.like))
                return cell
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension MypagePostListVC: UITableViewDelegate {
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isPersonalQuestionOrCommunity {
            self.divideUserPermission() {
                self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                    questionDetailVC.hidesBottomBarWhenPushed = true
                    questionDetailVC.naviStyle = .push
                    questionDetailVC.postID = self.personalQuestionData[indexPath.row].postID
                }
            }
        } else {
            self.navigator?.instantiateVC(destinationViewControllerType: CommunityPostDetailVC.self, useStoryboard: true, storyboardName: "CommunityPostDetailSB", naviType: .push) { postDetailVC in
                postDetailVC.postID = self.communityData[indexPath.row].postID
                postDetailVC.hidesBottomBarWhenPushed = true
            }
        }
    }
}

extension MypagePostListVC: SendSegmentStateDelegate {
    func sendSegmentClicked(index: Int) {
        if index == 0 {
            if isPostOrAnswer {
                getMypageMyPersonalQuestionList()
                makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyPostList-PersonalQuestionVC")
            } else {
                makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyAnswerList-PersonalQuestionVC")
            }
        } else {
            if isPostOrAnswer {
                getMypageCommunityPostList()
                makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyPostList-CommunityVC")
            } else {
                makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyAnswerList-CommunityVC")
            }
        }
    }
}

// MARK: - Network
extension MypagePostListVC {
    private func getMypageMyPersonalQuestionList() {
        self.activityIndicator.startAnimating()
        self.postListTV.addObserver(self, forKeyPath: contentSizeObserverKeyPath, options: .new, context: nil)
        MypageAPI.shared.getMypageMyPostList(postType: MypageMyPostType.personalQuestion, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageMyPostListModel {
                    self.personalQuestionData = data.postList
                    self.activityIndicator.stopAnimating()
                    self.postListTV.reloadData()
                    self.setEmptyView(data: data.postList)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMypageMyPersonalQuestionList()
                    }
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                self.activityIndicator.stopAnimating()
            }
        })
    }
    
    private func getMypageCommunityPostList() {
        self.activityIndicator.startAnimating()
        self.postListTV.addObserver(self, forKeyPath: contentSizeObserverKeyPath, options: .new, context: nil)
        MypageAPI.shared.getMypageMyPostList(postType: MypageMyPostType.community, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageMyPostListModel {
                    self.communityData = data.postList
                    self.activityIndicator.stopAnimating()
                    self.postListTV.reloadData()
                    self.setEmptyView(data: data.postList)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMypageCommunityPostList()
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
        self.postListTV.addObserver(self, forKeyPath: contentSizeObserverKeyPath, options: .new, context: nil)
        MypageAPI.shared.getMypageMyAnswerList(postType: isPersonalQuestionOrCommunity ? MypageMyPostType.personalQuestion : MypageMyPostType.community, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageMyAnswerListModel {
                    if self.isPersonalQuestionOrCommunity {
                        self.personalQuestionDataForAnswer = data.postList
                    } else {
                        self.communityDataForAnswer = data.postList
                    }
                    self.activityIndicator.stopAnimating()
                    self.postListTV.reloadData()
                    self.setEmptyView(data: data.postList)
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

// MARK: - UI
extension MypagePostListVC {
    private func configureUI() {
        view.backgroundColor = .bgGray
        
        view.addSubviews([naviView, postListSegmentControl, postListSV, emptyView])
        postListSV.addSubview(contentView)
        contentView.addSubviews([postListTV])
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        postListSegmentControl.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(36)
            $0.width.equalTo(160)
        }
        
        postListSV.snp.makeConstraints {
            $0.top.equalTo(postListSegmentControl.snp.bottom).offset(18)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.top.bottom.equalToSuperview()
        }
        
        postListTV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(13)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(postListSegmentControl.snp.bottom).offset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
