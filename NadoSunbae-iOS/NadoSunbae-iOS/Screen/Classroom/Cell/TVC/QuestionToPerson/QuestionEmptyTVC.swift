//
//  QuestionEmptyTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit

final class QuestionEmptyTVC: UITableViewCell {

    // MARK: Properties
    private var emptyQuestionLabel = UILabel().then {
        $0.text = "등록된 1:1 질문이 없습니다."
        $0.textColor = .gray2
        $0.font = .PretendardR(size: 14.0)
        $0.sizeToFit()
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
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
extension QuestionEmptyTVC {
    private func configureUI() {
        contentView.addSubview(emptyQuestionLabel)
        
        emptyQuestionLabel.snp.makeConstraints {
            $0.centerX.equalTo(contentView)
            $0.top.equalToSuperview().offset(45)
            $0.bottom.equalToSuperview().inset(45)
        }
    }
}


// MARK: - Custom Methods
extension QuestionEmptyTVC {
    func setUpEmptyQuestionLabelText(text: String) {
        emptyQuestionLabel.text = text
    }
}
