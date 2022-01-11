//
//  ReviewMainPostTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewMainPostTVC: UITableViewCell, UITableViewRegisterable {
    
    /// Register할 Nib get
    static var isFromNib: Bool {
        get {
            return true
        }
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var diamondCountLabel: UILabel!
    @IBOutlet weak var firstTagImgView: UIImageView!
    @IBOutlet weak var secondTagImgView: UIImageView!
    @IBOutlet weak var thirdTagImgView: UIImageView!
    @IBOutlet weak var majorNameLabel: UILabel!
    @IBOutlet weak var secondMajorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(postData: ReviewPostData) {
        dateLabel.text = postData.date
        titleLabel.text = postData.title
        diamondCountLabel.text = "\(postData.diamondCount)"
        firstTagImgView.image = postData.makeFirstImg()
        secondTagImgView.image = postData.makeSecondImg()
        thirdTagImgView.image = postData.makeThirdImg()
        majorNameLabel.text = postData.majorName
        secondMajorNameLabel.text = postData.secondMajorName
    }
}

extension ReviewMainPostTVC {
    private func configureUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray0.cgColor
        contentView.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
    }
}
