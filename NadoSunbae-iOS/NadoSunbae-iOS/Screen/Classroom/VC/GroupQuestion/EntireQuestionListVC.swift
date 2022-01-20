//
//  EntireQuestionListVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import UIKit
import SnapKit
import Then

class EntireQuestionListVC: UIViewController {
    
    // MARK: Properties
    private let entireQuestionNaviBar = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backDefault)
        $0.configureTitleLabel(title: "전체에게 질문")
    }
    
    private let entireQuestionListTV = UITableView().then {
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
}

// MARK: - UI
extension EntireQuestionListVC {
    
    /// UI 구성 메서드
    func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubviews([entireQuestionNaviBar, entireQuestionListTV, questionFloatingBtn])
        
        entireQuestionNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        entireQuestionListTV.snp.makeConstraints {
            $0.top.equalTo(entireQuestionNaviBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
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
    
    /// ActionSheet Show 메서드
    private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // TODO: 액션 추가 예정
        let new = UIAlertAction(title: "최신순", style: .default) { action in
            self.selectActionSheetIndex = 0
            self.entireQuestionListTV.reloadSections([0], with: .fade)
        }
        
        // TODO: 액션 추가 예정
        let like = UIAlertAction(title: "좋아요순", style: .default) { action in
            self.selectActionSheetIndex = 1
            self.entireQuestionListTV.reloadSections([0], with: .fade)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [new, like, cancel].forEach {
            alert.addAction($0)
        }
        
        present(alert, animated: true, completion: nil)
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
        tableView.bringSubviewToFront(entireQuestionCell)
        return entireQuestionCell
    }
}

// MARK: - UITableViewDelegate
extension EntireQuestionListVC: UITableViewDelegate {
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    /// viewForHeaderInSection
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewStickyHeaderView.className) as? ReviewStickyHeaderView else { return UIView() }
        
        guard let entireQuestionCell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className) as? EntireQuestionListTVC else { return UITableViewCell() }
        
        // ActionSheet 항목 클릭 시 버튼 타이틀 변경
        if selectActionSheetIndex == 1 {
            headerView.arrangeBtn.setTitle("  좋아요순", for: .normal)
        } else {
            headerView.arrangeBtn.setTitle("  최신순", for: .normal)
        }
        
        headerView.tapArrangeBtnAction = {
            self.showActionSheet()
        }
        
        [headerView.headerTitleLabel, headerView.filterBtn].forEach {
            $0?.isHidden = true
        }
        
        tableView.bringSubviewToFront(entireQuestionCell)
        return headerView
    }
    
    /// heightForHeaderInSection
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupChatSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil)
        guard let groupChatVC = groupChatSB.instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
        
        // TODO: 추후에 Usertype, isWriter 정보도 함께 넘길 예정(?)
        groupChatVC.questionType = .group
        groupChatVC.naviStyle = .push
        
        self.navigationController?.pushViewController(groupChatVC, animated: true)
    }
}
