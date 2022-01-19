//
//  MypageMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class MypageMainVC: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var navView: UIView! {
        didSet {
            navView.addShadow(offset: CGSize(width: 0, height: 4), color: .shadowDefault, opacity: 1, radius: 16)
        }
    }
    @IBOutlet weak var navTitleBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var userStateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var likeListView: UIView!
    @IBOutlet weak var questionTV: UITableView!
    @IBOutlet weak var questionTVHeight: NSLayoutConstraint!
    @IBOutlet weak var questionEmptyView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var firstMajorLabel: UILabel!
    @IBOutlet weak var secondMajorLabel: UILabel!
    
    // MARK: Properties
    var userInfo = MypageUserInfoModel()
    
    var questionList: [ClassroomPostList] = []
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeVisibleTabBar()
        getUserInfo()
        getUserPersonalQuestionList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpTV()
        registerCell()
    }
    
    // MARK: @IBAction
    @IBAction func goMypageUser(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: MypageUserVC.className, bundle: nil).instantiateViewController(withIdentifier: MypageUserVC.className) as? MypageUserVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapEditProfileBtn(_ sender: Any) {
        /// 1순위!
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
    @IBAction func tapSettingBtn(_ sender: Any) {
        /// 4순위댱
    }
    
    @IBAction func tapLikeListBtn(_ sender: Any) {
        /// 4순위
    }
    
    @IBAction func tapSortBtn(_ sender: Any) {
        /// 3-4순위`
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let latestAction = UIAlertAction(title: "최신순", style: .default, handler: nil)
        let moreLikeAction = UIAlertAction(title: "좋아요순", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        [latestAction, moreLikeAction, cancelAction].forEach { action in
            optionMenu.addAction(action)
        }
        
        self.present(optionMenu, animated: true, completion: nil)
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
        
        nickNameLabel.text = userInfo.nickname
        firstMajorLabel.text = "\(userInfo.firstMajorName) \(userInfo.firstMajorStart)"
        secondMajorLabel.text = "\(userInfo.secondMajorName) \(userInfo.secondMajorStart)"
        
        DispatchQueue.main.async {
            self.navTitleBottomSpace.constant = 26.adjustedH
            self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true
            self.questionTV.isHidden = self.questionList.isEmpty ? true : false
            if self.userInfo.isOnQuestion {
                self.userStateViewHeight.constant = 0
            } else {
                self.userStateViewHeight.constant = 32.adjusted
            }
        }
    }
    
    /// 1:1 질문글 들어갔다 나오면 사라져 있는 탭바를 다시 보이게 함
    private func makeVisibleTabBar() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Custom Methods
extension MypageMainVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        questionTV.register(MypageQuestionTVC.self, forCellReuseIdentifier: MypageQuestionTVC.className)
    }
    
    private func setUpTV() {
        questionTV.delegate = self
        questionTV.dataSource = self
    }
}

// MARK: - Network
extension MypageMainVC {
    private func getUserInfo() {
        MypageAPI.shared.getUserInfo(userID: UserDefaults.standard.value(forKey: UserDefaults.Keys.UserID) as! Int, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageUserInfoModel {
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
    
    private func getUserPersonalQuestionList() {
        MypageAPI.shared.getUserPersonalQuestionList(userID: UserDefaults.standard.value(forKey: UserDefaults.Keys.UserID) as! Int, sort: .recent, completion: { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? MypageUserPersonalQuestionModel {
                    self.questionList = []
                    self.questionList = data.classroomPostList
                    DispatchQueue.main.async {
                        self.questionTV.reloadData()

                        self.questionTV.isHidden = self.questionList.isEmpty ? true : false
                        self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true

                        self.questionTV.layoutIfNeeded()
                        self.questionTV.rowHeight = UITableView.automaticDimension
                        self.questionTVHeight.constant = self.questionTV.contentSize.height
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
}
