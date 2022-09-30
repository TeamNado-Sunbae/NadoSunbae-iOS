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
    @IBOutlet weak var likeBtn: UIButton! {
        didSet {
            likeBtn.press(vibrate: true, for: .touchUpInside){}
        }
    }
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var uploadDateLabel: UILabel!
    @IBOutlet var contentTextViewTopConstriaint: NSLayoutConstraint!
    @IBOutlet var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var moreBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet var nicknameLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    weak var dynamicUpdateDelegate: TVCHeightDynamicUpdate?
    weak var changeCellDelegate: TVCContentUpdate?
    var tapLikeBtnAction : (() -> ())?
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
    @IBAction func tapLikeBtn(_ sender: UIButton) {
        tapLikeBtnAction?()
    }
    
    @IBAction func tapMoreBtn(_ sender: UIButton) {
        tapMoreBtnAction?()
    }
    
    @IBAction func tapNicknameBtn(_ sender: UIButton) {
        tapNicknameBtnAction?()
    }
}

// MARK: - UI
extension ClassroomQuestionTVC {
    
    /// questionContentTextView style 구성하는 메서드
    private func configureQuestionContentTextView() {
        questionContentTextView.delegate = self
        questionContentTextView.isScrollEnabled = false
        questionContentTextView.isEditable = false
        questionContentTextView.setCharacterSpacing(-0.14)
        questionContentTextView.setLineSpacing(lineSpacing: 5)
        questionContentTextView.font = .PretendardR(size: 14.0)
        questionContentTextView.textColor = .nadoBlack
        questionContentTextView.textContainer.lineFragmentPadding = 0
        questionContentTextView.dataDetectorTypes = .link
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
    func bindQuestionData(_ model: DetailPost) {
        titleLabel.text = model.title
        questionContentTextView.text = model.content
        questionContentTextView.sizeToFit()
        configureQuestionContentTextView()
        uploadDateLabel.text = model.createdAt.serverTimeToString(forUse: .forDefault)
    }

    func bindCommentData(_ model: CommentList) {
        titleLabel.text = ""
        questionContentTextView.text = model.content
        questionContentTextView.sizeToFit()
        configureQuestionContentTextView()
        uploadDateLabel.text = model.createdAt.serverTimeToString(forUse: .forDefault)
    }
    
    func bindWriterData(_ model: PostDetailWriter) {
        nicknameLabel.text = model.nickname
        majorLabel.text = convertToMajorInfoString(model.firstMajorName, model.firstMajorStart, model.secondMajorName, model.secondMajorStart)
    }
    
    func bindLikeData(_ model: Like) {
        likeCountLabel.text = "\(model.likeCount)"
        likeBtn.setBackgroundImage(UIImage(named: model.isLiked ? "heart_filled" : "btn_heart") , for: .normal)
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
    
    /// shouldInteractWith URL - 텍스트뷰 내 link와 interact하는 메서드
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        interactURL?(URL)
        return false
    }
}
