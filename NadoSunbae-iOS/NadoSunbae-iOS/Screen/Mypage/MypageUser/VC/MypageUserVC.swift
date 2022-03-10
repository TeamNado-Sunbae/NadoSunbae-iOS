//
//  MyPageUserVC.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/14.
//

import UIKit

class MypageUserVC: BaseVC {
    
    // MARK: @IBOutlet
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var majorReviewView: UIView!
    @IBOutlet weak var userStateView: UIView!
    @IBOutlet weak var userStateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionTV: UITableView!
    @IBOutlet weak var questionTVHeight: NSLayoutConstraint!
    @IBOutlet weak var questionEmptyView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var firstMajorLabel: UILabel!
    @IBOutlet weak var secondMajorLabel: UILabel!
    @IBOutlet weak var privateQuestionNickNameLabel: UILabel!
    @IBOutlet weak var majorReviewCountLabel: UILabel!
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var floatingBtn: UIButton! {
        didSet {
            floatingBtn.setImage(UIImage(named: "btn_floating_plus")!, for: .normal)
        }
    }
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.rightActivateBtn.isActivated = false
            navView.backBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var responseRateLabel: UILabel! {
        didSet {
            responseRateLabel.isHidden = true
        }
    }
    @IBOutlet weak var firstMajorFormLabel: UILabel!
    @IBOutlet weak var secondMajorFormLabel: UILabel!
    @IBOutlet weak var firstMajorFormLineView: UIView!
    @IBOutlet weak var secondMajorFormLineView: UIView!
    
    // MARK: Properties
    var targetUserID = 1
    var userInfo = MypageUserInfoModel()
    var questionList: [ClassroomPostList] = []
    var sortType: ListSortType = .recent
    var judgeBlockStatusDelegate: SendBlockedInfoDelegate?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileUI(isVisable: false)
        configureUI()
        setUpTV()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        getUserInfo()
        getUserPersonalQuestionList(sort: sortType)
    }
    
    // MARK: @IBAction
    @IBAction func tapPersonalQuestionWriteBtn(_ sender: Any) {
        
        /// 유저의 권한 분기처리
        self.divideUserPermission() {
            if self.userInfo.isOnQuestion {
                presentToWriteQuestionVC { writeQuestionVC in
                    writeQuestionVC.questionType = .personal
                    writeQuestionVC.answerID = self.userInfo.userID
                }
            }
        }
    }
    
    @IBAction func tapSortBtn(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let latestAction = UIAlertAction(title: "최신순", style: .default) { alert in
            self.sortType = .recent
            self.getUserPersonalQuestionList(sort: self.sortType)
        }
        let moreLikeAction = UIAlertAction(title: "좋아요순", style: .default) { alert in
            self.sortType = .like
            self.getUserPersonalQuestionList(sort: self.sortType)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [latestAction, moreLikeAction, cancelAction].forEach { action in
            optionMenu.addAction(action)
        }
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func tapReviewBtn(_ sender: UIButton) {
        guard let reviewVC = UIStoryboard.init(name: MypageMyReviewVC.className, bundle: nil).instantiateViewController(withIdentifier: MypageMyReviewVC.className) as? MypageMyReviewVC else { return }
        
        reviewVC.userID = userInfo.userID
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    @IBAction func tapBlockBtn(_ sender: UIButton) {
        makeAlertWithCancel(okTitle: "차단", okAction: { _ in
            guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
            alert.showNadoAlert(vc: self, message: "해당 유저를 차단하시겠어요?\n차단시, 본인이 쓴 글 및 마이페이지에\n해당유저가 접근할 수 없습니다.", confirmBtnTitle: "차단하기", cancelBtnTitle: "취소")
            alert.confirmBtn.press {
                self.requestBlockUser(blockUserID: self.userInfo.userID)
            }
        })
    }
}

// MARK: - UI
extension MypageUserVC {
    private func configureUI() {
        navView.configureTitleLabel(title: "\(userInfo.nickname)")
        profileView.makeRounded(cornerRadius: 8.adjusted)
        majorReviewView.makeRounded(cornerRadius: 8.adjusted)
        questionTV.makeRounded(cornerRadius: 8.adjusted)
        questionTV.removeSeparatorsOfEmptyCellsAndLastCell()
        questionEmptyView.makeRounded(cornerRadius: 8.adjusted)
        questionTV.separatorColor = .separatorGray
        
        profileImgView.image = UIImage(named: "profileImage\(userInfo.profileImageID)")!
        nickNameLabel.text = userInfo.nickname
        firstMajorLabel.text = "\(userInfo.firstMajorName) \(userInfo.firstMajorStart)"
        if userInfo.secondMajorName == "미진입" {
            secondMajorLabel.text = "\(userInfo.secondMajorName)"
        } else {
            secondMajorLabel.text = "\(userInfo.secondMajorName) \(userInfo.secondMajorStart)"
        }
        privateQuestionNickNameLabel.text = userInfo.nickname
        majorReviewCountLabel.text = "\(userInfo.count)"
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        DispatchQueue.main.async {
            if self.userInfo.isOnQuestion {
                self.floatingBtn.setImage(UIImage(named: "btn_floating_plus")!, for: .normal)
                self.userStateViewHeight.constant = 0
            } else {
                self.floatingBtn.setImage(UIImage(named: "btnFloating_x")!, for: .normal)
                self.userStateViewHeight.constant = 32.adjusted
            }
            self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true
            self.questionTV.isHidden = self.questionList.isEmpty ? true : false
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
extension MypageUserVC {
    
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
extension MypageUserVC {
    private func getUserInfo() {
        MypageAPI.shared.getUserInfo(userID: targetUserID, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageUserInfoModel {
                    self.setProfileUI(isVisable: true)
                    self.userInfo = data
                    self.configureUI()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
    
    private func getUserPersonalQuestionList(sort: ListSortType) {
        self.activityIndicator.startAnimating()
        MypageAPI.shared.getUserPersonalQuestionList(userID: targetUserID, sort: sort, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? QuestionOrInfoListModel {
                    self.activityIndicator.stopAnimating()
                    self.questionList = []
                    self.questionList = data.classroomPostList
                    DispatchQueue.main.async {
                        self.questionTV.reloadData()
                        
                        self.questionTV.isHidden = self.questionList.isEmpty ? true : false
                        self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true
                        
                        self.questionTV.layoutIfNeeded()
                        self.questionTV.rowHeight = UITableView.automaticDimension
                        self.questionTVHeight.constant = self.questionTV.contentSize.height
                        self.sortBtn.setImage(UIImage(named: sort == .recent ? "btnArray" : "property1Variant3"), for: .normal)
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            default:
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        })
    }
    
    /// 유저 차단 API 요청 메서드
    private func requestBlockUser(blockUserID: Int) {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.requestBlockUnBlockUser(blockUserID: blockUserID) { networkResult in
            switch networkResult {
            case .success(let res):
                if res is RequestBlockUnblockUserModel {
                    self.activityIndicator.stopAnimating()
                    guard let alert = Bundle.main.loadNibNamed(NadoAlertVC.className, owner: self, options: nil)?.first as? NadoAlertVC else { return }
                    alert.showNadoAlert(vc: self, message: "해당 유저가 차단되었습니다.", confirmBtnTitle: "확인", cancelBtnTitle: "", type: .withSingleBtn)
                    alert.confirmBtn.press {
                        self.judgeBlockStatusDelegate?.sendBlockedInfo(status: true, userID: blockUserID)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.requestBlockUser(blockUserID: self.userInfo.userID)
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
    
    /// 1:1질문, 전체 질문, 정보글 상세 조회 API 요청 메서드
    func requestGetDetailQuestionData(chatPostID: Int) {
        self.activityIndicator.startAnimating()
        ClassroomAPI.shared.getQuestionDetailAPI(postID: chatPostID) { networkResult in
            switch networkResult {
            case .success(let res):
                if let _ = res as? ClassroomQuestionDetailData {
                    self.activityIndicator.stopAnimating()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    print(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.activityIndicator.stopAnimating()
                        self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                    }
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "내부 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
