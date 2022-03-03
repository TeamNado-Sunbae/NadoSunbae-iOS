//
//  QuestionHeaderTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit

class QuestionHeaderTVC: BaseTVC {
    
    // MARK: Properties
    private let questionWriteBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "goToQuestion"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    var tapWriteBtnAction : (() -> ())?
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpTapQuestionWriteBtn()
        configureUI()
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI
extension QuestionHeaderTVC {
    private func configureUI() {
        contentView.addSubview(questionWriteBtn)
        
        questionWriteBtn.snp.makeConstraints {
            $0.trailing.equalTo(contentView).offset(-8)
            $0.height.equalTo(36.adjustedH)
            $0.width.equalTo(104.adjusted)
            $0.centerY.equalTo(contentView)
        }
    }
}

// MARK: - Custom Methods
extension QuestionHeaderTVC {
    
    /// '질문 작성' 버튼을 눌렀을 때 액션 set 메서드
    private func setUpTapQuestionWriteBtn() {
        questionWriteBtn.press(vibrate: true, for: .touchUpInside) {
            self.tapWriteBtnAction?()
        }
    }
}
