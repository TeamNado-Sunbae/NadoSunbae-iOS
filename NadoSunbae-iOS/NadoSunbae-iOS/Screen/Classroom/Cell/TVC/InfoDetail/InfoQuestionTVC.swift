//
//  InfoQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/13.
//

import UIKit

class InfoQuestionTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet weak var infoTypeBtn: NadoSunbaeBtn! {
        didSet {
            infoTypeBtn.backgroundColor = .gray0
            infoTypeBtn.setTitleColor(.mainDefault, for: .normal)
            infoTypeBtn.isUserInteractionEnabled = false
            infoTypeBtn.makeRounded(cornerRadius: 8.adjusted)
        }
    }
    
    @IBOutlet var infoTitleLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorInfoLabel: UILabel!
    @IBOutlet var questionContentTextView: UITextView! {
        didSet {
            questionContentTextView.delegate = self
            questionContentTextView.isEditable = false
            questionContentTextView.isScrollEnabled = false
            questionContentTextView.dataDetectorTypes = .link
            questionContentTextView.textContainer.lineFragmentPadding = 0
            questionContentTextView.setCharacterSpacing(-0.14)
            questionContentTextView.setLineSpacing(lineSpacing: 5)
            questionContentTextView.font = .PretendardR(size: 14.0)
            questionContentTextView.textColor = .mainText
        }
    }
    @IBOutlet var postDateLabel: UILabel!
    @IBOutlet var infoLikeBackView: UIView! {
        didSet {
            infoLikeBackView.layer.cornerRadius = 16
        }
    }
    @IBOutlet var infoLikeBtn: UIButton!
    @IBOutlet var infoLikeImgView: UIImageView!
    @IBOutlet var infoLikeCountLabel: UILabel!
    
    // MARK: Properties
    var tapLikeBtnAction : (() -> ())?
    var tapNicknameBtnAction : (() -> ())?
    var interactURL: ((_ data: URL) -> Void)?
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: IBAction
    @IBAction func tapInfoLikeBtn(_ sender: UIButton) {
        tapLikeBtnAction?()
    }
    
    @IBAction func tapNicknameBtn(_ sender: UIButton) {
        tapNicknameBtnAction?()
    }
}

// MARK: - Custom Methods
extension InfoQuestionTVC {
    
    /// 데이터 바인딩하는 메서드
    func bindData(_ model: InfoDetailDataModel) {
        infoTitleLabel.text = model.post.title
        nicknameLabel.text = model.writer.nickname
        majorInfoLabel.text = convertToMajorInfoString(model.writer.firstMajorName, model.writer.firstMajorStart, model.writer.secondMajorName, model.writer.secondMajorStart)
        questionContentTextView.text = model.post.content
        postDateLabel.text = model.post.createdAt.serverTimeToString(forUse: .forDefault)
        infoLikeBackView.backgroundColor =  model.like.isLiked ? UIColor.nadoBlack : UIColor.gray0
        infoLikeImgView.image = model.like.isLiked ? UIImage(named: "heart_mint") : UIImage(named: "heart")
        infoLikeCountLabel.text = "\(model.like.likeCount)"
        infoLikeCountLabel.textColor = model.like.isLiked ? .mainDefault : .gray2
    }
    
    /// 정보글 타입에 따라 버튼의 title text를 설정하는 메서드
    func setInfoTypeTitle(_ type: String) {
        infoTypeBtn.setTitleWithStyle(title: type, size: 12.0, weight: .semiBold)
    }
}

// MARK: - UITextViewDelegate
extension InfoQuestionTVC: UITextViewDelegate {
    
    /// shouldInteractWith URL - 텍스트뷰 내 link와 interact하는 메서드
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        interactURL?(URL)
        return false
    }
}
