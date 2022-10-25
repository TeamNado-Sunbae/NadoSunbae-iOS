//
//  HomeRecentPersonalQuestionVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/15.
//

import UIKit

final class HomeRecentPersonalQuestionVC: BaseVC {
    
    // MARK: Components
    private lazy var naviView = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backWithCenterTitle)
        $0.configureTitleLabel(title: "최근 1:1 질문")
        $0.rightCustomBtn.isHidden = true
        $0.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
    private let statusBarView = NadoStatusBarView(contentText: "특정 학과 선배에게 1:1 질문을 하고 싶다면 과방탭을 이용하세요.", type: .label)
    private let questionSV = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let questionTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.layer.borderWidth = 1
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.separatorColor = .gray0
    }
    
    // MARK: Properties
    private var questionList: [PostListResModel] = []
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setQuestionTV()
        getRecentPersonalQuestionList()
    }
    
    private func setQuestionTV() {
        questionTV.delegate = self
        questionTV.dataSource = self
        
        questionTV.register(BaseQuestionTVC.self, forCellReuseIdentifier: BaseQuestionTVC.className)
    }
    
    private func updateQuestionTVHeight() {
        self.questionTV.snp.updateConstraints {
            $0.height.equalTo(self.questionTV.contentSize.height)
        }
        self.questionTV.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension HomeRecentPersonalQuestionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("questionListCount", questionList.count)
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BaseQuestionTVC.className, for: indexPath) as? BaseQuestionTVC else { return BaseQuestionTVC() }
        cell.setEssentialCellInfo(data: questionList[indexPath.row])
        cell.layoutSubviews()
        cell.removeBottomSeparator(isLast: tableView.isLast(for: indexPath))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeRecentPersonalQuestionVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.divideUserPermission() {
            self.navigator?.instantiateVC(destinationViewControllerType: DefaultQuestionChatVC.self, useStoryboard: true, storyboardName: Identifiers.QuestionChatSB, naviType: .push) { questionDetailVC in
                questionDetailVC.hidesBottomBarWhenPushed = true
                questionDetailVC.naviStyle = .push
                questionDetailVC.postID = self.questionList[indexPath.row].postID
                questionDetailVC.isAuthorized = self.questionList[indexPath.row].isAuthorized
            }
        }
    }
}

// MARK: - Network
extension HomeRecentPersonalQuestionVC {
    private func getRecentPersonalQuestionList() {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.getPostList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), majorID: 0, filter: .questionToPerson, sort: "recent", search: "") { networkResult in
            self.activityIndicator.stopAnimating()
            switch networkResult {
            case .success(let res):
                if let data = res as? [PostListResModel] {
                    self.questionList = data
                    self.questionTV.reloadData()
                    self.updateQuestionTVHeight()
                    self.updateQuestionTVHeight()
                }
            case .requestErr(let res):
                if let message = res as? String {
                    debugPrint(message)
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.getRecentPersonalQuestionList()
                    }
                }
            default:
                debugPrint(#function, "network error")
            }
        }
    }
}

// MARK: - UI
extension HomeRecentPersonalQuestionVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([naviView, statusBarView, questionSV])
        questionSV.addSubviews([contentView])
        contentView.addSubviews([questionTV])
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        statusBarView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        questionSV.snp.makeConstraints {
            $0.top.equalTo(statusBarView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        questionTV.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
            $0.height.equalTo(13)
        }
    }
}
