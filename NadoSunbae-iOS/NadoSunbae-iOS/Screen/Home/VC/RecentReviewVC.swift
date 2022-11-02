//
//  RecentReviewVC.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/23.
//

import UIKit
import ReactorKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class RecentReviewVC: BaseVC, View {
    
    // MARK: Properties
    private let naviView = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backWithCenterTitle)
        $0.configureTitleLabel(title: "최근 후기")
        $0.rightCustomBtn.isHidden = true
    }
    
    private let infoView = NadoStatusBarView(contentText: "특정 학과의 후기만 보고 싶다면 과방탭을 이용하세요.", type: .label)
    
    private let reviewTV = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
    }
    
    var disposeBag = DisposeBag()

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerTVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabbar()
        reactor?.action.onNext(.reloadRecentReviewList)
    }
    
    func bind(reactor: RecentReviewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind Action & State
extension RecentReviewVC {
    
    // MARK: Action
    private func bindAction(_ reactor: RecentReviewReactor) {
        reactor.action.onNext(.reloadRecentReviewList)
        
        naviView.backBtn.rx.tap
            .bind { self.navigationController?.popViewController(animated: true) }
            .disposed(by: disposeBag)
        
        /// 학과 후기 상세 뷰로 이동 
        reviewTV.rx.modelSelected(HomeRecentReviewResponseDataElement.self)
            .subscribe(onNext: { item in
                self.divideUserPermission() {
                    self.makeAnalyticsEvent(eventName: .review_read, parameterValue: "")
                    self.navigator?.instantiateVC(destinationViewControllerType: ReviewDetailVC.self, useStoryboard: true, storyboardName: "ReviewDetailSB", naviType: .push) { reviewDetailVC in
                        reviewDetailVC.postId = item.id
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: State
    private func bindState(_ reactor: RecentReviewReactor) {
        reactor.state
            .map { $0.recentReviewList }
            .bind(to: reviewTV.rx.items) { tableView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className, for: indexPath)
                
                guard let reviewCell = cell as? ReviewMainPostTVC else { return UITableViewCell() }
                reviewCell.setHomeRecentReviewData(postData: item)
                reviewCell.tagImgList = item.tagList
                
                return reviewCell
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.loading }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(onNext: { [weak self] loading in
                self?.view.bringSubviewToFront(self?.activityIndicator ?? UIView())
                loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
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
            .distinctUntilChanged()
            .subscribe(onNext: { state in
                if state {
                    self.updateAccessToken { _ in
                        reactor.action.onNext(reactor.currentState.reRequestAction)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension RecentReviewVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([naviView, infoView, reviewTV])
        reviewTV.backgroundColor = .paleGray
        reviewTV.separatorStyle = .none
        reviewTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        infoView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        reviewTV.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Custom Methods
extension RecentReviewVC {
    
    /// 셀 등록 메서드
    private func registerTVC() {
        ReviewMainPostTVC.register(target: reviewTV)
    }
}
