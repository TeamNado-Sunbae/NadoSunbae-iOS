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
    @IBOutlet weak var questionTV: UITableView!
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
    
    // MARK: Properties
    var userInfo = MypageUserInfoModel()
    
    var questionList: [ClassroomPostList] = []
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabbar()
        getMyInfo()
        getUserPersonalQuestionList()
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
        
        profileImgView.image = UIImage(named: "profileImage\(userInfo.profileImageID)")!
        nickNameLabel.text = userInfo.nickname
        firstMajorLabel.text = "\(userInfo.firstMajorName) \(userInfo.firstMajorStart)"
        if userInfo.secondMajorName == "미진입" {
            secondMajorLabel.text = "\(userInfo.secondMajorName)"
        } else {
            secondMajorLabel.text = "\(userInfo.secondMajorName) \(userInfo.secondMajorStart)"
        }
        likeCountLabel.text = "\(userInfo.count)"
        
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
                    print("user info: ", self.userInfo)
                    self.configureUI()
                }
            case .requestErr(let res):
                self.activityIndicator.stopAnimating()
                if let message = res as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getMyInfo()
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
    
    private func getUserPersonalQuestionList() {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getUserPersonalQuestionList(userID: UserDefaults.standard.value(forKey: UserDefaults.Keys.UserID) as! Int, sort: .recent, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? QuestionOrInfoListModel {
                    self.questionList = data.classroomPostList
                    DispatchQueue.main.async {
                        self.questionTV.reloadData()

                        self.questionTV.isHidden = self.questionList.isEmpty ? true : false
                        self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true

                        self.questionTV.layoutIfNeeded()
                        self.questionTV.rowHeight = UITableView.automaticDimension
                        self.questionTVHeight.constant = self.questionTV.contentSize.height
                        self.activityIndicator.stopAnimating()
                    }
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getUserPersonalQuestionList()
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }) 
    }
}
