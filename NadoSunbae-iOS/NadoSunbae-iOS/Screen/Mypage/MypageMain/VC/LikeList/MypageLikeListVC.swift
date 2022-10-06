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
    private var reviewData: [MypageLikeReviewListModel.LikeList] = []
    private var questionToPersonData: [MypageLikeQuestionToPersonListModel.LikeList] = []
    private var communityData: [MypageLikeCommunityListModel.LikeList] = []
    private let contentSizeObserverKeyPath = "contentSize"
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.likeListTV.removeObserver(self, forKeyPath: contentSizeObserverKeyPath)
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
        
        switch likeListType {
        case .review:
            getMypageMyLikeList(postType: .review)
        case .personalQuestion:
            getMypageMyLikeList(postType: .questionToPerson)
        case .community:
            getMypageMyLikeList(postType: .community)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == contentSizeObserverKeyPath) {
            if let newValue = change?[.newKey] {
                let newSize  = newValue as! CGSize
                self.likeListTV.layoutIfNeeded()
                self.likeListTV.snp.updateConstraints {
                    $0.height.equalTo(newSize.height)
                }
            }
        }
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
                    reviewDetailVC.postId = self.reviewData[indexPath.row].id
                }
            }
        case .personalQuestion:
            self.divideUserPermission() {
                self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                    questionDetailVC.hidesBottomBarWhenPushed = true
                    questionDetailVC.naviStyle = .push
                    questionDetailVC.postID = self.questionToPersonData[indexPath.row].id
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
            return reviewData.count
        case .personalQuestion:
            return questionToPersonData.count
        case .community:
            return communityData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch likeListType {
        case .review:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className, for: indexPath) as? ReviewMainPostTVC else { return ReviewMainPostTVC() }
            cell.setMypageReviewLikeData(postData: reviewData[indexPath.row])
            cell.contentView.backgroundColor = .bgGray
            cell.reviewContentView.layer.borderWidth = 1
            cell.reviewContentView.layer.borderColor = UIColor.gray0.cgColor
            cell.tagImgList = reviewData[indexPath.row].tagList
            return cell
        case .personalQuestion:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className, for: indexPath) as? EntireQuestionListTVC else { return EntireQuestionListTVC() }
            cell.setMypageLikeData(data: questionToPersonData[indexPath.row])
            cell.layoutSubviews()
            return cell
        case .community:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath) as? CommunityTVC else { return CommunityTVC() }
            
            let data = communityData[indexPath.row]
            cell.setCommunityData(data: PostListResModel(postID: data.id, type: data.type, title: data.title, content: data.content, createdAt: data.createdAt, majorName: data.majorName, writer: CommunityWriter(writerID: data.writer.id, nickname: data.writer.nickname), isAuthorized: true, commentCount: data.commentCount, like: data.like))
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

// MARK: - Network
extension MypageLikeListVC {
    private func getMypageMyLikeList(postType: MypageLikePostType) {
        self.activityIndicator.startAnimating()
        self.likeListTV.addObserver(self, forKeyPath: contentSizeObserverKeyPath, options: .new, context: nil)
        MypageAPI.shared.getMypageMyLikeList(postType: postType) { networkResult in
            switch networkResult {
            case .success(let res):
                switch postType {
                case .review:
                    if let data = res as? MypageLikeReviewListModel {
                        self.reviewData = data.likeList
                    }
                case .questionToPerson:
                    if let data = res as? MypageLikeQuestionToPersonListModel {
                        self.questionToPersonData = data.likeList
                    }
                case .community:
                    if let data = res as? MypageLikeCommunityListModel {
                        self.communityData = data.likeList
                    }
                }
                self.activityIndicator.stopAnimating()
                self.likeListTV.reloadData()
                self.updateLikeListTVUI()
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMypageMyLikeList(postType: postType)
                    }
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                self.activityIndicator.stopAnimating()
            }
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
            $0.height.equalTo(36)
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
