//
//  InfoCommentTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/13.
//

import UIKit

class InfoCommentTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet var profileImgView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorInfoLabel: UILabel! {
        didSet {
            majorInfoLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var commentTextView: UITextView! {
        didSet {
            commentTextView.delegate = self
            commentTextView.isEditable = false
            commentTextView.isScrollEnabled = false
            commentTextView.dataDetectorTypes = .link
            commentTextView.textContainer.lineFragmentPadding = 0
            commentTextView.setCharacterSpacing(-0.14)
            commentTextView.setLineSpacing(lineSpacing: 5)
            commentTextView.font = .PretendardR(size: 14.0)
            commentTextView.textColor = .gray4
        }
    }
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet var commentDateLabel: UILabel!
    @IBOutlet var writerImgView: UIImageView!
    
    // MARK: Properties
    var tapMoreInfoBtnAction: (() -> ())?
    var tapNicknameBtnAction: (() -> ())?
    var tapProfileImgBtnAction: (() -> ())?
    var interactURL: ((_ data: URL) -> Void)?
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: IBAction
    @IBAction func tapMoreInfoBtn(_ sender: UIButton) {
        tapMoreInfoBtnAction?()
    }
    
    @IBAction func tapNicknameBtn(_ sender: UIButton) {
        tapNicknameBtnAction?()
    }
    
    @IBAction func tapProfileImgBtn(_ sender: UIButton) {
        tapProfileImgBtnAction?()
    }
}

// MARK: - Custom Methods
extension InfoCommentTVC {
    
    /// 데이터 바인딩하는 메서드
    func bindData(model: CommentList) {
        profileImgView.image = UIImage(named: "profileImage\(model.writer.profileImageID)")
        nicknameLabel.text = model.writer.nickname
        writerImgView.isHidden = !(model.writer.isPostWriter ?? false)
        
        let majorInfoString = convertToMajorInfoString(model.writer.firstMajorName, model.writer.firstMajorStart, model.writer.secondMajorName, model.writer.secondMajorStart)
        
        if majorInfoString.count >= 36 {
            majorInfoLabel.text = majorInfoString.makeLineBreakMajorText()
        } else {
            majorInfoLabel.text = majorInfoString
        }
        
        commentTextView.text = model.content
        commentDateLabel.text = model.createdAt.serverTimeToString(forUse: .forDefault)
        setLabelSizeToFit()
    }
    
    /// infoBtn을 숨김처리하는 메서드 (isDeleted에 따라)
    func hideInfoBtn(isDeleted: Bool) {
        infoBtn.isHidden = isDeleted ? true : false
    }
    
    /// label sizeToFit 일괄 적용 메서드
    func setLabelSizeToFit() {
        [nicknameLabel, majorInfoLabel, commentDateLabel].forEach {
            $0?.sizeToFit()
        }
    }
}

// MARK: - UITextViewDelegate
extension InfoCommentTVC: UITextViewDelegate {
    
    /// shouldInteractWith URL - 텍스트뷰 내 link와 interact하는 메서드
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        interactURL?(URL)
        return false
    }
}
