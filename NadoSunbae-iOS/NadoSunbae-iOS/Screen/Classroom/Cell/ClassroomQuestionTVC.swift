//
//  ClassroomQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/10.
//

import UIKit

class ClassroomQuestionTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet var backView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var questionContentTextView: UITextView!
    
    // MARK: Properties
    weak var dynamicUpdateDelegate: TVCHeightDynamicUpdate?
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureQuestionContentTextView()
        configureBackView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UI
extension ClassroomQuestionTVC {
    
    /// questionContentTextView style 구성하는 메서드
    func configureQuestionContentTextView() {
        questionContentTextView.delegate = self
        questionContentTextView.isScrollEnabled = false
        questionContentTextView.isEditable = false
        questionContentTextView.sizeToFit()
    }
    
    /// backView style 구성하는 메서드
    func configureBackView() {
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.gray1.cgColor
        backView.layer.cornerRadius = 8
    }
    
    /// titleLabel style 구성하는 메서드
    func configureTitleLabel() {
        titleLabel.sizeToFit()
    }
}

// MARK: - Custom Methods
extension ClassroomQuestionTVC {
    
    /// 데이터 바인딩하는 메서드
    func bind(_ model: DefaultQuestionDataModel) {
        titleLabel.text = model.questionTitle
        nicknameLabel.text = model.nickname
        majorLabel.text = model.majorInfo
        questionContentTextView.text = model.contentText
    }
}

// MARK: - UITextViewDelegate
extension ClassroomQuestionTVC: UITextViewDelegate {
    
    /// textView가 변화할 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = dynamicUpdateDelegate {
            delegate.updateTextViewHeight(cell: self, textView: textView)
        }
    }
}
