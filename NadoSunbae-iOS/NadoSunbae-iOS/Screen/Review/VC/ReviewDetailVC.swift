//
//  ReviewDetailVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailVC: BaseVC {
    
    // MARK: IBOutlet
    @IBOutlet weak var naviBarView: NadoSunbaeNaviBar! {
        didSet {
            naviBarView.setUpNaviStyle(state: .backDefaultWithCustomRightBtn)
            naviBarView.rightCustomBtn.setImage(UIImage(named: "btnMoreVert"), for: .normal)
            naviBarView.configureTitleLabel(title: "학과후기")
        }
    }
    
    /// 게시글 길이에 따른 동적 높이 셀 구현
    @IBOutlet weak var reviewPostTV: UITableView! {
        didSet {
            reviewPostTV.rowHeight = UITableView.automaticDimension
        }
    }
    @IBOutlet weak var likeCountView: UIView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImgView: UIImageView!
    
    // MARK: Properties
    var detailPost: ReviewPostDetailData = ReviewPostDetailData(like: Like(isLiked: false, likeCount: 0), backgroundImage: BackgroundImage(imageID: 0))
    var postId: Int?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTVC()
        setUpTV()
        configureUI()
        presentActionSheet()
        setUpTapNaviBackBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        requestGetReviewPostDetail(postID: postId ?? -1)
    }
    
    @IBAction func tapLikeBtn(_ sender: Any) {
        self.requestPostReviewDetailLikeData(postID: postId ?? 0, postTypeID: .review)
    }
}

// MARK: - UI
extension ReviewDetailVC {
    private func configureUI() {
        likeCountView.makeRounded(cornerRadius: 16.adjusted)
    }
    
    /// NaviBar dropShadow 설정 함수
    private func addShadowToNaviBar() {
        naviBarView.layer.shadowColor = UIColor(red: 0.898, green: 0.898, blue: 0.91, alpha: 0.16).cgColor
        naviBarView.layer.shadowOffset = CGSize(width: 0, height: 9)
        naviBarView.layer.shadowRadius = 18
        naviBarView.layer.shadowOpacity = 1
        naviBarView.layer.masksToBounds = false
    }
}

// MARK: - Custom Methods
extension ReviewDetailVC {
    private func registerTVC() {
        ReviewDetailPostWithImgTVC.register(target: reviewPostTV)
        ReviewDetailPostTVC.register(target: reviewPostTV)
        ReviewDetailProfileTVC.register(target: reviewPostTV)
    }
    
    private func setUpTV() {
        reviewPostTV.dataSource = self
        reviewPostTV.delegate = self
    }
    
    /// 액션 시트
    private func presentActionSheet() {
        naviBarView.rightCustomBtn.press {
            
            /// 내가 작성한 글인 경우 수정, 삭제
            if self.detailPost.writer.writerID == UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID) {
                self.makeTwoAlertWithCancel(okTitle: "수정", secondOkTitle: "삭제", okAction: { _ in
                    self.sendDetailPostData()
                }, secondOkAction: { _ in
                    guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
                    alert.showNadoAlert(vc: self, message: "삭제하시겠습니까?", confirmBtnTitle: "삭제", cancelBtnTitle: "아니요")
                    alert.confirmBtn.press {
                        self.requestDeleteReviewPost(postID: self.postId ?? -1)
                    }
                })
            } else {
                
                /// 타인 작성 글인 경우 신고
                self.makeAlertWithCancel(okTitle: "신고", okAction: { _ in print("신고")})
            }
        }
    }
    
    /// 네비 back 버튼을 눌렀을 때 액션 set 메서드
    private func setUpTapNaviBackBtn() {
        naviBarView.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// 화면 상단에 닿으면 스크롤 disable
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
    /// 좋아요 클릭 시 상태에 따라 아이콘, 배경색, label 설정
    private func setUpLikeStatus(model: Like) {
        if model.isLiked {
            likeImgView.image = UIImage(named: "heart_filled")
            likeCountView.layer.backgroundColor = UIColor.mainBlack.cgColor
            likeCountLabel.setLabel( text: "\(model.likeCount)", color: UIColor.mainDefault, size: 14, weight: .semiBold)
        } else {
            likeImgView.image = UIImage(named: "btn_heart")
            likeCountView.layer.backgroundColor = UIColor.gray0.cgColor
            likeCountLabel.setLabel( text: "\(model.likeCount)", color: UIColor.gray2, size: 14, weight: .regular)
        }
    }
    
    /// UserDefaults의 isReviewed 값 설정
    private func setUpIsReviewedStatus(model: ReviewDeleteResModel) {
        UserDefaults.standard.set(model.isReviewed, forKey: UserDefaults.Keys.IsReviewed)
    }
    
    /// 후기 수정 위한 기존 데이터 전달 함수
    private func sendDetailPostData() {
        
        /// 후기 작성 뷰로 이동
        let ReviewWriteSB = UIStoryboard.init(name: "ReviewWriteSB", bundle: nil)
        guard let nextVC = ReviewWriteSB.instantiateViewController(withIdentifier: ReviewWriteVC.className) as? ReviewWriteVC else { return }
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
        
        /// 기존 작성 내용 전달
        nextVC.setReceivedData(status: false, postId: self.detailPost.post.postID)
        nextVC.oneLineReviewTextView.textColor = .mainText
        nextVC.oneLineReviewTextView.text = self.detailPost.post.oneLineReview
        
        let contentTitleDict: [String : UITextView] = ["장단점" : nextVC.prosAndConsTextView, "뭘 배우나요?" : nextVC.learnInfoTextView, "추천 수업" : nextVC.recommendClassTextView, "비추 수업" :  nextVC.badClassTextView, "향후 진로" : nextVC.futureTextView, "꿀팁" : nextVC.tipTextView]
        var newContentTitleDict = [String : UITextView]()
        var newContentDict = [String : String]()
        
        for i in 0..<self.detailPost.post.contentList.count {
            newContentTitleDict.updateValue(contentTitleDict[self.detailPost.post.contentList[i].title] ?? UITextView(), forKey: self.detailPost.post.contentList[i].title)
            newContentDict.updateValue(self.detailPost.post.contentList[i].content, forKey: self.detailPost.post.contentList[i].title)
        }
        
        newContentTitleDict.forEach {
            $0.value.textColor = .mainText
            $0.value.text = newContentDict[$0.key]
        }
    }
}

// MARK: - UITableViewDelegate
extension ReviewDetailVC: UITableViewDelegate {
    
    /// section 3개로 나눔
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else if indexPath.section == 1 {
            return UITableView.automaticDimension
        } else if indexPath.section == 2{
            return 172
        } else {
            return 0
        }
    }
}

// MARK: - UITableViewDataSource
extension ReviewDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailPost.post.postID == -1 {
            return 0
        } else {
            if section == 0 {
                return 1
            } else if section == 1 {
                return detailPost.post.contentList.count - 1
            } else if section == 2 {
                return 1
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviewDetailPostWithImgTVC = tableView.dequeueReusableCell(withIdentifier: ReviewDetailPostWithImgTVC.className) as? ReviewDetailPostWithImgTVC,
              let reviewDetailPostTVC = tableView.dequeueReusableCell(withIdentifier: ReviewDetailPostTVC.className) as? ReviewDetailPostTVC,
              let reviewDetailProfileTVC = tableView.dequeueReusableCell(withIdentifier: ReviewDetailProfileTVC.className) as? ReviewDetailProfileTVC else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            reviewDetailPostWithImgTVC.setData(postData: detailPost)
            return reviewDetailPostWithImgTVC
        } else if indexPath.section == 1 {
            reviewDetailPostTVC.contentLabel.sizeToFit()
            reviewDetailPostTVC.setData(postData: detailPost.post.contentList[indexPath.row + 1])
            return reviewDetailPostTVC
        } else if indexPath.section == 2 {
            reviewDetailProfileTVC.setData(profileData: detailPost.writer)
            return reviewDetailProfileTVC
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            guard let nextVC = UIStoryboard.init(name: MypageUserVC.className, bundle: nil).instantiateViewController(withIdentifier: MypageUserVC.className) as? MypageUserVC else { return }
            
            nextVC.targetUserID = detailPost.writer.writerID
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

// MARK: - Network

/// 후기글 상세 조회
extension ReviewDetailVC {
    func requestGetReviewPostDetail(postID: Int) {
        self.activityIndicator.startAnimating()
        ReviewAPI.shared.getReviewPostDetailAPI(postID: postID) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if let data = res as? ReviewPostDetailData {
                    self.detailPost = data
                    self.setUpLikeStatus(model: self.detailPost.like)
                    self.reviewPostTV.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 후기 상세뷰에서 좋아요 API 요청 메서드
    func requestPostReviewDetailLikeData(postID: Int, postTypeID: QuestionType) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.postClassroomLikeAPI(chatPostID: postID, postTypeID: postTypeID.rawValue) { networkResult in
            switch networkResult {
            case .success(let res):
                if let _ = res as? PostLikeResModel {
                    self.requestGetReviewPostDetail(postID: postID)
                    print(res)
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 후기글 삭제 API 요청 메서드
    func requestDeleteReviewPost(postID: Int) {
        self.activityIndicator.startAnimating()
        ReviewAPI.shared.deleteReviewPostAPI(postID: postID) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if let data = res as? ReviewDeleteResModel {
                    self.setUpIsReviewedStatus(model: data)
                    self.activityIndicator.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
