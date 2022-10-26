//
//  PersonalQuestionVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/08.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class PersonalQuestionVC: BaseVC {
    
    // MARK: Properties
    private let backgroundSV = UIScrollView().then {
        $0.isUserInteractionEnabled = false
    }
    private let contentView = UIView()
    private let findSeniorLabel = UILabel().then {
        $0.font = .PretendardSB(size: 14.0)
        $0.textColor = .gray4
        $0.text = "우리 과 선배 찾기"
    }
    
    private let seeMoreBtn = UIButton().then {
        $0.isUserInteractionEnabled = true
        $0.setImage(UIImage(named: "comp_more"), for: .normal)
    }
    
    private let availableQuestionPersonCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 19
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.makeRounded(cornerRadius: 16)
    }
    
    private let recentQuestionLabel = UILabel().then {
        $0.font = .PretendardSB(size: 14.0)
        $0.textColor = .gray4
        $0.text = "최근 1:1 질문"
        $0.sizeToFit()
    }
    
    private var recentQuestionTV = UITableView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.isScrollEnabled = false
        $0.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.makeRounded(cornerRadius: 16)
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    var disposeBag = DisposeBag()
    var contentSizeDelegate: SendContentSizeDelegate?
    var loadingDelegate: SendLoadingStatusDelegate?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCell()
        setUpDelegate()
        bindrecentQuestionTV()
        bindSeniorCV()
        seeMoreBtn.press { [weak self] in
            self?.navigator?.instantiateVC(destinationViewControllerType: QuestionPersonListVC.self, useStoryboard: false, storyboardName: QuestionPersonListVC.className, naviType: .push) { _ in
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(setUpInitAction), name: Notification.Name.dismissHalfModal, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpInitAction()
    }
    
    override func viewWillLayoutSubviews() {
        contentSizeDelegate?.sendContentSize(height: recentQuestionTV.contentSize.height + 264)
        recentQuestionTV.snp.updateConstraints {
            $0.height.equalTo(recentQuestionTV.contentSize.height)
        }
    }
}

// MARK: - Reactor Bind
extension PersonalQuestionVC: View {
    func bind(reactor: PersonalQuestionReactor) {
        bindState(reactor: reactor)
    }
    
    private func bindState(reactor: PersonalQuestionReactor) {
        reactor.state
            .map { $0.seniorList }
            .map { $0.isEmpty ? [QuestionUser()] : $0 }
            .bind(to: availableQuestionPersonCV.rx.items) { [weak self] collectionView, index, item in
                
                let indexPath = IndexPath(row: index, section: 0)
                guard let seniorCell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableQuestionPersonCVC.className, for: indexPath) as? AvailableQuestionPersonCVC,
                      let seeMoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeMoreQuestionPersonCVC.className, for: indexPath) as? SeeMoreQuestionPersonCVC,
                      let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableQuestionPersonEmptyCVC.className, for: indexPath) as? AvailableQuestionPersonEmptyCVC else { return UICollectionViewCell() }
                
                let emptyCase = item.userID == -2 && index == 0

                if emptyCase {
                    self?.seeMoreBtn.isHidden = true
                    return emptyCell
                } else {
                    self?.seeMoreBtn.isHidden = false
                    
                    // 선배 더보기 >
                    if indexPath.row == 8 {
                        return seeMoreCell
                    } else {
                        seniorCell.setData(model: item)
                        seniorCell.contentView.isHidden = true
                        return seniorCell
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.recentQuestionList }
            .bind(to: recentQuestionTV.rx.items) { tableView, index, item in
                
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: BaseQuestionTVC.className, for: indexPath)
                let emptyCell = tableView.dequeueReusableCell(withIdentifier: QuestionEmptyTVC.className, for: indexPath)
                
                guard let questionCell = cell as? BaseQuestionTVC,
                      let emptyCell = emptyCell as? QuestionEmptyTVC else { return UITableViewCell() }
                
                questionCell.setEssentialCellInfo(data: item)
                
                // emptyCell
                if item.postID == -1 && index == 0 {
                    return emptyCell
                } else {
                    return questionCell
                }
            }
            .disposed(by: self.disposeBag)
        
        // recentQuestionTV의 변하는 TableViewHeight 구독하는 부분
        reactor.state
            .subscribe(onNext: { [weak self] _ in
                if let contentHeight = self?.recentQuestionTV.contentSize.height {
                    self?.recentQuestionTV.snp.updateConstraints {
                        $0.height.equalTo(contentHeight)
                    }
                }
                self?.recentQuestionTV.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.loading }
            .subscribe(onNext: { [weak self] loading in
                self?.loadingDelegate?.sendLoadingStatus(loading: loading)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.showAlert }
            .subscribe(onNext: { show in
                if show {
                    self.makeAlert(title: reactor.currentState.alertMessage)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isUpdateAccessToken }
            .subscribe(onNext: { state in
                if state {
                    self.updateAccessToken { _ in
                        reactor.action.onNext(reactor.currentState.reloadAction)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func setUpInitAction() {
        reactor?.action.onNext(.reloadAvailableSeniorListCV)
        reactor?.action.onNext(.reloadRecentQuestionListTV)
    }
    
    /// recentQuestionTV를 bind하는 메서드
    private func bindrecentQuestionTV() {
        recentQuestionTV.rx.modelSelected(PostListResModel.self)
            .subscribe(onNext: { [weak self] item in
                self?.divideUserPermission() {
                    guard let postDetailVC = UIStoryboard.init(name: "QuestionChatSB", bundle: nil).instantiateViewController(withIdentifier: DefaultQuestionChatVC.className) as? DefaultQuestionChatVC else { return }
                    let postDetailNC = UINavigationController(rootViewController: postDetailVC)
                    postDetailVC.naviStyle = .present
                    postDetailVC.postID = item.postID
                    postDetailVC.isAuthorized = item.isAuthorized
                    postDetailNC.modalPresentationStyle = .fullScreen
                    postDetailNC.navigationBar.isHidden = true
                    self?.present(postDetailNC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// seniorCV를 bind하는 메서드
    private func bindSeniorCV() {
        availableQuestionPersonCV.rx.modelSelected(QuestionUser.self)
            .subscribe(onNext: { [weak self] item in
                if item.userID == -2 {
                    self?.navigator?.instantiateVC(destinationViewControllerType: QuestionPersonListVC.self, useStoryboard: false, storyboardName: QuestionPersonListVC.className, naviType: .push) { _ in }
                } else {
                    self?.navigator?.instantiateVC(destinationViewControllerType: MypageUserVC.self, useStoryboard: true, storyboardName: MypageUserVC.className, naviType: .push) { mypageUserVC in
                        mypageUserVC.targetUserID = item.userID
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension PersonalQuestionVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([findSeniorLabel, seeMoreBtn, availableQuestionPersonCV, recentQuestionLabel, recentQuestionTV])
        
        findSeniorLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        
        seeMoreBtn.snp.makeConstraints {
            $0.top.equalTo(findSeniorLabel)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(61)
            $0.height.equalTo(24)
        }
        
        availableQuestionPersonCV.snp.makeConstraints {
            $0.top.equalTo(findSeniorLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(140)
        }
        
        recentQuestionLabel.snp.makeConstraints {
            $0.top.equalTo(availableQuestionPersonCV.snp.bottom).offset(32)
            $0.leading.equalTo(findSeniorLabel)
            $0.height.equalTo(24)
        }
        
        recentQuestionTV.snp.makeConstraints {
            $0.top.equalTo(recentQuestionLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Custom Methods
extension PersonalQuestionVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        availableQuestionPersonCV.register(AvailableQuestionPersonCVC.self, forCellWithReuseIdentifier: AvailableQuestionPersonCVC.className)
        availableQuestionPersonCV.register(SeeMoreQuestionPersonCVC.self, forCellWithReuseIdentifier: SeeMoreQuestionPersonCVC.className)
        availableQuestionPersonCV.register(AvailableQuestionPersonEmptyCVC.self, forCellWithReuseIdentifier: AvailableQuestionPersonEmptyCVC.className)
        recentQuestionTV.register(BaseQuestionTVC.self, forCellReuseIdentifier: BaseQuestionTVC.className)
        recentQuestionTV.register(QuestionEmptyTVC.self, forCellReuseIdentifier: QuestionEmptyTVC.className)
    }
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        availableQuestionPersonCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        recentQuestionTV.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PersonalQuestionVC: UICollectionViewDelegateFlowLayout {
    
    /// sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 질문 가능한 선배가 없는 경우
        if reactor?.currentState.seniorList.isEmpty == true {
            return CGSize(width: availableQuestionPersonCV.frame.width - 32, height: 108.0)
        } else {
            return CGSize(width: 69.0, height: 108.0)
        }
    }
}

// MARK: - UITableViewDelegate
extension PersonalQuestionVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

