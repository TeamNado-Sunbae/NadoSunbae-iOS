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
    }
    
    let questionSegmentView = NadoSegmentView()
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    var questionList: [MypageQuestionModel] = [
        MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
        MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
        MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
        MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
        MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
        MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111),
        MypageQuestionModel(title: "호랑이", content: "광야의 딸", nickName: "유영진", writeTime: "0107", commentCount: 1, likeCount: 11111)
    ]
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpDelegate()
        setUpTapInfoBtn()
        registerCell()
        configureQuestionTVHeight()
    }
}

// MARK: - UI
extension QuestionMainVC {
    
    /// 전체 UI를 구성하는 메서드
    func configureUI() {
        
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
    }
    
    /// entireQuestionTV 높이를 구성하는 메서드
    func configureQuestionTVHeight() {
        DispatchQueue.main.async {
            self.entireQuestionTV.snp.makeConstraints {
                if self.questionList.count > 5 {
                    $0.height.equalTo(70 + 5 * 110 + 40)
                } else if self.questionList.count == 0 {
                    $0.height.equalTo(70 + 236)
                } else {
                    $0.height.equalTo(70 + self.questionList.count * 110)
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
        entireQuestionTV.register(QuestionTVC.self, forCellReuseIdentifier: QuestionTVC.className)
        entireQuestionTV.register(QuestionHeaderTVC.self, forCellReuseIdentifier: QuestionHeaderTVC.className)
        entireQuestionTV.register(QuestionFooterTVC.self, forCellReuseIdentifier: QuestionFooterTVC.className)
        entireQuestionTV.register(QuestionEmptyTVC.self, forCellReuseIdentifier: QuestionEmptyTVC.className)
    }
    
    /// '정보' 버튼을 눌렀을 때 액션 set 메서드
    private func setUpTapInfoBtn() {
        questionSegmentView.infoBtn.press {
            
            if let delegate = self.sendSegmentStateDelegate {
                delegate.sendSegmentClicked(index: 1)
            }
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
            if questionList.count == 0 {
                return 1
            } else {
                if questionList.count > 5 {
                    return 5
                } else {
                    return questionList.count
                }
            }
        case 2:
            if questionList.count > 5 {
                return 1
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    /// cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return QuestionHeaderTVC()
        case 1:
            if questionList.count == 0 {
                guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: QuestionEmptyTVC.className, for: indexPath) as? QuestionEmptyTVC else { return UITableViewCell() }
                emptyCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                return emptyCell
            } else {
                guard let questionCell = tableView.dequeueReusableCell(withIdentifier: QuestionTVC.className, for: indexPath) as? QuestionTVC else { return UITableViewCell() }
                
                /// 마지막 인덱스만 separator 숨김
                if indexPath.row == questionList.count - 1 {
                    questionCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                }
                questionCell.setData(data: questionList[indexPath.row])
                return questionCell
            }
        case 2:
            if questionList.count > 5 {
                return QuestionFooterTVC()
            } else {
                return UITableViewCell()
            }
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
            if questionList.count == 0 {
                return 236
            } else {
                return 110
            }
        case 2:
            if questionList.count > 5 {
                return 40
            } else {
                return 0
            }
        default:
            return 0
        }
    }
}
