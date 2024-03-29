//
//  MypageMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class MypageMainVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navTitleLabel: UILabel! {
        didSet {
            navTitleLabel.font = .PretendardM(size: 20)
        }
    }
    @IBOutlet weak var userStateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var likeListView: UIView!
    @IBOutlet weak var questionTV: UITableView! {
        didSet {
            questionTV.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        }
    }
    @IBOutlet weak var questionTVHeight: NSLayoutConstraint!
    @IBOutlet weak var questionEmptyView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var firstMajorLabel: UILabel!
    @IBOutlet weak var secondMajorLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var firstMajorFormLabel: UILabel!
    @IBOutlet weak var secondMajorFormLabel: UILabel!
    @IBOutlet weak var firstMajorFormLineView: UIView!
    @IBOutlet weak var secondMajorFormLineView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    // MARK: Properties
    var userInfo = MypageUserInfoModel()
    
    var questionList: [GetUserPersonalQuestionListResponseData.PostList] = []
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabbar()
        getMyInfo()
        getUserPersonalQuestionList()
        makeScreenAnalyticsEvent(screenName: "Mypage Tab", screenClass: MypageMainVC.className)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileUI(isVisable: false)
        configureUI()
        setUpTV()
        registerCell()
    }
    
    // MARK: @IBAction
    @IBAction func tapEditProfileBtn(_ sender: Any) {
        guard let profileSettingVC = UIStoryboard.init(name: EditProfileVC.className, bundle: nil).instantiateViewController(withIdentifier: EditProfileVC.className) as? EditProfileVC else { return }
        self.navigationController?.pushViewController(profileSettingVC, animated: true)
    }
    
    @IBAction func tapSettingBtn(_ sender: Any) {
        guard let settingVC = UIStoryboard.init(name: SettingVC.className, bundle: nil).instantiateViewController(withIdentifier: SettingVC.className) as? SettingVC else { return }
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @IBAction func tapLikeListBtn(_ sender: Any) {
        guard let likeListVC = UIStoryboard.init(name: Identifiers.MypageLikeListSB, bundle: nil).instantiateViewController(withIdentifier: MypageLikeListVC.className) as? MypageLikeListVC else { return }
        self.navigationController?.pushViewController(likeListVC, animated: true)
    }
    
    @IBAction func tapSortBtn(_ sender: Any) {
//        /// 3-4순위`
//        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let latestAction = UIAlertAction(title: "최신순", style: .default, handler: nil)
//        let moreLikeAction = UIAlertAction(title: "좋아요순", style: .default, handler: nil)
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        
//        [latestAction, moreLikeAction, cancelAction].forEach { action in
//            optionMenu.addAction(action)
//        }
//        
//        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func tapPostListBtn(_ sender: Any) {
        guard let postListVC = UIStoryboard.init(name: MypagePostListVC.className, bundle: nil).instantiateViewController(withIdentifier: MypagePostListVC.className) as? MypagePostListVC else { return }
        postListVC.isPostOrAnswer = true
        self.navigationController?.pushViewController(postListVC, animated: true)
    }
    
    @IBAction func tapAnswerListBtn(_ sender: Any) {
        guard let answerListVC = UIStoryboard.init(name: MypagePostListVC.className, bundle: nil).instantiateViewController(withIdentifier: MypagePostListVC.className) as? MypagePostListVC else { return }
        answerListVC.isPostOrAnswer = false
        self.navigationController?.pushViewController(answerListVC, animated: true)
    }
    
    @IBAction func tapReviewBtn(_ sender: Any) {
        guard let reviewVC = UIStoryboard.init(name: MypageMyReviewVC.className, bundle: nil).instantiateViewController(withIdentifier: MypageMyReviewVC.className) as? MypageMyReviewVC else { return }
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
}

// MARK: - UI
extension MypageMainVC {
    private func configureUI() {
        profileView.makeRounded(cornerRadius: 8.adjusted)
        likeListView.makeRounded(cornerRadius: 8.adjusted)
        questionEmptyView.makeRounded(cornerRadius: 8.adjusted)
        questionTV.makeRounded(cornerRadius: 8.adjusted)
        questionTV.removeSeparatorsOfEmptyCellsAndLastCell()
        
        profileImgView.image = UIImage(named: "grayProfileImage\(userInfo.profileImageID)")!
        nickNameLabel.text = userInfo.nickname
        firstMajorLabel.text = "\(userInfo.firstMajorName) \(userInfo.firstMajorStart)"
        if userInfo.secondMajorName == "미진입" {
            secondMajorLabel.text = "\(userInfo.secondMajorName)"
        } else {
            secondMajorLabel.text = "\(userInfo.secondMajorName) \(userInfo.secondMajorStart)"
        }
        likeCountLabel.text = "\(userInfo.count)"
        if let rate = userInfo.responseRate {
            rateLabel.text = "응답률 \(rate)%"
        } else {
            rateLabel.text = "응답률 -"
        }
        bioLabel.text = "\(userInfo.bio ?? "")"
        
        DispatchQueue.main.async {
            self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true
            self.questionTV.isHidden = self.questionList.isEmpty ? true : false
            if self.userInfo.isOnQuestion {
                self.userStateViewHeight.constant = 0
            } else {
                self.userStateViewHeight.constant = 32.adjusted
            }
        }
    }
    
    /// 프로필 뷰의 기본 틀 UI 세팅
    private func setProfileUI(isVisable: Bool) {
        DispatchQueue.main.async {
            [self.firstMajorFormLabel, self.secondMajorFormLabel, self.firstMajorFormLineView, self.secondMajorFormLineView].forEach {
                $0?.isHidden = !(isVisable)
            }
        }
    }
}

// MARK: - Custom Methods
extension MypageMainVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        questionTV.register(BaseQuestionTVC.self, forCellReuseIdentifier: BaseQuestionTVC.className)
    }
    
    private func setUpTV() {
        questionTV.delegate = self
        questionTV.dataSource = self
    }
}

// MARK: - Network
extension MypageMainVC {
    private func getMyInfo() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getUserInfo(userID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID), completion: { networkResult in
            switch networkResult {
            case .success(let res):
                self.activityIndicator.stopAnimating()
                if let data = res as? MypageUserInfoModel {
                    self.setProfileUI(isVisable: true)
                    self.userInfo = data
                    self.configureUI()
                }
            case .requestErr(let res):
                self.activityIndicator.stopAnimating()
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMyInfo()
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        })
    }
    
    private func getUserPersonalQuestionList() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getUserPersonalQuestionList(userID: UserDefaults.standard.value(forKey: UserDefaults.Keys.UserID) as! Int, sort: .recent, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? GetUserPersonalQuestionListResponseData {
                    self.questionList = data.postList
                    DispatchQueue.main.async {
                        self.questionTV.reloadData()

                        self.questionTV.isHidden = self.questionList.isEmpty ? true : false
                        self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true

                        self.questionTV.layoutIfNeeded()
                        self.questionTV.rowHeight = UITableView.automaticDimension
                        self.questionTVHeight.constant = self.questionTV.contentSize.height
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    debugPrint(#function, "데이터타입 에러")
                    debugPrint(res)
                }
            case .requestErr(let res):
                if let message = res as? String {
                    debugPrint(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getUserPersonalQuestionList()
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }) 
    }
}
