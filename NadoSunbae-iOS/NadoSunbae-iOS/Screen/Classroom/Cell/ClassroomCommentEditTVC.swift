//
//  ClassroomCommentEditTVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/11.
//

import UIKit

class ClassroomCommentEditTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet var backView: UIView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var commentContentTextView: UITextView!
    @IBOutlet var nadoBtn: NadoSunbaeBtn! {
        didSet {
            nadoBtn.isActivated = true
            nadoBtn.setTitle("확인", for: .normal)
        }
    }
    
    // MARK: Properties
    weak var dynamicUpdateDelegate: TVCHeightDynamicUpdate?
    weak var changeCellDelegate: TVCContentUpdate?
    var btnAction : (() -> ())?
    
    // MARK: Life Cycles
    override func awakeFromNib() {
        super.awakeFromNib()
        configurequestionContentTextView()
        configureBackView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tapMoreBtn(_ sender: UIButton) {
        btnAction?()
        
        if let changeCellDelegate = changeCellDelegate {
            changeCellDelegate.updateTV()
        }
    }
    
    func bind(_ model: DefaultQuestionDataModel) {
        nicknameLabel.text = model.nickname
        majorLabel.text = model.majorInfo
        commentContentTextView.text = model.contentText
    }
}
// MARK: - UI
extension ClassroomCommentEditTVC {
    
    /// questionContentTextView style 구성하는 메서드
    func configurequestionContentTextView() {
        commentContentTextView.delegate = self
        commentContentTextView.isScrollEnabled = false
        commentContentTextView.isEditable = true
        commentContentTextView.sizeToFit()
    }
    
    /// backView style 구성하는 메서드
    func configureBackView() {
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.gray1.cgColor
        backView.layer.cornerRadius = 8
        backView.addShadow(location: .bottomRight, color: UIColor.gray3, opacity: 0.5, radius: 8)
    }
}

// MARK: - UITextViewDelegate
extension ClassroomCommentEditTVC: UITextViewDelegate {
    
    /// textView가 변화할 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        
        if let delegate = dynamicUpdateDelegate {
            delegate.updateTextViewHeight(cell: self, textView: textView)
        }
    }
}
