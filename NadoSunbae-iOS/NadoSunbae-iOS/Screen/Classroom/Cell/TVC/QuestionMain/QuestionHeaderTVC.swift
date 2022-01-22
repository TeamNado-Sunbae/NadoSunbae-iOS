//
//  QuestionHeaderTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit

class QuestionHeaderTVC: BaseTVC {
    
    // MARK: Properties
    private let headerTitleLabel = UILabel().then {
        $0.text = "구성원 모두가 답할 수 있어요!"
        $0.textColor = .mainDefault
        $0.font = .PretendardR(size: 14.0)
        $0.sizeToFit()
    }
    
    private let questionWriteBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "btnWrite"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    var tapWriteBtnAction : (() -> ())?
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 16, bottom: 11, right: 16))
    }
    
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
        contentView.addSubviews([headerTitleLabel, questionWriteBtn])
        
        questionWriteBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(104)
            $0.centerY.equalTo(contentView)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(questionWriteBtn.snp.leading).offset(-30)
            $0.centerY.equalTo(questionWriteBtn)
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
