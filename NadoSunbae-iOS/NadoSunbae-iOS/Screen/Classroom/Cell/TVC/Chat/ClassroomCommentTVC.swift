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
    @IBOutlet weak var uploadDateLabel: UILabel!
    @IBOutlet var moreBtn: UIButton!
    @IBOutlet var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var contentTextViewTopConstriaint: NSLayoutConstraint!
    
    // MARK: Properties
    weak var dynamicUpdateDelegate: TVCHeightDynamicUpdate?
    weak var changeCellDelegate: TVCContentUpdate?
    var tapMoreBtnAction : (() -> ())?
    var tapNicknameBtnAction : (() -> ())?
    var interactURL: ((_ data: URL) -> Void)?
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    @IBAction func tapNicknameBtn(_ sender: UIButton) {
        tapNicknameBtnAction?()
    }
}

// MARK: - UI
extension ClassroomCommentTVC {
    
    /// questionContentTextView style 구성하는 메서드
    private func configureQuestionContentTextView() {
        commentContentTextView.delegate = self
        commentContentTextView.isScrollEnabled = false
        commentContentTextView.isEditable = false
        commentContentTextView.setCharacterSpacing(-0.14)
        commentContentTextView.setLineSpacing(lineSpacing: 5)
        commentContentTextView.font = .PretendardR(size: 14.0)
        commentContentTextView.textColor = .mainText
        commentContentTextView.textContainer.lineFragmentPadding = 0
        commentContentTextView.dataDetectorTypes = .link
    }
    
    /// backView style 구성하는 메서드
    private func configureBackView() {
        backView.layer.borderWidth = 1
        backView.layer.borderColor = UIColor.chatStroke.cgColor
        backView.layer.cornerRadius = 8
    }
}

// MARK: - Custom Methods
extension ClassroomCommentTVC {
    
    /// 데이터 바인딩하는 메서드
    func bindData(_ model: CommentList) {
        nicknameLabel.text = model.writer.nickname
        majorLabel.text = convertToMajorInfoString(model.writer.firstMajorName, model.writer.firstMajorStart, model.writer.secondMajorName, model.writer.secondMajorStart)
        majorLabel.sizeToFit()
        commentContentTextView.text = model.content
        configureQuestionContentTextView()
        uploadDateLabel.text = model.createdAt.serverTimeToString(forUse: .forDefault)
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
    
    /// shouldInteractWith URL - 텍스트뷰 내 link와 interact하는 메서드
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        interactURL?(URL)
        return false
    }
}
