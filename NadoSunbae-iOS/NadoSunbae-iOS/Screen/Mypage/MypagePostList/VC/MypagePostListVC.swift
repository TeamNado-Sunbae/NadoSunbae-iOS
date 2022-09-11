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
        $0.configureTitleLabel(title: "내가 쓴 글")
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
        CommunityPostList(category: "전체", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "닉"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
        CommunityPostList(category: "전체", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "네"), like: Like(isLiked: false, likeCount: 1), commentCount: 1),
        CommunityPostList(category: "전체", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티", createdAt: "2022-08-14T01:35:59.500Z", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "임"), like: Like(isLiked: true, likeCount: 1), commentCount: 1),
        CommunityPostList(category: "전체", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "slr"), like: Like(isLiked: false, likeCount: 2), commentCount: 1),
        CommunityPostList(category: "전체", postID: 1, title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", writer: CommunityPostList.Writer(writerID: 1, profileImageID: 1, nickname: "slr"), like: Like(isLiked: true, likeCount: 1), commentCount: 1)
    ].shuffled()

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContainerView()
        
        makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: MypagePostListVC.className)
    }
    private func setPostListTV() {
        postListTV.dataSource = self
        postListTV.delegate = self
        
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
    }
}

// MARK: - UITableViewDelegate
extension MypagePostListVC: UITableViewDelegate {
    
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
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: MypageMyPostListVC.className)
            postListContainerView.externalSV.contentOffset.x = 0
        } else {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyPostAnswerListVC")
            postListContainerView.externalSV.contentOffset.x += screenWidth
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
