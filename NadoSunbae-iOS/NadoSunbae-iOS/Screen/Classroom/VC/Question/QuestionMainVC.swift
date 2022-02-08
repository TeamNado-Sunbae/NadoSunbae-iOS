//
//  QuestionMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then

class QuestionMainVC: BaseVC {
    
    // MARK: Properties
    private let questionSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    private let personalQuestionBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "imgRoomMain"), for: .normal)
        $0.contentMode = .scaleToFill
    }
    
    private let entireQuestionTitleLabel = UILabel().then {
        $0.text = "전체에게 질문"
        $0.textColor = .black
        $0.font = .PretendardM(size: 16.0)
        $0.sizeToFit()
    }
    
    private let entireQuestionTV = UITableView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.isScrollEnabled = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    let questionSegmentView = NadoSegmentView()
    private var questionList: [ClassroomPostList] = []
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    let halfVC = HalfModalVC()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpDelegate()
        setUpTapInfoBtn()
        registerCell()
        setUpTapPersonalQuestionBtn()
        addActivateIndicator()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDataBySelectedMajor), name: Notification.Name.dismissHalfModal, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpRequestData()
    }
}

// MARK: - UI
extension QuestionMainVC {
    
    /// 전체 UI를 구성하는 메서드
    private func configureUI() {

        view.addSubview(questionSV)
        questionSV.addSubview(contentView)
        contentView.addSubviews([questionSegmentView, personalQuestionBtn, entireQuestionTitleLabel, entireQuestionTV])
        
        questionSV.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        questionSegmentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38.adjustedH)
        }
        
        personalQuestionBtn.snp.makeConstraints {
            $0.top.equalTo(questionSegmentView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(176.adjustedH)
            $0.width.equalTo(327.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        entireQuestionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(personalQuestionBtn.snp.bottom).offset(24)
            $0.leading.equalTo(personalQuestionBtn)
            $0.height.equalTo(19)
        }
        
        entireQuestionTV.snp.makeConstraints {
            $0.top.equalTo(entireQuestionTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(personalQuestionBtn)
            $0.height.equalTo(236)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        entireQuestionTV.separatorColor = .gray1
    }
}

// MARK: - Custom Methods
extension QuestionMainVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        entireQuestionTV.delegate = self
        entireQuestionTV.dataSource = self
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        entireQuestionTV.register(QuestionHeaderTVC.self, forCellReuseIdentifier: QuestionHeaderTVC.className)
        entireQuestionTV.register(QuestionTVC.self, forCellReuseIdentifier: QuestionTVC.className)
    }
    
    /// '정보' 버튼을 눌렀을 때 액션 set 메서드
    private func setUpTapInfoBtn() {
        questionSegmentView.infoBtn.press {
            
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 1)
            }
        }
    }
    
    /// 질문작성VC로 present하는 메서드
    private func presentToWriteQuestionVC() {
        let writeQuestionSB: UIStoryboard = UIStoryboard(name: Identifiers.WriteQusetionSB, bundle: nil)
        guard let writeQuestionVC = writeQuestionSB.instantiateViewController(identifier: WriteQuestionVC.className) as? WriteQuestionVC else { return }
        
        writeQuestionVC.questionType = .group
        writeQuestionVC.modalPresentationStyle = .fullScreen
        
        self.present(writeQuestionVC, animated: true, completion: nil)
    }
    
    /// 질문가능선배Btn tap Action 설정 메서드
    private func setUpTapPersonalQuestionBtn() {
        personalQuestionBtn.press(vibrate: true) {
            let questionPersonVC = QuestionPersonListVC()
            questionPersonVC.majorID = MajorInfo.shared.selecteMajorID ?? UserDefaults.standard.value(forKey: UserDefaults.Keys.FirstMajorID) as! Int
            self.navigationController?.pushViewController(questionPersonVC, animated: true)
        }
    }
    
    /// 선택된 전공정보에 따라 서버통신 요청하는 메서드
    @objc
    func updateDataBySelectedMajor() {
        requestGetGroupOrInfoListData(majorID: MajorInfo.shared.selecteMajorID ?? 0, postTypeID: .group, sort: .recent)
    }
    
    /// shared에 데이터가 있으면 shared정보로 데이터를 요청하고, 그렇지 않으면 Userdefaults의 전공ID로 요청을 보내는 메서드
    private func setUpRequestData() {
        requestGetGroupOrInfoListData(majorID: (MajorInfo.shared.selecteMajorID == nil ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.FirstMajorID) : MajorInfo.shared.selecteMajorID ?? -1), postTypeID: .group, sort: .recent)
    }
    
    /// ActivateIndicator 추가 메서드
    private func addActivateIndicator() {
        activityIndicator.center = CGPoint(x: self.view.center.x, y: view.center.y - 106)
        view.addSubview(self.activityIndicator)
    }
}

// MARK: - UITableViewDataSource
extension QuestionMainVC: UITableViewDataSource {
    
    /// numberOfSections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return (questionList.count == 0 ? 1 : (questionList.count > 5 ? 5 : questionList.count))
        case 2:
            return (questionList.count > 5 ? 1 : 0)
        default:
            return 0
        }
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let questionHeaderCell = tableView.dequeueReusableCell(withIdentifier: QuestionHeaderTVC.className, for: indexPath) as? QuestionHeaderTVC else { return UITableViewCell() }
            questionHeaderCell.tapWriteBtnAction = {
                self.presentToWriteQuestionVC()
            }
            return questionHeaderCell
        case 1:
            if questionList.count == 0 {
                return QuestionEmptyTVC()
            } else {
                guard let questionCell = tableView.dequeueReusableCell(withIdentifier: QuestionTVC.className, for: indexPath) as? QuestionTVC else { return UITableViewCell() }
                questionCell.setData(data: questionList[indexPath.row])
                return questionCell
            }
        case 2:
            return (questionList.count > 5 ? QuestionFooterTVC() : UITableViewCell())
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension QuestionMainVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return (questionList.count == 0 ? 236 : 120)
        case 2:
            return (questionList.count > 5 ? 40 : 0)
        default:
            return 0
        }
    }
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return (questionList.count == 0 ? 236 : UITableView.automaticDimension)
        case 2:
            return (questionList.count > 5 ? 40 : 0)
        default:
            return 0
        }
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let groupChatSB: UIStoryboard = UIStoryboard(name: Identifiers.QuestionChatSB, bundle: nil)
            guard let groupChatVC = groupChatSB.instantiateViewController(identifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
            
            if questionList.count != 0 {
                groupChatVC.questionType = .group
                groupChatVC.naviStyle = .push
                groupChatVC.chatPostID = questionList[indexPath.row].postID
                self.navigationController?.pushViewController(groupChatVC, animated: true)
            }
        } else if indexPath.section == 2 {
            let entireQuestionVC = EntireQuestionListVC()
            self.navigationController?.pushViewController(entireQuestionVC, animated: true)
        }
    }
}

// MARK: - Network
extension QuestionMainVC {
    
    /// 전체 질문, 정보글 전체 목록 조회 및 정렬 API 요청 메서드
    func requestGetGroupOrInfoListData(majorID: Int, postTypeID: QuestionType, sort: ListSortType) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.getGroupQuestionOrInfoListAPI(majorID: majorID, postTypeID: postTypeID.rawValue, sort: sort) { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? [ClassroomPostList] {
                    self.questionList = data
                    DispatchQueue.main.async {
                        self.entireQuestionTV.reloadData()
                        self.entireQuestionTV.layoutIfNeeded()
                        self.entireQuestionTV.snp.updateConstraints {
                            $0.height.equalTo(self.entireQuestionTV.contentSize.height)
                        }
                    }
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            case .pathErr:
                print("pathErr")
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            case .serverErr:
                print("serverErr")
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "서버 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            case .networkFail:
                print("networkFail")
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}