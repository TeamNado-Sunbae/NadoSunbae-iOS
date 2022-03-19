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
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var likeImgView: UIImageView!
    @IBOutlet weak var reviewContentView: UIView!
    @IBOutlet weak var tagCV: UICollectionView!
    
    // MARK: Properties
    var tagImgList: [ReviewTagList] = []
    
    // MARK: Life Cycle Part
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        registerCVC()
        setUpCV()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// CVC 재사용 문제 해결을 위한 reload
    override func prepareForReuse() {
        tagCV.reloadData()
    }
}

// MARK: - UI
extension ReviewMainPostTVC {
    private func configureUI() {
        reviewContentView.layer.cornerRadius = 8
        reviewContentView.layer.borderWidth = 1
        reviewContentView.layer.borderColor = UIColor.gray0.cgColor
        reviewContentView.backgroundColor = .white
    }
}

// MARK: - Custom Methods
extension ReviewMainPostTVC {
    
    /// 리스트 데이터 세팅 함수
    func setData(postData: ReviewMainPostListData) {
        dateLabel.text = postData.createdAt.serverTimeToString(forUse: .forDefault)
        titleLabel.text = postData.oneLineReview
        likeCountLabel.text = "\(postData.like.likeCount)"
        let majorText = convertToUserInfoString(postData.writer.nickname, postData.writer.firstMajorName, postData.writer.firstMajorStart, postData.writer.secondMajorName, postData.writer.secondMajorStart)
        let attributedString = NSMutableAttributedString(string: majorText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray4, range: (majorText as NSString).range(of: postData.writer.nickname))
        attributedString.addAttribute(.font, value: UIFont.PretendardSB(size: 14), range: (majorText as NSString).range(of: postData.writer.nickname))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        majorLabel.attributedText = attributedString
        majorLabel.lineBreakStrategy = .hangulWordPriority
        majorLabel.sizeToFit()
        likeImgView.image = postData.like.isLiked ? UIImage(named: "heart_filled") : UIImage(named: "btn_heart")
    }
    
    /// 마이페이지 후기 리스트 데이터 세팅 함수
    func setUserReviewData(postData: MypageMyReviewPostModel) {
        dateLabel.text = postData.createdAt.serverTimeToString(forUse: .forDefault)
        titleLabel.text = postData.oneLineReview
        majorLabel.text = postData.majorName
        majorLabel.font = .PretendardSB(size: 14)
        majorLabel.textColor = .gray4
        likeCountLabel.text = "\(postData.like.likeCount)"
        likeImgView.image = postData.like.isLiked ? UIImage(named: "heart_filled") : UIImage(named: "btn_heart")
    }
    
    /// 마이페이지 후기 좋아요 리스트 데이터 세팅 함수
    func setMypageReviewLikeData(postData: MypageLikeReviewDataModel) {
        dateLabel.text = postData.createdAt.serverTimeToString(forUse: .forDefault)
        titleLabel.text = postData.title
        majorLabel.text = postData.writer.nickname
        majorLabel.font = .PretendardSB(size: 14)
        majorLabel.textColor = .gray4
        likeCountLabel.text = "\(postData.like.likeCount)"
        likeImgView.image = postData.like.isLiked ? UIImage(named: "heart_filled") : UIImage(named: "btn_heart")
    }
    
    private func registerCVC() {
        ReviewPostTagCVC.register(target: tagCV)
    }
    
    private func setUpCV() {
        tagCV.dataSource = self
        tagCV.delegate = self
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReviewMainPostTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var tagWidth: Int?
        
        // TODO: 서버통신 시 태그 이름으로 접근
        if tagImgList[indexPath.row].tagName == "꿀팁" {
            tagWidth = 35
        } else if tagImgList[indexPath.row].tagName == "뭘 배우나요?" {
            tagWidth = 75
        } else {
            tagWidth = 59
        }
        return CGSize(width: tagWidth ?? 59, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}

// MARK: - UICollectionViewDataSource
extension ReviewMainPostTVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagImgList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewPostTagCVC.className, for: indexPath) as? ReviewPostTagCVC else { return UICollectionViewCell() }
        cell.setData(tagData: tagImgList[indexPath.row])
        return cell
    }   
}

