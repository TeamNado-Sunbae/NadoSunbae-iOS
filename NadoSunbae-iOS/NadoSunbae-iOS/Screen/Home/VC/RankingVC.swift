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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI
extension RankingVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([naviView, infoView, rankingTV, infoContentView])
        infoContentView.addSubviews([closeBtn, ruleLabel])
        rankingTV.backgroundColor = .paleGray
        
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
