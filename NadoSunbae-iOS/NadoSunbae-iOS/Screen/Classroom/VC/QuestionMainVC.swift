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
        $0.isScrollEnabled = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    let questionSegmentView = NadoSegmentView()
    weak var sendSegmentStateDelegate: SendSegmentStateDelegate?
    var questionList = [
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다ㅏㅏㅏㅏ", nickName: "윈터내거", writeTime: "오후 5:33", commentCount: 2, likeCount: 5),
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다", nickName: "윈터내거", writeTime: "오후 5:33", commentCount: 2, likeCount: 5),
        MypageQuestionModel(title: "예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다", content: "예예예예질문내용입니다ㅏㅏㅏㅏ", nickName: "윈터내거", writeTime: "오후 5:33", commentCount: 2, likeCount: 5),
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다", nickName: "윈터내거", writeTime: "오후 5:33", commentCount: 2, likeCount: 5),
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다", nickName: "윈터내거", writeTime: "오후 5:33", commentCount: 2, likeCount: 5),
        MypageQuestionModel(title: "에스파는나야둘이될수없어", content: "예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다예예예예질문내용입니다", nickName: "윈터내거", writeTime: "오후 5:33", commentCount: 2, likeCount: 5)
    ]
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpDelegate()
        setUpTapInfoBtn()
        registerCell()
        DispatchQueue.main.async {
            self.entireQuestionTV.snp.makeConstraints {
                if self.questionList.count > 5 {
                    $0.height.equalTo(70 + 5 * 110 + 40)
                } else {
                    $0.height.equalTo(70 + self.questionList.count * 110)
                }
            }
        }
    }
}

// MARK: - UI
extension QuestionMainVC {
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
}

// MARK: - Custom Methods
extension QuestionMainVC {
    
    private func setUpDelegate() {
        entireQuestionTV.delegate = self
        entireQuestionTV.dataSource = self
    }
    
    private func registerCell() {
        entireQuestionTV.register(QuestionTVC.self, forCellReuseIdentifier: QuestionTVC.className)
        entireQuestionTV.register(QuestionHeaderTVC.self, forCellReuseIdentifier: QuestionHeaderTVC.className)
        entireQuestionTV.register(QuestionFooterTVC.self, forCellReuseIdentifier: QuestionFooterTVC.className)
    }
    
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionHeaderTVC.className, for: indexPath) as? QuestionHeaderTVC else { return UITableViewCell() }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionTVC.className, for: indexPath) as? QuestionTVC else { return UITableViewCell() }
            cell.setData(data: questionList[indexPath.row])
            return cell
        case 2:
            if questionList.count > 5 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: QuestionFooterTVC.className, for: indexPath) as? QuestionFooterTVC else { return UITableViewCell() }
                return cell
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
