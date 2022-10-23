//
//  ReviewVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/10/09.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxSwift
import RxCocoa

final class ReviewVC: BaseVC {

    // MARK: Properties
    private let reviewTV = UITableView().then {
        $0.isScrollEnabled = false
    }
    
    var disposeBag = DisposeBag()
    var contentSizeDelegate: SendContentSizeDelegate?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerTVC()
        setUpDelegate()
        NotificationCenter.default.addObserver(self, selector: #selector(setUpInitAction), name: Notification.Name.dismissHalfModal, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpInitAction()
    }
    
    override func viewWillLayoutSubviews() {
        contentSizeDelegate?.sendContentSize(height: reviewTV.contentSize.height + 24)
        reviewTV.snp.updateConstraints {
            $0.height.equalTo(reviewTV.contentSize.height)
        }
    }
}

// MARK: - Bind
extension ReviewVC: View {
    func bind(reactor: ReviewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ReviewReactor) {
        
        /// 학과 후기 상세 뷰로 이동
        reviewTV.rx.modelSelected(ReviewMainPostListData.self)
            .subscribe(onNext: { item in
                self.navigator?.instantiateVC(destinationViewControllerType: ReviewDetailVC.self, useStoryboard: true, storyboardName: "ReviewDetailSB", naviType: .push) { reviewDetailVC in
                    reviewDetailVC.postId = item.postID
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ReviewReactor) {
        reactor.state
            .map { $0.reviewList }
            .bind(to: reviewTV.rx.items) { tableView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: ReviewMainPostTVC.className, for: indexPath)
                
                guard let reviewCell = cell as? ReviewMainPostTVC else { return UITableViewCell() }
                reviewCell.setData(data: item)
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
        
        // reviewTV의 변하는 TableViewHeight 구독하는 부분
        reactor.state
            .subscribe(onNext: { [weak self] _ in
                if let contentHeight = self?.reviewTV.contentSize.height {
                    self?.reviewTV.snp.updateConstraints {
                        $0.height.equalTo(contentHeight)
                    }
                }
                self?.reviewTV.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func setUpInitAction() {
        reactor?.action.onNext(.reloadReviewList)
    }
}

// MARK: - UI
extension ReviewVC {
    private func configureUI() {
        view.addSubview(reviewTV)
        
        reviewTV.separatorStyle = .none
        reviewTV.backgroundColor = .paleGray
        
        reviewTV.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
}

// MARK: - Custom Methods
extension ReviewVC {
    
    /// cell 등록 함수
    private func registerTVC() {
        ReviewMainPostTVC.register(target: reviewTV)
    }
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        reviewTV.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}


// MARK: - UITableViewDelegate
extension ReviewVC: UITableViewDelegate {

    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
