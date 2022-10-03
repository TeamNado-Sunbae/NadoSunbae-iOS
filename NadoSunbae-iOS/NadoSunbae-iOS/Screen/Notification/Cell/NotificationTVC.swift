//
//  NotificationTVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/17.
//

import UIKit

class NotificationTVC: BaseTVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var redCircleImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.lineBreakStrategy = .hangulWordPriority
            titleLabel.lineBreakMode = .byTruncatingTail
        }
    }
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UI
extension NotificationTVC {
    private func configureUI() {
        self.makeRounded(cornerRadius: 8.adjusted)
        self.backgroundColor = .clear
    }
}

// MARK: - Custom Methods
extension NotificationTVC {
    func setData(data: NotificationList) {
        redCircleImgView.isHidden = data.isRead
        profileImgView.image = UIImage(named: "profileImage\(data.sender.profileImageID)")
        
        titleLabel.text = getTitleLabelText(notiTypeInt: data.notificationTypeID, nickname: data.sender.nickname)
        contentLabel.text = "\(data.content)"
        timeLabel.text = data.createdAt.serverTimeToString(forUse: .forNotification)
        
        /// 알림 case별 텍스트 컬러 변경을 위한 Attribute 사용
        let mintAttributeStr = NSMutableAttributedString(string: titleLabel.text!)
        
        var attributedStr = ""
        
        switch data.notificationTypeID {
        case 1:
            attributedStr = "마이페이지"
        case 2, 3, 4, 5:
            attributedStr = "\(data.notificationTypeID.getNotiType().rawValue)"
        case 6:
            attributedStr = "1:1 질문글"
        case 7:
            attributedStr = "작성하신 1:1 질문글"
        case 8:
            attributedStr = "작성하신 커뮤니티 글"
        case 9:
            attributedStr = "답글을 작성하신 커뮤니티 글"
        case 10:
            attributedStr = "커뮤니티에 \(data.sender.nickname) 질문글"
        default:
            debugPrint("notification type error")
        }
        
        mintAttributeStr.addAttributes([.foregroundColor : UIColor.mainDefault], range: (titleLabel.text! as NSString).range(of: attributedStr))
        titleLabel.attributedText = mintAttributeStr
    }
    
    private func getTitleLabelText(notiTypeInt: Int, nickname: String?) -> String {
        switch notiTypeInt {
            
            /// 후배가 1:1 질문글 처음 작성 시
        case 1:
            return "마이페이지에 \(nickname ?? "") 님이 1:1 질문을 남겼습니다."
            
            /// (legacy) 내 글에 답글 달린 경우
        case 2, 3, 4, 5:
            return "\(notiTypeInt.getNotiType().rawValue)에 \(nickname ?? "") 님이 답글을 남겼습니다."
            
            /// 후배가 1:1 질문글에 답글 남긴 경우
        case 6:
            return "\(nickname ?? "") 님이 1:1 질문글에 답글을 남겼습니다."
            
            /// 선배가 1:1 질문글에 답글 남긴 경우
        case 7:
            return "작성하신 1:1 질문글에 \(nickname ?? "") 님이 답글을 남겼습니다."
            
            /// 본인이 작성한 커뮤니티 글에 답글 달린 경우
        case 8:
            return "작성하신 커뮤니티 글에 \(nickname ?? "") 님이 답글을 남겼습니다."
            
            /// 답글 작성한 커뮤니티 글에 답글 달린 경우
        case 9:
            return "답글을 작성하신 커뮤니티 글에 \(nickname ?? "") 님이 답글을 남겼습니다."
            
             /// 특정 학과 대상 질문글 알림
        case 10:
            return "커뮤니티에 \(nickname ?? "") 질문글이 올라왔습니다."
        default:
            debugPrint("notification type error")
            return ""
        }
    }
}
