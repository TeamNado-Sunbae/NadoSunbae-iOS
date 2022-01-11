//
//  ClassroomCommentTVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/10.
//

import UIKit

class ClassroomCommentTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet var backView: UIView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var commentContentTextView: UITextView!
    
    // MARK: Properties
    weak var dynamicUpdateDelegate: TVCHeightDynamicUpdate?
    weak var changeCellDelegate: TVCContentUpdate?
    var tapMoreBtnAction : (() -> ())?
    
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureQuestionContentTextView()
        configureBackView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: IBAction
    @IBAction func tapMoreBtn(_ sender: UIButton) {
        tapMoreBtnAction?()
        
        if let changeCellDelegate = changeCellDelegate {
            changeCellDelegate.updateTV()
        }
    }
}

// MARK: - UI
extension ClassroomCommentTVC {
    
    /// questionContentTextView style 구성하는 메서드
    func configureQuestionContentTextView() {
        commentContentTextView.delegate = self
        commentContentTextView.isScrollEnabled = false
        commentContentTextView.isEditable = false
        commentContentTextView.sizeToFit()
    }
    
    /// backView style 구성하는 메서드
    func configureBackView() {
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.gray1.cgColor
        backView.layer.cornerRadius = 8
    }
}

// MARK: - Custom Methods
extension ClassroomCommentTVC {
    
    /// 데이터 바인딩하는 메서드
    func bind(_ model: DefaultQuestionDataModel) {
        nicknameLabel.text = model.nickname
        majorLabel.text = model.majorInfo
        commentContentTextView.text = model.contentText
    }
}

// MARK: - UITextViewDelegate
extension ClassroomCommentTVC: UITextViewDelegate {
    
    /// textView가 변화할 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = dynamicUpdateDelegate {
            delegate.updateTextViewHeight(cell: self, textView: textView)
        }
    }
}
