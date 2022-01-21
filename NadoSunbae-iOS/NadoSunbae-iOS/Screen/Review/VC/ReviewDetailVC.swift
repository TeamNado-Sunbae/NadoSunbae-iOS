//
//  ReviewDetailVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/17.
//

import UIKit

class ReviewDetailVC: UIViewController {

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
    
    // MARK: Properties
    var detailPost: ReviewPostDetailData = ReviewPostDetailData()
    var postId: Int?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPostId()
        registerTVC()
        setUpTV()
        configureUI()
        addShadowToNaviBar()
        showActionSheet()
        setUpTapNaviBackBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        requestGetReviewPostDetail(postID: postId ?? 5)
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
    private func setUpPostId() {
//        if let postId = postId {
//            // TODO: 서버통신 시 해당 PostId로 후기글 상세 조회 API 호출할 것임!!
//            print(postId)
//        }
    }
    
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
    private func showActionSheet() {
        naviBarView.rightCustomBtn.press {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let edit = UIAlertAction(title: "수정", style: .default) { action in
                
                // TODO: 액션 추가 예정
                print("수정")
            }
            let delete = UIAlertAction(title: "삭제", style: .default) { action in
                
                // TODO: 화면전환 방식 navigation 방식으로 변경 후 팝업 추가 예정
                print("삭제")
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addAction(edit)
            alert.addAction(delete)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
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
            return 255
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
}

// MARK: - Network

/// 후기글 상세 조회
extension ReviewDetailVC {
    func requestGetReviewPostDetail(postID: Int) {
        ReviewAPI.shared.getReviewPostDetailAPI(postID: postID) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if let data = res as? ReviewPostDetailData {

                    self.detailPost = data
                    print(data)

                    self.reviewPostTV.reloadData()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}
