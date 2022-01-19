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
    @IBOutlet weak var floatingBtn: UIButton! {
        didSet {
            floatingBtn.setImage(UIImage(named: "btnFloating_x")!, for: .disabled)
            floatingBtn.setImage(UIImage(named: "btn_floating_plus")!, for: .normal)
        }
    }
    @IBOutlet weak var navView: NadoSunbaeNaviBar! {
        didSet {
            navView.setUpNaviStyle(state: .backDefault)
            navView.configureTitleLabel(title: "선배 닉네임")
            navView.rightActivateBtn.isActivated = false
            navView.dismissBtn.press {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBOutlet weak var responseRateLabel: UILabel! {
        didSet {
            responseRateLabel.isHidden = true
        }
    }
    
    // MARK: Properties
    var userInfo = MypageUserInfoModel()
    var questionList: [ClassroomPostList] = []
    
    // MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpTV()
        registerCell()
    }
    
    // MARK: @IBAction
    @IBAction func tapSortBtn(_ sender: UIButton) {
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
extension MypageUserVC {
    private func configureUI() {
        profileView.makeRounded(cornerRadius: 8.adjusted)
        majorReviewView.makeRounded(cornerRadius: 8.adjusted)
        questionTV.makeRounded(cornerRadius: 8.adjusted)
        questionTV.removeSeparatorsOfEmptyCellsAndLastCell()
        questionEmptyView.makeRounded(cornerRadius: 8.adjusted)
        questionTV.separatorColor = .separatorGray
        
        nickNameLabel.text = userInfo.nickname
        firstMajorLabel.text = "\(userInfo.firstMajorName) \(userInfo.firstMajorStart)"
        secondMajorLabel.text = "\(userInfo.secondMajorName) \(userInfo.secondMajorStart)"
        privateQuestionNickNameLabel.text = userInfo.nickname
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        if self.userInfo.isOnQuestion {
            self.floatingBtn.isEnabled = true
            self.userStateViewHeight.constant = 0
        } else {
            self.floatingBtn.isEnabled = false
            self.userStateViewHeight.constant = 32.adjusted
        }
        
        DispatchQueue.main.async {
            self.questionTVHeight.constant = self.questionTV.contentSize.height
            self.questionEmptyView.isHidden = self.questionList.isEmpty ? false : true
            self.questionTV.isHidden = self.questionList.isEmpty ? true : false
        }
    }
}

// MARK: - Custom Methods
extension MypageUserVC {
    
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
extension MypageUserVC {
    private func getUserInfo() {
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiZW1haWwiOiJrdTJAa29yZWEuYWMua3IiLCJuaWNrbmFtZSI6Imt1MiIsImZpcmViYXNlSWQiOiJOT1ZDYktEUUlEY3IybmJsam9ZazhSSnJ0NTUyIiwiaWF0IjoxNjQyMzI5OTMwLCJleHAiOjE2NDQ5MjE5MzAsImlzcyI6Im5hZG9TdW5iYWUifQ.tiblhyT4Y9-DDH1KTwIm37wevbChJ-R8-ECSb3QpZUI"
        
        MypageAPI.shared.getUserInfo(userID: 1, accessToken: accessToken, completion: { networkResult in
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
                self.makeAlert(title: "네트워크 오류로 인해 데이터를 불러올 수 없습니다. 다시 시도해 주세요.")
            }
        })
    }
}
