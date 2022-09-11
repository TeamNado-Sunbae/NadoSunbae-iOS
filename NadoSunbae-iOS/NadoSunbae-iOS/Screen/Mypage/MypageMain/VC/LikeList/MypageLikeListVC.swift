//
//  MypageLikeListVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/03/07.
//

import UIKit
import SnapKit
import Then

enum MypageLikeListType: Int {
    case review = 0, personalQuestion, community
}

class MypageLikeListVC: BaseVC {
    
    // MARK: Components
    private lazy var naviView = NadoSunbaeNaviBar().then {
        $0.configureTitleLabel(title: "좋아요 목록")
        $0.setUpNaviStyle(state: .backDefault)
        $0.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private let likeListSegmentControl = NadoSegmentedControl(items: ["후기", "1:1 질문", "커뮤니티"])
    private let likeListSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    private let likeListTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.contentInset = .zero
        $0.separatorColor = .gray0
        $0.isScrollEnabled = false
        $0.estimatedRowHeight = 160
        $0.rowHeight = UITableView.automaticDimension
        $0.setBottomEmptyView()
    }
    
    // MARK: Properties
    private var likeListType: MypageLikeListType = .review
    private let reviewDummyData: [MypageLikeReviewDataModel] = [
        MypageLikeReviewDataModel(postID: 111, title: "2MVVM개어렵다...", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구")], writer: MypageLikeWriter(writerID: 1, nickname: "리액터은주"), like: Like(isLiked: false, likeCount: 3)),
        MypageLikeReviewDataModel(postID: 111, title: "3MVVM개어렵다...", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구")], writer: MypageLikeWriter(writerID: 1, nickname: "리액터은주"), like: Like(isLiked: false, likeCount: 3)),
        MypageLikeReviewDataModel(postID: 111, title: "4MVVM개어렵다...", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구")], writer: MypageLikeWriter(writerID: 1, nickname: "리액터은주"), like: Like(isLiked: false, likeCount: 3)),
        MypageLikeReviewDataModel(postID: 111, title: "5MVVM개어렵다...", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구")], writer: MypageLikeWriter(writerID: 1, nickname: "리액터은주"), like: Like(isLiked: false, likeCount: 3)),
        MypageLikeReviewDataModel(postID: 111, title: "6MVVM개어렵다...", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구")], writer: MypageLikeWriter(writerID: 1, nickname: "리액터은주"), like: Like(isLiked: false, likeCount: 3)),
        MypageLikeReviewDataModel(postID: 111, title: "7MVVM개어렵다...", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구")], writer: MypageLikeWriter(writerID: 1, nickname: "리액터은주"), like: Like(isLiked: false, likeCount: 3)),
        MypageLikeReviewDataModel(postID: 111, title: "8MVVM개어렵다...", createdAt: "2022-06-12T01:35:59.500Z", tagList: [ReviewTagList(tagName: "어쩌구")], writer: MypageLikeWriter(writerID: 1, nickname: "리액터은주"), like: Like(isLiked: false, likeCount: 3))
        ]
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setlikeListTV()
        setSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        likeListSegmentControl.setUpNadoSegmentFrame()
    }
    
    private func setlikeListTV() {
        likeListTV.dataSource = self
        likeListTV.delegate = self
        likeListTV.register(UINib(nibName: ReviewMainPostTVC.className, bundle: nil), forCellReuseIdentifier: ReviewMainPostTVC.className)
        likeListTV.register(CommunityTVC.self, forCellReuseIdentifier: CommunityTVC.className)
        likeListTV.register(EntireQuestionListTVC.self, forCellReuseIdentifier: EntireQuestionListTVC.className)
    }
    
    private func updateLikeListTVUI() {
        DispatchQueue.main.async {
            switch self.likeListType {
            case .review:
                self.likeListTV.layer.cornerRadius = 0
                self.likeListTV.layer.borderWidth = 0
                self.likeListTV.separatorStyle = .none
                self.likeListTV.contentInset = .zero
                self.likeListTV.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(-16)
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(self.likeListTV.contentSize.height)
                }
                
            case .personalQuestion, .community:
                self.likeListTV.layer.cornerRadius = 16
                self.likeListTV.layer.borderWidth = 1
                self.likeListTV.separatorStyle = .singleLine
                self.likeListTV.layer.borderColor = UIColor.gray0.cgColor
                self.likeListTV.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                self.likeListTV.snp.updateConstraints {
                    $0.top.equalToSuperview()
                    $0.left.right.equalToSuperview().inset(16)
                    $0.height.equalTo(self.likeListTV.contentSize.height)
                }
            }
            self.likeListTV.setNeedsLayout()
        }
    }
    
    private func setSegmentedControl() {
        likeListSegmentControl.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
        
        likeListSegmentControl.selectedSegmentIndex = 0
        didChangeValue(segment: likeListSegmentControl)
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        likeListType = MypageLikeListType(rawValue: likeListSegmentControl.selectedSegmentIndex) ?? .review
        
        likeListTV.reloadData()
        updateLikeListTVUI()
    }
}

// MARK: - UITableViewDelegate
extension MypageLikeListVC: UITableViewDelegate {
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch likeListType {
        case .review:
            self.divideUserPermission {
                self.navigator?.instantiateVC(destinationViewControllerType: ReviewDetailVC.self, useStoryboard: true, storyboardName: "ReviewDetailSB", naviType: .push, modalPresentationStyle: .fullScreen) { reviewDetailVC in
                    reviewDetailVC.postId = self.reviewDummyData[indexPath.row].postID
                }
            }
        case .personalQuestion:
            self.divideUserPermission() {
                self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                    questionDetailVC.hidesBottomBarWhenPushed = true
                    questionDetailVC.questionType = .personal
                    questionDetailVC.naviStyle = .push
                    questionDetailVC.postID = self.personalQuestionDummyData[indexPath.row].postID
                }
            }
        case .community:
                // TODO: Community Detail로 연결
                debugPrint("didSelectRowAt")
        }
    }
}

// MARK: - UITableViewDataSource
extension MypageLikeListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch likeListType {
        case .review:
            return reviewDummyData.count
        case .personalQuestion:
            return personalQuestionDummyData.count
        case .community:
            return communityDummyData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch likeListType {
        case .review:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className, for: indexPath) as? ReviewMainPostTVC else { return ReviewMainPostTVC() }
            cell.setMypageReviewLikeData(postData: reviewDummyData[indexPath.row])
            cell.contentView.backgroundColor = .bgGray
            cell.reviewContentView.layer.borderWidth = 1
            cell.reviewContentView.layer.borderColor = UIColor.gray0.cgColor
            return cell
        case .personalQuestion:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className, for: indexPath) as? EntireQuestionListTVC else { return EntireQuestionListTVC() }
            cell.setData(data: personalQuestionDummyData[indexPath.row])
            cell.layoutSubviews()
            return cell
        case .community:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath) as? CommunityTVC else { return CommunityTVC() }
            cell.setCommunityData(data: communityDummyData[indexPath.row])
            return cell
        }
    }
}

// MARK: - SendSegmentStateDelegate
extension MypageLikeListVC: SendSegmentStateDelegate {
    func sendSegmentClicked(index: Int) {
        if index == 0 {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyLikeList-Review")
        } else if index == 1 {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyLikeList-PersonalQuestion")
        } else {
            makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: "MypageMyLikeList-Community")
        }
    }
}

// MARK: - UI
extension MypageLikeListVC {
    private func configureUI() {
        view.backgroundColor = .bgGray
        
        view.addSubviews([naviView, likeListSegmentControl, likeListSV])
        likeListSV.addSubview(contentView)
        contentView.addSubview(likeListTV)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        likeListSegmentControl.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(240)
        }
        
        likeListSV.snp.makeConstraints {
            $0.top.equalTo(likeListSegmentControl.snp.bottom).offset(18)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        likeListTV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(13)
        }
    }
}
