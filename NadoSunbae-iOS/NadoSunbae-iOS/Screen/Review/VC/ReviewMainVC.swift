//
//  ReviewMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit
import SafariServices

class ReviewMainVC: BaseVC {
    
    // MARK: IBOutlet
    @IBOutlet weak var naviBarView: UIView!
    @IBOutlet var majorLabel: UILabel! {
        didSet {
            majorLabel.text = UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)
            majorLabel.font = .PretendardM(size: 20)
        }
    }
    @IBOutlet weak var reviewTV: UITableView!
    
    // MARK: Properties
    var imgList: [ReviewImgData] = []
    var tagList: [ReviewTagList] = []
    var postList: [ReviewMainPostListData] = []
    var majorInfo: String = ""
    var sortType: ListSortType = .recent
    private var filterStatus = false
    private var selectedWriterFilter: Int = 1
    private var selectedTagFilter: [Int] = []
    private var selectActionSheetIndex: Int = 0
    
    // MARK: Life Cycle Part
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLatestVersion()
        registerTVC()
        setUpTV()
        initImgList()
        reviewTV.reloadData()
        addShadowToNaviBar()
        requestGetMajorList(univID: 1, filterType: "all")
        setUpMajorLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpMajorLabel()
        self.tabBarController?.tabBar.isHidden = false
        setUpRequestData()
    }
    
    // MARK: IBAction
    @IBAction func tapNaviBarBtn(_ sender: Any) {
        presentHalfModalView()
    }
    
    @IBAction func tapFloatingBtn(_ sender: Any) {
        presentToReviewWriteVC { _ in }
    }
}

// MARK: - UI
extension ReviewMainVC {
    
    /// NaviBar dropShadow 설정 함수
    private func addShadowToNaviBar() {
        naviBarView.layer.shadowColor = UIColor(red: 0.898, green: 0.898, blue: 0.91, alpha: 0.16).cgColor
        naviBarView.layer.shadowOffset = CGSize(width: 0, height: 9)
        naviBarView.layer.shadowRadius = 18
        naviBarView.layer.shadowOpacity = 1
        naviBarView.layer.masksToBounds = false
    }
}

// MARK: - Custom Methods
extension ReviewMainVC {
    
    /// cell 등록 함수
    private func registerTVC() {
        ReviewMainImgTVC.register(target: reviewTV)
        ReviewMainLinkTVC.register(target: reviewTV)
        ReviewMainPostTVC.register(target: reviewTV)
        ReviewEmptyTVC.register(target: reviewTV)
        
        let nib = UINib(nibName: "ReviewMainStickyHeader", bundle: nil)
        reviewTV.register(nib, forHeaderFooterViewReuseIdentifier: ReviewStickyHeaderView.className)
    }
    
    /// TableView setting 함수
    private func setUpTV() {
        reviewTV.dataSource = self
        reviewTV.delegate = self
        
        /// TableView 하단 space 설정
        reviewTV.contentInset.bottom = 16
        
        /// section header 들어가지 않는 section에 padding 값 없도록
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.0
        }
    }
    
    /// section0: 이미지 삽입
    private func initImgList() {
        imgList.append(contentsOf: [
            ReviewImgData(reviewImgName: "Frame 149")
        ])
    }
    
    /// 액션시트
    private func presentActionSheet() {
        makeTwoAlertWithCancel(okTitle: "최신순", secondOkTitle: "좋아요순", okAction: { _ in
            self.sortType = .recent
            self.setUpRequestData()
            self.reviewTV.reloadSections([2], with: .fade)
        }, secondOkAction: { _ in
            self.sortType = .like
            self.setUpRequestData()
            self.reviewTV.reloadSections([2], with: .fade)
        })
    }
    
    /// 화면 상단에 닿으면 스크롤 disable
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    /// 전공 Label text를 set하는 메서드
    private func setUpMajorLabel() {
        majorLabel.text = (MajorInfo.shared.selectedMajorName != nil) ? MajorInfo.shared.selectedMajorName : UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName)
    }
    
    /// shared에 데이터가 있으면 shared정보로 데이터를 요청하고, 그렇지 않으면 Userdefaults의 전공ID로 요청을 보내는 메서드
    private func setUpRequestData() {
        requestGetReviewPostList(majorID: (MajorInfo.shared.selectedMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selectedMajorID ?? -1), writerFilter: self.selectedWriterFilter, tagFilter: self.selectedTagFilter == [] ? [1, 2, 3, 4, 5] : self.selectedTagFilter, sort: sortType)
    }
    
    /// 링크에 해당하는 웹사이트로 연결하는 함수
    private func presentSafariVC(link: String) {
        let webLink = NSURL(string: link)
        let safariVC: SFSafariViewController = SFSafariViewController(url: webLink! as URL)
        self.present(safariVC, animated: true, completion: nil)
    }
}

// MARK: - @objc Function Part
extension ReviewMainVC {
    
    /// 학과 선택 바텀시트 호출
    @objc func presentHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.selectMajorDelegate = self
        slideVC.selectFilterDelegate = self
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    /// 필터 선택 바텀시트 호출
    @objc func presentHalfModalFilterView() {
        let slideVC = FilterVC()
        slideVC.selectFilterDelegate = self
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension ReviewMainVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - UITableViewDelegate
extension ReviewMainVC: UITableViewDelegate {
    
    /// section 3개로 나눔
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// cell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 192.adjustedH
        } else if indexPath.section == 1 {
            return 52.adjustedH
        } else if indexPath.section == 2 {
            if postList.isEmpty {
                return 250.adjustedH
            } else {
                return 156
            }
        } else {
            return 0
        }
    }
    
    /// section header view 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewStickyHeaderView.className) as? ReviewStickyHeaderView else { return UIView() }
            
            switch sortType {
                
            case .recent:
                headerView.arrangeBtn.setImage(UIImage(named: "btnArray"), for: .normal)
            case .like:
                headerView.arrangeBtn.setImage(UIImage(named: "property1Variant3"), for: .normal)
            }
            
            headerView.tapArrangeBtnAction = {
                self.presentActionSheet()
            }
            
            if filterStatus == true {
                headerView.filterBtn.setImage(UIImage(named: "filterSelected"), for: .normal)
            } else {
                headerView.filterBtn.setImage(UIImage(named: "btnFilter"), for: .normal)
            }
            headerView.tapFilterBtnAction = {
                self.presentHalfModalFilterView()
            }
            return headerView
        } else {
            return nil
        }
    }
    
    /// section header 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 48
        } else {
            return 0
        }
    }
    
    /// cell 선택 시 화면 전환
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if !postList.isEmpty {
                
                /// 후기글 작성하지 않은 유저라면 후기글 열람 제한
                if UserPermissionInfo.shared.isUserReported {
                    showRestrictionAlert(permissionStatus: .report)
                } else if UserPermissionInfo.shared.isReviewInappropriate {
                    showRestrictionAlert(permissionStatus: .inappropriate)
                } else if !(UserPermissionInfo.shared.isReviewed) {
                    showRestrictionAlert(permissionStatus: .review)
                } else {
                    pushToReviewDetailVC { reviewDetailVC in
                        reviewDetailVC.postId = self.postList[indexPath.row].postID
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ReviewMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            if postList.isEmpty {
                return 1
            } else {
                return postList.count
            }
        } else {
            return 0
        }
    }
    
    /// row에 들어갈 cell 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviewMainImgTVC = tableView.dequeueReusableCell(withIdentifier: ReviewMainImgTVC.className) as? ReviewMainImgTVC,
              let reviewMainLinkTVC = tableView.dequeueReusableCell(withIdentifier: ReviewMainLinkTVC.className) as? ReviewMainLinkTVC,
              let reviewMainPostTVC = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className) as? ReviewMainPostTVC,
              let reviewEmptyTVC = tableView.dequeueReusableCell(withIdentifier: ReviewEmptyTVC.className) as? ReviewEmptyTVC else { return UITableViewCell() }

        if indexPath.section == 0 {
            reviewMainImgTVC.setData(ImgData: imgList[indexPath.row])
            return reviewMainImgTVC
        } else if indexPath.section == 1 {
            reviewMainLinkTVC.tapHomePageBtnAction = {
                let homePageLink = reviewMainLinkTVC.homePageLink
                self.presentSafariVC(link: homePageLink)
            }
            reviewMainLinkTVC.tapSubjectBtnAction = {
                let subjectTableLink = reviewMainLinkTVC.subjectTableLink
                self.presentSafariVC(link: subjectTableLink)
            }
            return reviewMainLinkTVC
        } else if indexPath.section == 2 {
            
            /// 게시글이 없을 때 emptyView 나오도록 분기처리
            if postList.isEmpty {
                return reviewEmptyTVC
            } else {
                tagList = postList[indexPath.row].tagList
                reviewMainPostTVC.tagImgList = postList[indexPath.row].tagList
                reviewMainPostTVC.setData(postData: postList[indexPath.row])
                return reviewMainPostTVC
            }
        } else {
            return UITableViewCell()
        }
    }
}

// MARK: - SendUpdateModalDelegate
extension ReviewMainVC: SendUpdateModalDelegate {
    
    /// 학과 선택 시 해당 학과의 게시글 리스트가 로드될 수 있도록 요청
    func sendUpdate(data: Any) {
        majorLabel.text = data as? String
        requestGetReviewPostList(majorID: (MajorInfo.shared.selectedMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selectedMajorID ?? -1), writerFilter: 1, tagFilter: [1, 2, 3, 4, 5], sort: .recent)
        self.sortType = .recent
    }
}

// MARK: - SendUpdateStatusDelegate
extension ReviewMainVC: SendUpdateStatusDelegate {
    func sendStatus(data: Bool) {
        let selectedList = ReviewFilterInfo.shared.selectedBtnList
        
        /// 필터 on/off 판단
        filterStatus = data
        
        /// 태그 필터 초기화
        selectedTagFilter = []
        
        /// 작성자 필터 판단
        if selectedList[0] == true  && selectedList[1] == false {
            selectedWriterFilter = 2
        } else if selectedList[1] == false && selectedList[1] == true {
            selectedWriterFilter = 3
        } else {
            selectedWriterFilter = 1
        }
        
        /// 태그 필터 판단
        for i in 2...selectedList.count - 1 {
            if selectedList[i] == true {
                selectedTagFilter.append(Int(i - 1))
            }
        }
        
        if filterStatus {
            /// 필터 on 상태일 때
            requestGetReviewPostList(majorID: (MajorInfo.shared.selectedMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selectedMajorID ?? -1), writerFilter: selectedWriterFilter, tagFilter: selectedTagFilter == [] ? [1, 2, 3, 4, 5] : selectedTagFilter, sort: sortType)
        } else {
            /// 필터 off 상태일 때
            requestGetReviewPostList(majorID: (MajorInfo.shared.selectedMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selectedMajorID ?? -1), writerFilter: 1, tagFilter: [1, 2, 3, 4, 5], sort: sortType)
        }
        reviewTV.reloadData()
    }
}

// MARK: - Network

/// 학과 정보 리스트 조회
extension ReviewMainVC {
    private func requestGetMajorList(univID: Int, filterType: String) {
        PublicAPI.shared.getMajorListAPI(univID: univID, filterType: filterType) { networkResult in
            switch networkResult {
                
            case .success(let res):
                var list: [MajorInfoModel] = []
                DispatchQueue.main.async {
                    if let data = res as? [MajorListData] {
                        for i in 0...data.count - 1 {
                            list.append(MajorInfoModel(majorID: data[i].majorID, majorName: data[i].majorName))
                        }
                        MajorInfo.shared.majorList = list
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

/// 후기글 리스트 조회
extension ReviewMainVC {
    private func requestGetReviewPostList(majorID: Int, writerFilter: Int, tagFilter: [Int], sort: ListSortType) {
        self.activityIndicator.startAnimating()
        ReviewAPI.shared.getReviewPostListAPI(majorID: majorID, writerFilter: writerFilter, tagFilter: tagFilter, sort: sort) { networkResult in
            switch networkResult {
                
            case .success(let res):
                self.activityIndicator.stopAnimating()
                if let data = res as? [ReviewMainPostListData] {
                    DispatchQueue.main.async {
                        self.postList = data
                        self.reviewTV.reloadData()
                    }
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.setUpRequestData()
                    }
                }
            case .pathErr:
                print("pathErr")
                self.activityIndicator.stopAnimating()
            case .serverErr:
                print("serverErr")
                self.activityIndicator.stopAnimating()
            case .networkFail:
                print("networkFail")
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

