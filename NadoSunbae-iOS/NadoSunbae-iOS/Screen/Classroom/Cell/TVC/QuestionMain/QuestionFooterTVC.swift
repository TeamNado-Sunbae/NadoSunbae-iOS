//
//  QuestionFooterTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit

class QuestionFooterTVC: UITableViewCell {

    // MARK: Properties
    private let seeEntireQuestionLabel = UILabel().then {
        $0.text = "질문 전체보기"
        $0.textColor = .lightMint
        $0.font = .PretendardR(size: 14.0.adjusted)
        $0.sizeToFit()
    }
    
    private let seeEntireQuestionBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "questionArrow"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.press {
            print("질문 전체보기")
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .nadoBlack
    }
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI
extension QuestionFooterTVC {
    private func configureUI() {
        contentView.addSubviews([seeEntireQuestionLabel, seeEntireQuestionBtn])
        
        seeEntireQuestionBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(5.adjustedH)
            $0.width.equalTo(9.adjusted)
            $0.centerY.equalTo(contentView)
        }
        
        seeEntireQuestionLabel.snp.makeConstraints {
            $0.trailing.equalTo(seeEntireQuestionBtn.snp.leading).offset(-8)
            $0.height.equalTo(18.adjustedH)
            $0.centerY.equalTo(contentView)
        }
    }
}
