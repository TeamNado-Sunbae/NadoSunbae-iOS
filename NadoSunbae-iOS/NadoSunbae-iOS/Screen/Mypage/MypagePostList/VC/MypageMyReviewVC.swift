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
            navView.configureTitleLabel(title: "학과후기")
            navView.setUpNaviStyle(state: .backDefault)
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewTV: UITableView!
    @IBOutlet weak var reviewTVHeight: NSLayoutConstraint!
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: Properties
    var reviewList: [MypageMyReviewModel] = []
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMypageMyReview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - UI
extension MypageMyReviewVC {
    private func configureUI() {
        setTitleLabel()
        emptyView.makeRounded(cornerRadius: 8.adjusted)
    }
    
    private func setTitleLabel() {
        let userName = "내 닉네임"
        let titleText = "\(userName)님이 쓴 학과 후기"
        let attributedString = NSMutableAttributedString(string: titleText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.mainDefault, range: (titleText as NSString).range(of: userName))
        titleLabel.attributedText = attributedString
    }
    
    private func setEmptyView() {
        emptyView.isHidden = !(reviewList.isEmpty)
    }
    
    private func setUpTV() {
        reviewTV.delegate = self
        reviewTV.dataSource = self
        reviewTVHeight.constant = reviewTV.contentSize.height
    }
}

// MARK: -
extension MypageMyReviewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

extension MypageMyReviewVC: UITableViewDelegate {
    
}

// MARK: - Network
extension MypageMyReviewVC {
    private func getMypageMyReview() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getMypageMyReviewList(userID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID)) { networkResult in
            switch networkResult {
            case .success(let res):
                if let reviewData = res as? MypageMyReviewModel {
            case .requestErr(let msg):
                self.activityIndicator.stopAnimating()
                if let message = msg as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
