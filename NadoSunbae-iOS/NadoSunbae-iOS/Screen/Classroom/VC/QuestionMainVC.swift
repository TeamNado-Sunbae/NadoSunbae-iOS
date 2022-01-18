//
//  QuestionMainVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit
import SnapKit
import Then

class QuestionMainVC: UIViewController {
    
    // MARK: Properties
    private let questionSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    private let contentView = UIView()
    private let personalQuestionBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "imgRoomMain"), for: .normal)
        $0.contentMode = .scaleAspectFill
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
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpDelegate()
        setUpTapInfoBtn()
        registerCell()
        configureQuestionTVHeight()
        setUpTapPersonalQuestionBtn()
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
            $0.height.equalTo(38)
        }
        
        personalQuestionBtn.snp.makeConstraints {
            $0.top.equalTo(questionSegmentView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(176)
        }
        
        entireQuestionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(personalQuestionBtn.snp.bottom).offset(24)
            $0.leading.equalTo(personalQuestionBtn)
        }
        
        entireQuestionTV.snp.makeConstraints {
            $0.top.equalTo(entireQuestionTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(personalQuestionBtn)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        entireQuestionTV.separatorColor = .gray1
    }
    
    /// entireQuestionTV 높이를 구성하는 메서드
    private func configureQuestionTVHeight() {
        DispatchQueue.main.async {
            self.entireQuestionTV.snp.makeConstraints {
                if questionList.count > 5 {
                    $0.height.equalTo(70 + 5 * 110 + 40)
                } else if questionList.count == 0 {
                    $0.height.equalTo(70 + 236)
                } else {
                    $0.height.equalTo(70 + questionList.count * 110)
                }
            }
        }
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
            self.navigationController?.pushViewController(questionPersonVC, animated: true)
        }
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
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return (questionList.count == 0 ? 236 : 110)
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
            
            // TODO: 추후에 Usertype, isWriter 정보도 함께 넘길 예정(?)
            groupChatVC.questionType = .group
            groupChatVC.naviStyle = .push
            
            self.navigationController?.pushViewController(groupChatVC, animated: true)
        } else if indexPath.section == 2 {
            let entireQuestionVC = EntireQuestionListVC()
            self.navigationController?.pushViewController(entireQuestionVC, animated: true)
        }
    }
}
