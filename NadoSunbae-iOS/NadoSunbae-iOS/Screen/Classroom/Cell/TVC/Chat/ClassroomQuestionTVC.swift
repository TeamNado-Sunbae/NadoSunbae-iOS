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
    @IBOutlet var moreBtn: UIButton!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var questionContentTextView: UITextView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
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
extension ClassroomQuestionTVC {
    
    /// questionContentTextView style 구성하는 메서드
    private func configureQuestionContentTextView() {
        questionContentTextView.delegate = self
        questionContentTextView.isScrollEnabled = false
        questionContentTextView.isEditable = false
        questionContentTextView.sizeToFit()
    }
    
    /// backView style 구성하는 메서드
    private func configureBackView() {
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.gray1.cgColor
        backView.layer.cornerRadius = 8
    }
    
    /// titleLabel style 구성하는 메서드
    private func configureTitleLabel() {
        titleLabel.sizeToFit()
    }
}

// MARK: - Custom Methods
extension ClassroomQuestionTVC {
    
    /// 데이터 바인딩하는 메서드
    func bindData(_ model: ClassroomMessageList) {
        titleLabel.text = model.title
        nicknameLabel.text = model.writer.nickname
        majorLabel.text = convertToMajorInfoString(model.writer.firstMajorName, model.writer.firstMajorStart, model.writer.secondMajorName, model.writer.secondMajorStart)
        questionContentTextView.text = model.content
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
