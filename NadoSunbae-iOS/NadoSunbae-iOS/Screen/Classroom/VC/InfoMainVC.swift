//
//  InfoMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then

class InfoMainVC: BaseVC {
    
    // MARK: Properties
    let infoSegmentView = NadoSegmentView().then {
        $0.questionBtn.isActivated = false
        $0.infoBtn.isActivated = true
        [$0.questionBtn, $0.infoBtn].forEach() {
            $0.isEnabled = true
        }
    }
    
    private let infoSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    
    private let arrangeBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "btnArray"), for: .normal)
    }
    
    private let infoQuestionListTV = UITableView().then {
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
        $0.isScrollEnabled = false
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
    }
    
    private let infoFloatingBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "infoFloating"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addShadow(offset: CGSize(width: 1, height: 1), color: UIColor(red: 68/255, green: 69/255, blue: 75/255, alpha: 0.2), opacity: 1, radius: 0)
    }
    
    private var selectActionSheetIndex = 0
    private var questionList: [ClassroomPostList] = []
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    var tvHeight = 0
    var originalHeight = 0
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTapQuestionBtn()
        setUpDelegate()
        registerCell()
        setUpTapFloatingBtn()
        addActivateIndicator()
        setUpTapArrangeBtn()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataBySelectedMajor), name: Notification.Name.dismissHalfModal, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpRequestData()
    }
}

// MARK: - UI
extension InfoMainVC {
    func configureUI() {
        view.addSubview(infoSV)
        infoSV.addSubview(contentView)
        contentView.addSubviews([infoSegmentView, arrangeBtn, infoQuestionListTV, infoFloatingBtn])
        
        infoSV.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        infoSegmentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38.adjustedH)
        }
        
        arrangeBtn.snp.makeConstraints {
            $0.top.equalTo(infoSegmentView.snp.bottom)
            $0.trailing.equalTo(infoQuestionListTV.snp.trailing)
            $0.height.equalTo(24)
            $0.height.equalTo(56)
        }
        
        infoQuestionListTV.snp.makeConstraints {
            $0.top.equalTo(arrangeBtn.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        infoFloatingBtn.snp.makeConstraints {
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.height.width.equalTo(64)
        }
        
        view.backgroundColor = .paleGray
        infoQuestionListTV.backgroundColor = .white
        infoQuestionListTV.separatorColor = .gray1
    }
}

// MARK: - Custom Methods
extension InfoMainVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        infoQuestionListTV.delegate = self
        infoQuestionListTV.dataSource = self
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        infoQuestionListTV.register(InfoListTVC.self, forCellReuseIdentifier: InfoListTVC.className)
        infoQuestionListTV.register(QuestionEmptyTVC.self, forCellReuseIdentifier: QuestionEmptyTVC.className)
    }
    
    /// 질문작성 floatingBtn tap 메서드
    private func setUpTapFloatingBtn() {
        infoFloatingBtn.press {
            let writeQuestionSB: UIStoryboard = UIStoryboard(name: Identifiers.WriteQusetionSB, bundle: nil)
            guard let writeQuestionVC = writeQuestionSB.instantiateViewController(identifier: WriteQuestionVC.className) as? WriteQuestionVC else { return }
            
            writeQuestionVC.questionType = .info
            writeQuestionVC.modalPresentationStyle = .fullScreen
            
            self.present(writeQuestionVC, animated: true, completion: nil)
        }
    }
    
    /// shared에 데이터가 있으면 shared정보로 데이터를 요청하고, 그렇지 않으면 Userdefaults의 전공ID로 요청을 보내는 메서드
    private func setUpRequestData() {
        requestGetGroupOrInfoListData(majorID: (MajorInfo.shared.selecteMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selecteMajorID ?? -1), postTypeID: .info, sort: .recent)
    }
    
    /// activityIndicator 설정 메서드
    private func addActivateIndicator() {
        activityIndicator.center = CGPoint(x: self.view.center.x, y: view.center.y - 106)
        view.addSubview(self.activityIndicator)
    }
    
    /// 정렬 버튼 클릭 메서드
    private func setUpTapArrangeBtn() {
        arrangeBtn.press {
            self.makeTwoAlertWithCancel(okTitle: "최신순", secondOkTitle: "좋아요순",
                                        okAction: { _ in
                self.arrangeBtn.setBackgroundImage(UIImage(named: "btnArray"), for: .normal)
                self.requestGetGroupOrInfoListData(majorID: MajorInfo.shared.selecteMajorID ?? 0, postTypeID: .info, sort: .recent)
            }, secondOkAction: { _ in
                self.arrangeBtn.setBackgroundImage(UIImage(named: "property1Variant3"), for: .normal)
                self.requestGetGroupOrInfoListData(majorID: MajorInfo.shared.selecteMajorID ?? 0, postTypeID: .info, sort: .like)
            })
        }
    }
    
    /// entireQuestionTV 높이를 구성하는 메서드
    private func configureQuestionTVHeight() {
        if questionList.count == 0 {
            tvHeight = Int(515.adjustedH)
        } else {
            tvHeight = questionList.count * Int(116.adjustedH)
        }
        
        if originalHeight == 0 {
            self.infoQuestionListTV.snp.makeConstraints {
                $0.height.equalTo(tvHeight)
            }
        } else if originalHeight != tvHeight {
            self.infoQuestionListTV.snp.updateConstraints {
                $0.height.equalTo(tvHeight)
            }
        }
        originalHeight = tvHeight
    }
    
    /// 선택된 전공정보로 서버통신 요청하는 메서드
    @objc
    func updateDataBySelectedMajor() {
        requestGetGroupOrInfoListData(majorID: MajorInfo.shared.selecteMajorID ?? 0, postTypeID: .info, sort: .recent)
    }
    
    /// 정보 segment를 눌렀을 때 실행되는 액션 메서드
    func setUpTapQuestionBtn() {
        infoSegmentView.questionBtn.press {
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 0)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension InfoMainVC: UITableViewDataSource {
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questionList.count == 0 {
            return 1
        } else {
            return questionList.count
        }
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if questionList.count == 0 {
            let emptyCell = QuestionEmptyTVC()
            emptyCell.setUpEmptyQuestionLabelText(text: "등록된 정보글이 없습니다.")
            return emptyCell
        } else {
            guard let infoCell = tableView.dequeueReusableCell(withIdentifier: InfoListTVC.className, for: indexPath) as? InfoListTVC else { return UITableViewCell() }
            infoCell.setData(data: questionList[indexPath.row])
            infoCell.backgroundColor = .white
            infoCell.layoutIfNeeded()
            return infoCell
        }
    }
}

// MARK: - UITableViewDelegate
extension InfoMainVC: UITableViewDelegate {
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if questionList.count == 0 {
            return 515.adjustedH
        } else {
            return 116.adjustedH
        }
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupChatSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil)
        guard let groupChatVC = groupChatSB.instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
        
        if questionList.count != 0 {
            groupChatVC.questionType = .info
            groupChatVC.naviStyle = .push
            groupChatVC.chatPostID = questionList[indexPath.row].postID
            self.navigationController?.pushViewController(groupChatVC, animated: true)
        }
    }
}

// MARK: - Network
extension InfoMainVC {
    
    /// 전체 질문, 정보글 전체 목록 조회 및 정렬 API 요청 메서드
    func requestGetGroupOrInfoListData(majorID: Int, postTypeID: ClassroomPostType, sort: ListSortType) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.getGroupQuestionOrInfoListAPI(majorID: majorID, postTypeID: postTypeID.rawValue, sort: sort) { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? [ClassroomPostList] {
                    self.questionList = data
                    DispatchQueue.main.async {
                        self.configureQuestionTVHeight()
                        self.infoQuestionListTV.reloadData()
                    }
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "서버 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "서버 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
