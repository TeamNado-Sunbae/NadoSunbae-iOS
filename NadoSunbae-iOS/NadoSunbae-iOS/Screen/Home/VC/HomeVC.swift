//
//  HomeVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/07/11.
//

import UIKit
import SnapKit
import Then

final class HomeVC: BaseVC {
    
    // MARK: Components
    private var backgroundTV = UITableView(frame: .zero, style: .grouped).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.allowsSelection = false
    }
    
    // MARK: - Properties
    enum HomeBackgroundTVSectionType: Int {
        case banner = 0, review, questionPerson, community
    }
    private var communityList: [PostListResModel] = []
    private let contentSizeObserverKeyPath = "contentSize"
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getLatestVersion {
            self.checkIsFirstInappropriate() {}
            self.configureUI()
            self.setBackgroundTV()
            self.getRecentCommunityList()
            self.requestGetMajorList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), filterType: "all", userID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabbar()
        self.backgroundTV.addObserver(self, forKeyPath: contentSizeObserverKeyPath, options: .new, context: nil)
        self.getRecentCommunityList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.backgroundTV.removeObserver(self, forKeyPath: contentSizeObserverKeyPath)
    }
    
    private func setBackgroundTV() {
        backgroundTV.dataSource = self
        backgroundTV.delegate = self
        
        backgroundTV.sectionHeaderTopPadding = 0
        
        backgroundTV.register(HomeBannerHeaderCell.self, forCellReuseIdentifier: HomeBannerHeaderCell.className)
        backgroundTV.register(HomeTitleHeaderCell.self, forCellReuseIdentifier: HomeTitleHeaderCell.className)
        backgroundTV.register(HomeFooterCell.self, forCellReuseIdentifier: HomeFooterCell.className)
        backgroundTV.register(HomeBannerTVC.self, forCellReuseIdentifier: HomeBannerTVC.className)
        backgroundTV.register(HomeSubTitleHeaderCell.self, forCellReuseIdentifier: HomeSubTitleHeaderCell.className)
        backgroundTV.register(HomeRecentReviewQuestionTVC.self, forCellReuseIdentifier: HomeRecentReviewQuestionTVC.className)
        backgroundTV.register(HomeRecentReviewQuestionTVC.self, forCellReuseIdentifier: HomeRecentReviewQuestionTVC.className + "forPesonalQuestion")
        backgroundTV.register(HomeRankingTVC.self, forCellReuseIdentifier: HomeRankingTVC.className)
        backgroundTV.register(HomeCommunityTVC.self, forCellReuseIdentifier: HomeCommunityTVC.className)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == contentSizeObserverKeyPath) {
            if let newValue = change?[.newKey] {
                let newSize  = newValue as! CGSize
                self.backgroundTV.snp.updateConstraints {
                    $0.height.equalTo(newSize.height)
                }
            }
        }
    }
}

// MARK: - SendHomeRecentDataDelegate
extension HomeVC: SendHomeRecentDataDelegate {
    func sendRecentPostId(id: Int, type: HomeRecentTVCType, isAuthorized: Bool) {
        self.divideUserPermission() {
            switch type {
            case .review:
                self.navigator?.instantiateVC(destinationViewControllerType: ReviewDetailVC.self, useStoryboard: true, storyboardName: "ReviewDetailSB", naviType: .push, modalPresentationStyle: .fullScreen) { reviewDetailVC in
                    reviewDetailVC.postId = id
                }
            case .personalQuestion:
                self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                    questionDetailVC.hidesBottomBarWhenPushed = true
                    questionDetailVC.naviStyle = .push
                    questionDetailVC.postID = id
                    questionDetailVC.isAuthorized = isAuthorized
                }
            }
        }
    }
}

// MARK: - UI
extension HomeVC {
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubviews([backgroundTV])
        
        backgroundTV.snp.makeConstraints {
            $0.horizontalEdges.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1600)
        }
    }
}

// MARK: - SendUpdateModalDelegate
extension HomeVC: SendUpdateModalDelegate {
    func sendUpdate(data: Any) {
        if let url = data as? String {
            self.presentToSafariVC(url: NSURL(string: url)! as URL)
        }
    }
}

// MARK: - SendRankerDataDelegate
extension HomeVC: SendRankerDataDelegate {
    func sendRankerData(data: HomeRankingResponseModel.UserList) {
        divideUserPermission() {
            if data.id == UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID) {
                goToRootOfTab(index: 4)
            } else {
                self.navigator?.instantiateVC(destinationViewControllerType: MypageUserVC.self, useStoryboard: true, storyboardName: MypageUserVC.className, naviType: .push) { mypageUserVC in
                    mypageUserVC.targetUserID = data.id
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // MARK: Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .banner:
                return 1
            case .review:
                return 2
            case .questionPerson:
                return 4
            case .community:
                return 2
            }
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: indexPath.section) {
            switch tableSection {
            case .banner:
                guard let bannerCell = tableView.dequeueReusableCell(withIdentifier: HomeBannerTVC.className) as? HomeBannerTVC else { return HomeBannerTVC() }
                bannerCell.sendUpdateDelegate = self
                return bannerCell
            case .review:
                switch indexPath.row {
                case 0:
                    guard let subTitleCell = tableView.dequeueReusableCell(withIdentifier: HomeSubTitleHeaderCell.className) as? HomeSubTitleHeaderCell else { return HomeSubTitleHeaderCell() }
                    subTitleCell.setTitleLabel(title: "최근 후기")
                    subTitleCell.moreBtn.removeTarget(nil, action: nil, for: .allEvents)
                    subTitleCell.moreBtn.press { [weak self] in
                        let recentReviewVC = RecentReviewVC()
                        recentReviewVC.reactor = RecentReviewReactor()
                        self?.navigationController?.pushViewController(recentReviewVC, animated: true)
                    }
                    return subTitleCell
                case 1:
                    guard let reviewsCell = tableView.dequeueReusableCell(withIdentifier: HomeRecentReviewQuestionTVC.className) as? HomeRecentReviewQuestionTVC else { return HomeRecentReviewQuestionTVC() }
                    reviewsCell.recentType = .review
                    reviewsCell.sendHomeRecentDataDelegate = self
                    return reviewsCell
                default: return UITableViewCell()
                }
            case .questionPerson:
                switch indexPath.row {
                case 0:
                    guard let subTitleCell = tableView.dequeueReusableCell(withIdentifier: HomeSubTitleHeaderCell.className) as? HomeSubTitleHeaderCell else { return HomeSubTitleHeaderCell() }
                    subTitleCell.setTitleLabel(title: "선배랭킹")
                    subTitleCell.moreBtn.removeTarget(nil, action: nil, for: .allEvents)
                    subTitleCell.moreBtn.press { [weak self] in
                        let rankingVC = RankingVC()
                        rankingVC.reactor = RankingReactor()
                        self?.navigationController?.pushViewController(rankingVC, animated: true)
                    }
                    return subTitleCell
                case 1:
                    guard let rankingCell = tableView.dequeueReusableCell(withIdentifier: HomeRankingTVC.className) as? HomeRankingTVC else { return HomeRankingTVC() }
                    rankingCell.sendRankerDataDelegate = self
                    return rankingCell
                case 2:
                    guard let subTitleCell = tableView.dequeueReusableCell(withIdentifier: HomeSubTitleHeaderCell.className) as? HomeSubTitleHeaderCell else { return HomeSubTitleHeaderCell() }
                    subTitleCell.setTitleLabel(title: "최근 1:1 질문")
                    subTitleCell.moreBtn.removeTarget(nil, action: nil, for: .allEvents)
                    subTitleCell.moreBtn.press {
                        self.navigationController?.pushViewController(HomeRecentPersonalQuestionVC(), animated: true)
                    }
                    return subTitleCell
                case 3:
                    guard let personalQuestionsCell = tableView.dequeueReusableCell(withIdentifier: HomeRecentReviewQuestionTVC.className + "forPesonalQuestion") as? HomeRecentReviewQuestionTVC else { return UITableViewCell() }
                    personalQuestionsCell.recentType = .personalQuestion
                    personalQuestionsCell.sendHomeRecentDataDelegate = self
                    personalQuestionsCell.prepareForReuse()
                    return personalQuestionsCell
                default: return UITableViewCell()
                }
            case .community:
                switch indexPath.row {
                case 0:
                    guard let subTitleCell = tableView.dequeueReusableCell(withIdentifier: HomeSubTitleHeaderCell.className) as? HomeSubTitleHeaderCell else { return HomeSubTitleHeaderCell() }
                    subTitleCell.setTitleLabel(title: "최근 게시글")
                    subTitleCell.moreBtn.removeTarget(nil, action: nil, for: .allEvents)
                    subTitleCell.moreBtn.press {
                        self.goToRootOfTab(index: 2)
                    }
                    return subTitleCell
                case 1:
                    guard let communityCell = tableView.dequeueReusableCell(withIdentifier: HomeCommunityTVC.className) as? HomeCommunityTVC else { return HomeCommunityTVC() }
                    communityCell.communityList = self.communityList
                    communityCell.didSelectItem = { postID in
                        self.divideUserPermission {
                            self.navigator?.instantiateVC(destinationViewControllerType: CommunityPostDetailVC.self, useStoryboard: true, storyboardName: "CommunityPostDetailSB", naviType: .push) { postDetailVC in
                                postDetailVC.postID = postID
                                postDetailVC.hidesBottomBarWhenPushed = true
                            }
                        }
                    }
                    return communityCell
                default: return UITableViewCell()
                }
            }
        } else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: indexPath.section) {
            switch tableSection {
            case .banner:
                return 104
            case .review:
                switch indexPath.row {
                case 0:
                    return 40
                case 1:
                    return 197
                default: return 0
                }
            case .questionPerson:
                switch indexPath.row {
                case 0, 2:
                    return 40
                case 1:
                    return 260.adjusted
                case 3:
                    return 197
                default: return 0
                }
            case .community:
                switch indexPath.row {
                case 0:
                    return 40
                case 1:
                    return UITableView.automaticDimension
                default: return 0
                }
            }
        } else { return 0 }
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    
    // MARK: Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .banner:
                guard let headerView = tableView.dequeueReusableCell(withIdentifier: HomeBannerHeaderCell.className) as? HomeBannerHeaderCell else { return HomeBannerHeaderCell() }
                return headerView
            case .review:
                guard let headerView = tableView.dequeueReusableCell(withIdentifier: HomeTitleHeaderCell.className) as? HomeTitleHeaderCell else { return HomeTitleHeaderCell() }
                headerView.setTitleLabel(titleText: "후기")
                return headerView
            case .questionPerson:
                guard let headerView = tableView.dequeueReusableCell(withIdentifier: HomeTitleHeaderCell.className) as? HomeTitleHeaderCell else { return HomeTitleHeaderCell() }
                headerView.setTitleLabel(titleText: "1:1질문")
                return headerView
            case .community:
                guard let headerView = tableView.dequeueReusableCell(withIdentifier: HomeTitleHeaderCell.className) as? HomeTitleHeaderCell else { return HomeTitleHeaderCell() }
                headerView.setTitleLabel(titleText: "커뮤니티")
                return headerView
            }
        } else { return UIView() }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .banner:
                return 60
            case .review, .questionPerson, .community:
                return 70
            }
        } else { return 0 }
    }
    
    // MARK: Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .review, .questionPerson:
                guard let footerView = tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.className) as? HomeFooterCell else { return HomeFooterCell() }
                return footerView
            default:
                return nil
            }
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .review, .questionPerson:
                return 12
            default:
                return 0
            }
        } else { return 0 }
    }
}

// MARK: - Network
extension HomeVC {
    func getRecentCommunityList() {
        PublicAPI.shared.getPostList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), majorID: 0, filter: .community, sort: "recent", search: "") { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? [PostListResModel] {
                    self.communityList = []
                    if data.count >= 3 {
                        for i in 0..<3 {
                            self.communityList.append(data[i])
                        }
                    }
                    guard let cell = self.backgroundTV.cellForRow(at: IndexPath(row: 1, section: 3)) as? HomeCommunityTVC else { return }
                    cell.communityList = self.communityList
                    NotificationCenter.default.post(name: Notification.Name.reloadHomeRecentCell, object: nil, userInfo: nil)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    debugPrint(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getRecentCommunityList()
                    }
                }
            default:
                debugPrint(#function, "network error")
            }
        }
    }

    /// 학과 리스트 조회 메서드
    func requestGetMajorList(univID: Int, filterType: String, userID: Int) {
        PublicAPI.shared.getMajorListAPI(univID: univID, filterType: filterType, userID: userID) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if let data = res as? [MajorInfoModel] {
                    MajorInfo.shared.majorList = data
                }
            case .requestErr(let res):
                if let message = res as? String {
                    debugPrint(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.requestGetMajorList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), filterType: "all", userID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID))
                    }
                }
            default:
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
}
