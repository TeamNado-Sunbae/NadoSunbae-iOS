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
        
        let notiType = data.notificationType.getNotiType()
        
        titleLabel.text = "\(notiType!.rawValue)에 \(data.sender.nickname)님이 \(notiType != .mypageQuestion ? "답글" : "1:1 질문")을 남겼습니다."
        contentLabel.text = "\(data.content)"
        timeLabel.text = data.createdAt.serverTimeToString(forUse: .forNotification)
        
        /// 알림 case별 텍스트 컬러 변경을 위한 Attribute 사용
        let mintAttributeStr = NSMutableAttributedString(string: titleLabel.text!)
        
        switch notiType {
        case .mypageQuestion:
            mintAttributeStr.addAttributes([.foregroundColor : UIColor.mainDefault], range: (titleLabel.text! as NSString).range(of: "1:1 질문"))
        default:
            mintAttributeStr.addAttributes([.foregroundColor : UIColor.mainDefault], range: (titleLabel.text! as NSString).range(of: "\(notiType!.rawValue)"))
        }
        
        titleLabel.attributedText = mintAttributeStr
    }
}
