//
//  EntireQuestionListVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import UIKit
import SnapKit
import Then

class EntireQuestionListVC: BaseVC {
    
    // MARK: Properties
    private let entireQuestionNaviBar = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backDefault)
        $0.configureTitleLabel(title: "전체에게 질문")
        $0.addShadow(offset: CGSize(width: 0, height: 4), color: .shadowDefault, opacity: 1, radius: 16)
    }
    
    private let entireQuestionListTV = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    private let questionFloatingBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "qustionFloating"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addShadow(offset: CGSize(width: 1, height: 1), color: UIColor(red: 68/255, green: 69/255, blue: 75/255, alpha: 0.2), opacity: 1, radius: 0)
    }
    
    private var selectActionSheetIndex = 0
    private var questionList: [ClassroomPostList] = []
    private var lastSortType: ListSortType = .recent
     
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpDelegate()
        registerCell()
        registerXib()
        setUpTapFloatingBtn()
        setUpTapNaviBackBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpRequestData(sortType: lastSortType)
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - UI
extension EntireQuestionListVC {
    
    /// UI 구성 메서드
    func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubviews([entireQuestionNaviBar, entireQuestionListTV, questionFloatingBtn])
        
        entireQuestionNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        entireQuestionListTV.snp.makeConstraints {
            $0.top.equalTo(entireQuestionNaviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(236)
            $0.bottom.equalToSuperview()
        }
        
        questionFloatingBtn.snp.makeConstraints {
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.height.width.equalTo(64)
        }
        
        entireQuestionListTV.backgroundColor = .paleGray
    }
}

// MARK: - Custom Methods
extension EntireQuestionListVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        entireQuestionListTV.delegate = self
        entireQuestionListTV.dataSource = self
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        entireQuestionListTV.register(EntireQuestionListTVC.self, forCellReuseIdentifier: EntireQuestionListTVC.className)
    }
    
    /// Xib 등록 메서드
    private func registerXib() {
        let nib = UINib(nibName: "ReviewMainStickyHeader", bundle: nil)
        entireQuestionListTV.register(nib, forHeaderFooterViewReuseIdentifier: ReviewStickyHeaderView.className)
    }
    
    /// 질문작성 floatingBtn tap 메서드
    private func setUpTapFloatingBtn() {
        questionFloatingBtn.press {
            // TODO: 후기작성 분기처리 후 질문작성뷰랑 연결
            let writeQuestionSB: UIStoryboard = UIStoryboard(name: Identifiers.WriteQusetionSB, bundle: nil)
            guard let writeQuestionVC = writeQuestionSB.instantiateViewController(identifier: WriteQuestionVC.className) as? WriteQuestionVC else { return }
            
            writeQuestionVC.questionType = .group
            writeQuestionVC.modalPresentationStyle = .fullScreen
            
            self.present(writeQuestionVC, animated: true, completion: nil)
        }
    }
    
    /// 네비 back 버튼을 눌렀을 때 액션 set 메서드
    private func setUpTapNaviBackBtn() {
        entireQuestionNaviBar.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// shared에 데이터가 있으면 shared정보로 데이터를 요청하고, 그렇지 않으면 Userdefaults의 전공ID로 요청을 보내는 메서드
    private func setUpRequestData(sortType: ListSortType) {
        requestGetGroupOrInfoListData(majorID: (MajorInfo.shared.selectedMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selectedMajorID ?? -1), postTypeID: .group, sort: sortType)
        lastSortType = sortType
    }
}

// MARK: - UITableViewDataSource
extension EntireQuestionListVC: UITableViewDataSource {
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let entireQuestionCell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className, for: indexPath) as? EntireQuestionListTVC else { return UITableViewCell() }
        entireQuestionCell.setData(data: questionList[indexPath.row])
        entireQuestionCell.backgroundColor = .paleGray
        entireQuestionCell.layoutIfNeeded()
        tableView.bringSubviewToFront(entireQuestionCell)
        return entireQuestionCell
    }
}

// MARK: - UITableViewDelegate
extension EntireQuestionListVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    /// viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewStickyHeaderView.className) as? ReviewStickyHeaderView else { return UIView() }
        
        guard let entireQuestionCell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className) as? EntireQuestionListTVC else { return UITableViewCell() }
        
        // ActionSheet 항목 클릭 시 버튼 타이틀 변경
        if selectActionSheetIndex == 1 {
            headerView.arrangeBtn.setImage(UIImage(named: "property1Variant3"), for: .normal)
        } else {
            headerView.arrangeBtn.setImage(UIImage(named: "btnArray"), for: .normal)
        }
        
        headerView.tapArrangeBtnAction = {
            self.makeTwoAlertWithCancel(okTitle: "최신순", secondOkTitle: "좋아요순",
                                        okAction: { _ in
                self.selectActionSheetIndex = 0
                self.setUpRequestData(sortType: .recent)
                self.entireQuestionListTV.reloadSections([0], with: .fade)
            },
                                        secondOkAction: { _ in
                self.selectActionSheetIndex = 1
                self.setUpRequestData(sortType: .like)
                self.entireQuestionListTV.reloadSections([0], with: .fade)
            })
        }
        
        [headerView.headerTitleLabel, headerView.filterBtn].forEach {
            $0?.isHidden = true
        }
        
        tableView.bringSubviewToFront(entireQuestionCell)
        return headerView
    }
    
    /// heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// 후기글 작성하지 않은 유저라면 게시글 열람 제한
        if !(UserDefaults.standard.bool(forKey: UserDefaults.Keys.IsReviewed)) {
            showRestrictionAlert()
        } else {
            let groupChatSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil)
            guard let groupChatVC = groupChatSB.instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
            
            groupChatVC.questionType = .group
            groupChatVC.naviStyle = .push
            groupChatVC.postID = questionList[indexPath.row].postID
            groupChatVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(groupChatVC, animated: true)
        }
    }
}

// MARK: - Network
extension EntireQuestionListVC {
    
    /// 전체 질문, 정보글 전체 목록 조회 및 정렬 API 요청 메서드
    func requestGetGroupOrInfoListData(majorID: Int, postTypeID: QuestionType, sort: ListSortType) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.getGroupQuestionOrInfoListAPI(majorID: majorID, postTypeID: postTypeID.rawValue, sort: sort) { networkResult in
            switch networkResult {
            case .success(let res):
                self.activityIndicator.stopAnimating()
                if let data = res as? [ClassroomPostList] {
                    self.questionList = data
                    DispatchQueue.main.async {
                        self.entireQuestionListTV.reloadData()
                        self.entireQuestionListTV.layoutIfNeeded()
                        self.entireQuestionListTV.snp.updateConstraints {
                            $0.height.equalTo(self.entireQuestionListTV.contentSize.height)
                        }
                    }
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.setUpRequestData(sortType: .recent)
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
