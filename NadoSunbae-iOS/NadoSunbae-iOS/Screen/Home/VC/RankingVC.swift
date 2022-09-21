//
//  RankingVC.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/19.
//

import UIKit
import SnapKit
import Then

final class RankingVC: BaseVC {
    
    // MARK: Properties
    private let naviView = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backWithCenterTitle)
        $0.configureTitleLabel(title: "선배랭킹")
        $0.rightCustomBtn.isHidden = true
    }
    
    private let infoView = NadoStatusBarView(contentText: "선배 랭킹은 어떻게 결정되나요?", type: .labelQuestionMarkButton)
    
    private let rankingTV = UITableView()
    
    private let infoContentView = UIView().then {
        $0.makeRounded(cornerRadius: 8.adjusted)
        $0.backgroundColor = .white
        $0.addShadow(offset: CGSize(width: 0, height: 4), color: .dropShadowColor, opacity: 1, radius: 66)
    }
    
    private let closeBtn = UIButton().then {
        $0.setImage(UIImage(named: "btnXblack"), for: .normal)
    }
    
    private let ruleLabel = UILabel().then {
        $0.text = "결정기준\n1순위  1:1 질문 답변율\n2순위  후기 작성여부\n3순위  닉네임 가나다순"
        $0.font = .PretendardR(size: 12)
        $0.textColor = .nadoBlack
        $0.textAlignment = .left
        $0.numberOfLines = 4
        $0.setTextColorWithLineSpacing(targetStringList: ["1순위", "2순위", "3순위"], color: .mainDark, lineSpacing: 4)
    }
    
    private var rankingList: [RankingListModel] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerTVC()
        setUpDelegate()
        initDummyData()
    }
}

// MARK: - UI
extension RankingVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([naviView, infoView, rankingTV, infoContentView])
        infoContentView.addSubviews([closeBtn, ruleLabel])
        rankingTV.backgroundColor = .paleGray
        rankingTV.separatorStyle = .none
        rankingTV.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 27, right: 0)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        rankingTV.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        infoContentView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(166)
            $0.height.equalTo(104)
        }
        
        closeBtn.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(4)
            $0.width.height.equalTo(32)
        }
        
        ruleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(40)
        }
    }
}

// MARK: - Custom Methods
extension RankingVC {
    
    /// 셀 등록 메서드
    private func registerTVC() {
        RankingTVC.register(target: rankingTV)
    }
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        rankingTV.delegate = self
        rankingTV.dataSource = self
    }
    
    private func initDummyData() {
        rankingList.append(contentsOf: [
            RankingListModel(id: 1, profileImageID: 1, nickname: "안녕하세요", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "디지털미디어학과", secondMajorStart: "19-1", rate: 100),
            RankingListModel(id: 2, profileImageID: 2, nickname: "선배닉네임최대는", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "디지털미디어학과", secondMajorStart: "20-1", rate: 80),
            RankingListModel(id: 3, profileImageID: 3, nickname: "하이", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "반도체어쩌구학과", secondMajorStart: "22-1", rate: 70),
            RankingListModel(id: 4, profileImageID: 4, nickname: "나는지은", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "반도체어쩌구학과 (세종)", secondMajorStart: "22-1", rate: 90),
            RankingListModel(id: 5, profileImageID: 5, nickname: "나도선배", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "반도체어쩌구학과", secondMajorStart: "22-1", rate: 80),
            RankingListModel(id: 6, profileImageID: 2, nickname: "정숙이는개발천재", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "반도체어쩌구학과", secondMajorStart: "22-1", rate: 10),
            RankingListModel(id: 7, profileImageID: 3, nickname: "선배닉네임최대는", firstMajorName: "경영학과", firstMajorStart: "18-1", secondMajorName: "경제학과", secondMajorStart: "22-1", rate: 20),
        ])
    }
}

// MARK: - UITableViewDelegate
extension RankingVC: UITableViewDelegate {
    
    /// cell 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104.adjustedH
    }
}

// MARK: - UITableViewDataSource
extension RankingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RankingTVC.className) as? RankingTVC else { return UITableViewCell() }

        cell.setData(data: rankingList[indexPath.row], indexPath: indexPath.row)
        return cell
    }
}
