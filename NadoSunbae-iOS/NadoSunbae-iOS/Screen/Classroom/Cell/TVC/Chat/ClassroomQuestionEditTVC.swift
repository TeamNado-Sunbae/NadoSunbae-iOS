//
//  ClassroomQuestionEditTVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/11.
//

import UIKit

class ClassroomQuestionEditTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet var backView: UIView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var commentContentTextView: UITextView! {
        didSet {
            commentContentTextView.layer.borderWidth = 1
            commentContentTextView.layer.borderColor = UIColor.gray1.cgColor
            commentContentTextView.layer.cornerRadius = 4
        }
    }
    
    @IBOutlet var confirmBtn: NadoSunbaeBtn! {
        didSet {
            confirmBtn.isActivated = true
            confirmBtn.setTitleWithStyle(title: "확인", size: 14.0, weight: .semiBold)
            confirmBtn.setTitleColor(.mainLight, for: .normal)
        }
    }
    
    @IBOutlet weak var cancelBtn: NadoSunbaeBtn! {
        didSet {
            cancelBtn.isActivated = true
            cancelBtn.setTitleWithStyle(title: "취소", size: 14.0, weight: .semiBold)
            cancelBtn.setTitleColor(.mainText, for: .normal)
            cancelBtn.backgroundColor = UIColor(red: 209/255, green: 242/255, blue: 238/255, alpha: 1.0)
        }
    }
    
    @IBOutlet weak var questionEditTextViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    weak var dynamicUpdateDelegate: TVCHeightDynamicUpdate?
    var tapConfirmBtnAction : (() -> ())?
    var tapCancelBtnAction : (() -> ())?
    private let textViewMaxHeight: CGFloat = 170
    
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
    @IBAction func tapConfirmBtn(_ sender: NadoSunbaeBtn) {
        tapConfirmBtnAction?()
    }
    
    @IBAction func tapCancelBtn(_ sender: NadoSunbaeBtn) {
        tapCancelBtnAction?()
    }
}

// MARK: - UI
extension ClassroomQuestionEditTVC {
    
    /// questionContentTextView style 구성하는 메서드
    private func configureQuestionContentTextView() {
        commentContentTextView.delegate = self
        commentContentTextView.isScrollEnabled = false
        commentContentTextView.isEditable = true
        commentContentTextView.sizeToFit()
    }
    
    /// backView style 구성하는 메서드
    private func configureBackView() {
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.gray1.cgColor
        backView.layer.cornerRadius = 8
        backView.addShadow(location: .bottomRight, color: UIColor.gray3, opacity: 0.5, radius: 8)
    }
}

// MARK: - Custom Methods
extension ClassroomQuestionEditTVC {
    
    /// 데이터 바인딩하는 메서드
    func bindData(_ model: ClassroomMessageList) {
        nicknameLabel.text = model.writer.nickname
        majorLabel.text = convertToMajorInfoString(model.writer.firstMajorName, model.writer.firstMajorStart, model.writer.secondMajorName, model.writer.secondMajorStart)
        commentContentTextView.text = model.content
    }
}

// MARK: - UITextViewDelegate
extension ClassroomQuestionEditTVC: UITextViewDelegate {
    
    /// textView가 변화할 때마다 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = dynamicUpdateDelegate {
            delegate.updateTextViewHeight(cell: self, textView: textView)
        }
        
        if textView.contentSize.height >= self.textViewMaxHeight {
            questionEditTextViewHeight.constant = self.textViewMaxHeight
            textView.isScrollEnabled = true
        } else {
            questionEditTextViewHeight.constant = textView.contentSize.height
            textView.isScrollEnabled = false
        }
    }
}
