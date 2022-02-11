//
//  ReviewDetailPostTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailPostTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var backView: UIView! {
        didSet {
            backView.makeRounded(cornerRadius: 40.adjusted)
        }
    }
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.sizeToFit()
            contentLabel.setLineSpacing(lineSpacing: 5)
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Custom Methods
extension ReviewDetailPostTVC {
    
    /// 리스트 데이터 세팅 함수
    func setData(postData: PostContent) {
        if postData.title == "뭘 배우나요?" {
            iconImgView.image = UIImage(named: "pencil")
        } else if postData.title == "추천 수업" {
            iconImgView.image = UIImage(named: "diamond")
        } else if postData.title == "비추 수업" {
            iconImgView.image = UIImage(named: "bomb")
        } else if postData.title == "향후 진로" {
            iconImgView.image = UIImage(named: "compass")
        } else if postData.title == "꿀팁" {
            iconImgView.image = UIImage(named: "honey")
        }
        titleLabel.text = postData.title
        contentLabel.text = postData.content
    }
}
