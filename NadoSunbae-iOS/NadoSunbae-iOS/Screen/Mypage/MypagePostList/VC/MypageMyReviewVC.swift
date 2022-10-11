//
//  MypageMyReviewVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/02/19.
//

import UIKit

class MypageMyReviewVC: BaseVC {

    // MARK: @IBOutlet
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.configureTitleLabel(title: "내가 쓴 후기")
            navView.setUpNaviStyle(state: .backDefault)
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var mypageReviewSV: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var reviewTV: UITableView!
    @IBOutlet weak var reviewTVHeight: NSLayoutConstraint!
    @IBOutlet weak var emptyView: UIView! {
        didSet {
            emptyView.makeRounded(cornerRadius: 8.adjusted)
        }
    }
    
    // MARK: Properties
    var reviewList: [MypageMyReviewPostModel] = []
    var userID: Int = 0
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTV()
        registerTVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMypageMyReview()
        hideTabbar()
        makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: MypageMyReviewVC.className)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabbar()
    }
}

// MARK: - UI
extension MypageMyReviewVC {
    private func setTitleLabel(userName: String) {
        let titleText = "\(userName)님이 쓴 학과 후기"
        let attributedString = NSMutableAttributedString(string: titleText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainDefault, range: (titleText as NSString).range(of: userName))
        titleLabel.attributedText = attributedString
    }
    
    private func setEmptyView() {
        emptyView.isHidden = !(reviewList.isEmpty)
        self.mypageReviewSV.contentSize.height = 1.0
    }
    
    private func setUpTV() {
        reviewTV.delegate = self
        reviewTV.dataSource = self
        reviewTV.separatorStyle = .none
    }
    
    private func registerTVC() {
        ReviewMainPostTVC.register(target: reviewTV)
    }
}

// MARK: - UITableViewDataSource
extension MypageMyReviewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let reviewMainPostTVC = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className) as? ReviewMainPostTVC else { return UITableViewCell() }
        reviewMainPostTVC.tagImgList = reviewList[indexPath.row].tagList
        reviewMainPostTVC.setUserReviewData(postData: reviewList[indexPath.row])
        return reviewMainPostTVC
    }
}

// MARK: - UITableViewDelegate
extension MypageMyReviewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// 유저의 권한 분기처리
        self.divideUserPermission() {
            self.navigator?.instantiateVC(destinationViewControllerType: ReviewDetailVC.self, useStoryboard: true, storyboardName: "ReviewDetailSB", naviType: .push, modalPresentationStyle: .fullScreen) { reviewDetailVC in
                reviewDetailVC.postId = self.reviewList[indexPath.row].ID
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
}

// MARK: - Network
extension MypageMyReviewVC {
    private func getMypageMyReview() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getMypageMyReviewList(userID: self.userID == 0 ? UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID) : self.userID) { networkResult in
            switch networkResult {
            case .success(let res):
                if let reviewData = res as? MypageMyReviewModel {
                    self.setTitleLabel(userName: reviewData.writer.nickname)
                    self.reviewList = reviewData.reviewList
                    self.setEmptyView()
                    self.reviewTV.reloadData()
                    DispatchQueue.main.async {
                        self.contentView.layoutIfNeeded()
                        self.reviewTVHeight.constant = self.reviewTV.contentSize.height
                        self.contentView.layoutIfNeeded()
                    }
                } else {
                    self.setEmptyView()
                }
                self.activityIndicator.stopAnimating()
            case .requestErr(let res):
                if let message = res as? String {
                    debugPrint(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    self.activityIndicator.stopAnimating()
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMypageMyReview()
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
