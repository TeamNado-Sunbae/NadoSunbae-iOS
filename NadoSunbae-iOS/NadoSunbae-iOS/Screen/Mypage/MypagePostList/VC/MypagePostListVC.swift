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
    private let postListTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.contentInset = .zero
        $0.separatorColor = .gray0
    }
    
    // MARK: Properties
    var isPersonalQuestionOrCommunity = true
    private let personalQuestionDummyData: [ClassroomPostList] = [
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
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
}

// MARK: - UI
extension MypagePostListVC {
    private func configureContainerView() {
        guard let mypageQuestionListVC = storyboard?.instantiateViewController(withIdentifier: MypageMyPostListVC.className) as? MypageMyPostListVC else { return }
        guard let mypageInfoListVC = storyboard?.instantiateViewController(withIdentifier: MypageMyPostListVC.className) as? MypageMyPostListVC else { return }
        
        mypageQuestionListVC.isPostOrAnswer = isPostOrAnswer
        mypageInfoListVC.isPostOrAnswer = isPostOrAnswer
        mypageInfoListVC.postType = .information
        mypageQuestionListVC.sendSegmentStateDelegate = self
        mypageInfoListVC.sendSegmentStateDelegate = self
        
        mypageQuestionListVC.view.frame = self.view.bounds
        mypageInfoListVC.view.frame = self.view.bounds
        
        addChild(mypageQuestionListVC)
        addChild(mypageInfoListVC)
        
        mypageQuestionListVC.view.translatesAutoresizingMaskIntoConstraints = false
        mypageInfoListVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        postListContainerView.firstContainerView.addSubview(mypageQuestionListVC.view)
        postListContainerView.secondContainerView.addSubview(mypageInfoListVC.view)
        
        mypageQuestionListVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.postListContainerView)
        }
        
        mypageInfoListVC.view.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(postListContainerView.secondContainerView)
        }
        
        mypageQuestionListVC.didMove(toParent: self)
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
        }
    }
}
