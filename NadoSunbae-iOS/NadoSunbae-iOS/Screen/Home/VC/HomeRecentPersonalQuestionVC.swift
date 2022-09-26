//
//  HomeRecentPersonalQuestionVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/15.
//

import UIKit

final class HomeRecentPersonalQuestionVC: BaseVC {
    
    // MARK: Components
    private let naviView = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backWithCenterTitle)
        $0.configureTitleLabel(title: "최근 1:1 질문")
        $0.rightCustomBtn.isHidden = true
    }
    private let statusBarView = NadoStatusBarView(contentText: "특정 학과 선배에게 1:1 질문을 하고 싶다면 과방탭을 이용하세요.", type: .label)
    private let questionSV = UIScrollView().then {
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let questionTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.isScrollEnabled = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.separatorColor = .gray0
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    // MARK: Properties
    private var questionList: [ClassroomPostList] = [
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2),
        ClassroomPostList(postID: 131, title: "개인게시판 질문제목", content: "질문내용", createdAt: "2022-06-12T01:35:59.500Z", writer: .init(writerID: 241, profileImageID: 1, nickname: "정비니"), like: Like(isLiked: true, likeCount: 3), commentCount: 2)]
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setQuestionTV()
        updateQuestionTVHeight()
    }
    
    private func setQuestionTV() {
        questionTV.delegate = self
        questionTV.dataSource = self
        
        questionTV.register(EntireQuestionListTVC.self, forCellReuseIdentifier: EntireQuestionListTVC.className)
    }
    
    private func updateQuestionTVHeight() {
        questionTV.reloadData()
        DispatchQueue.main.async {
            self.questionTV.layoutIfNeeded()
            self.questionTV.rowHeight = UITableView.automaticDimension
            self.questionTV.snp.updateConstraints {
                debugPrint("update")
                $0.height.equalTo(self.questionTV.contentSize.height)
            }
            debugPrint("contentSize", self.questionTV.contentSize.height)
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeRecentPersonalQuestionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("questionListCount", questionList.count)
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireQuestionListTVC.className, for: indexPath) as? EntireQuestionListTVC else { return EntireQuestionListTVC() }
        cell.setData(data: questionList[indexPath.row])
        cell.layoutSubviews()
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
