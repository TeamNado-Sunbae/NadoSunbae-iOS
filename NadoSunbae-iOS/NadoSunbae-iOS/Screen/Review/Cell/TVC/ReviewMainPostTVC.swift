//
//  ReviewMainPostTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/11.
//

import UIKit

class ReviewMainPostTVC: BaseTVC {

    // MARK: IBOutlet
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var diamondCountLabel: UILabel!
    @IBOutlet weak var firstTagImgView: UIImageView!
    @IBOutlet weak var secondTagImgView: UIImageView!
    @IBOutlet weak var thirdTagImgView: UIImageView!
    @IBOutlet weak var majorNameLabel: UILabel!
    @IBOutlet weak var secondMajorNameLabel: UILabel!
    
    // MARK: Life Cycle Part
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
//        setGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Private Methods
    
    /// 리스트 데이터 세팅 함수
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
    
//    /// tapGesture 세팅 함수
//    func setGesture() {
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapPost(gestureRecognizer:)))
//
//        contentView.addGestureRecognizer(tapRecognizer)
//        print("tapped")
//    }
    
//    // MARK: @objc Function
//    @objc func tapPost(gestureRecognizer: UITapGestureRecognizer) {
//        postDelegate?.tapPostCell(cell: self)
//        print("탭")
//    }
}

// MARK: - UI
extension ReviewMainPostTVC {
    private func configureUI() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray0.cgColor
        contentView.backgroundColor = .white
    }
    
    /// TVC 사이 간격 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16))
    }
}
