//
//  MypagePostListVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/14.
//

import UIKit

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
    }
    
    // MARK: Properties
    var isPostOrAnswer = true
    var isPersonalQuestionOrCommunity = true
    private let personalQuestionDummyData: [ClassroomPostList] = [
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2)].shuffled()
    private let communityDummyData = [
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1)),
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1)),
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1)),
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1)),
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1))
    ].shuffled()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeScreenAnalyticsForMyPostList()
        configureUI()
        setPostListTV()
        setSegmentedControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postListSegmentControl.setUpNadoSegmentFrame()
    }
    
    private func setPostListTV() {
        postListTV.dataSource = self
        postListTV.delegate = self
        
        postListTV.register(CommunityTVC.self, forCellReuseIdentifier: CommunityTVC.className)
        postListTV.register(EntireQuestionListTVC.self, forCellReuseIdentifier: EntireQuestionListTVC.className)
        
        postListTV.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    private func updateQuestionTVHeight() {
        postListTV.reloadData()
        DispatchQueue.main.async {
            self.postListTV.layoutIfNeeded()
            self.postListTV.rowHeight = UITableView.automaticDimension
            self.postListTV.snp.updateConstraints {
                $0.height.equalTo(self.postListTV.contentSize.height)
            }
        }
    }
    
    private func setSegmentedControl() {
        postListSegmentControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        
        postListSegmentControl.selectedSegmentIndex = 0
        didChangeValue(segment: postListSegmentControl)
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        isPersonalQuestionOrCommunity = postListSegmentControl.selectedSegmentIndex == 0
        updateQuestionTVHeight()
    }
    
    private func makeScreenAnalyticsForMyPostList() {
        if isPostOrAnswer {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MyPostListVC")
        } else {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MyAnswerListVC")
        }
    }
}

// MARK: - UITableViewDataSource
extension MypagePostListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isPersonalQuestionOrCommunity ? personalQuestionDummyData.count : communityDummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isPersonalQuestionOrCommunity {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className, for: indexPath) as? EntireQuestionListTVC else { return EntireQuestionListTVC() }
            cell.setData(data: personalQuestionDummyData[indexPath.row])
            cell.layoutSubviews()
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath) as? CommunityTVC else { return CommunityTVC() }
            cell.setCommunityData(data: communityDummyData[indexPath.row])
            return cell
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
                    questionDetailVC.questionType = .personal
                    questionDetailVC.naviStyle = .push
                    questionDetailVC.postID = self.personalQuestionDummyData[indexPath.row].postID
                }
            }
        } else {
            // TODO: Community Detail로 연결
            debugPrint("didSelectRowAt")
        }
    }
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MypagePostListVC: SendSegmentStateDelegate {
    func sendSegmentClicked(index: Int) {
        if index == 0 {
            if isPostOrAnswer {
                makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyPostList-PersonalQuestionVC")
            } else {
                makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyAnswerList-PersonalQuestionVC")
            }
        } else {
            if isPostOrAnswer {
                makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyPostList-CommunityVC")
            } else {
                makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyAnswerList-CommunityVC")
            }
        }
    }
}

// MARK: - UI
extension MypagePostListVC {
    private func configureUI() {
        view.addSubviews([naviView, postListSegmentControl, postListSV])
        postListSV.addSubview(contentView)
        contentView.addSubview(postListTV)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        postListSegmentControl.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(160)
        }
        
        postListSV.snp.makeConstraints {
            $0.top.equalTo(postListSegmentControl.snp.bottom).offset(18)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        postListTV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(13)
        }
    }
}
