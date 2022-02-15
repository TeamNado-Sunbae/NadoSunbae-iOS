//
//  InfoQuestionTVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/02/13.
//

import UIKit

class InfoQuestionTVC: BaseTVC {
    
    // MARK: IBOutlet
    @IBOutlet var infoTitleLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var majorInfoLabel: UILabel!
    @IBOutlet var questionContentTextView: UITextView! {
        didSet {
            questionContentTextView.delegate = self
            questionContentTextView.isEditable = false
            questionContentTextView.isScrollEnabled = false
            questionContentTextView.dataDetectorTypes = .link
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
