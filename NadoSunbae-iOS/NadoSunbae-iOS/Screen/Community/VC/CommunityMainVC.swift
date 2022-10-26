//
//  CommunityMainVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/11.
//

import UIKit
import SnapKit
import Then
import ReactorKit

final class CommunityMainVC: BaseVC, View {
    
    // MARK: Components
    private let naviView = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .rootWithCustomRightBtn)
        $0.configureTitleLabel(title: "커뮤니티")
        $0.configureRightCustomBtn(imgName: "icSearch", selectedImgName: "icSearch")
    }
    
    private let communitySV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView()
    private let topStickyBar = UIView().then {
        $0.backgroundColor = .paleGray
    }
    
    private let communitySegmentedControl = NadoSegmentedControl(items: [PostFilterType.community.name,
                                                                         PostFilterType.general.name,
                                                                         PostFilterType.questionToEveryone.name,
                                                                         PostFilterType.information.name])
    private let filterBtn = UIButton().then {
        $0.setImgByName(name: "btnCommunityFilter", selectedName: "btnCommunityFilterFilled")
    }
    
    private let communityTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.isScrollEnabled = false
    }
    
    private let writeFloatingBtn = UIButton().then {
        $0.setImage(UIImage(named: "btnWriteFloating"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addShadow(offset: CGSize(width: 1, height: 1), color: UIColor(red: 68/255, green: 69/255, blue: 75/255, alpha: 0.2), opacity: 1, radius: 0)
    }
    
    private let refreshControl = UIRefreshControl()
    private let contentEmptyLabel = UILabel().then {
        $0.text = "등록된 게시글이 없습니다."
        $0.textColor = UIColor.gray3
        $0.font = .PretendardR(size: 14.0)
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCell()
        setUpDelegate()
        bindCommunityTV()
        setUpSegmentAction(type: PostFilterType(rawValue: communitySegmentedControl.selectedSegmentIndex) ?? .community)
        setUpCommunitySVRefreshControl()
    }
    
    func bind(reactor: CommunityMainReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind Action & State
extension CommunityMainVC {
    
    // MARK: Action
    private func bindAction(_ reactor: CommunityMainReactor) {
        communitySegmentedControl.rx.controlEvent(.valueChanged)
            .map { [weak self] in
                let selectIndex = self?.communitySegmentedControl.selectedSegmentIndex
                
                switch selectIndex {
                case 1:
                    return CommunityMainReactor.Action.reloadCommunityTV(majorID: reactor.currentState.filterMajorID, type: .general)
                case 2:
                    return CommunityMainReactor.Action.reloadCommunityTV(majorID: reactor.currentState.filterMajorID, type: .questionToEveryone)
                case 3:
                    return CommunityMainReactor.Action.reloadCommunityTV(majorID: reactor.currentState.filterMajorID, type: .information)
                default:
                    return CommunityMainReactor.Action.reloadCommunityTV(majorID: reactor.currentState.filterMajorID, type: .community)
                }
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        naviView.rightCustomBtn.rx.tap
            .subscribe(onNext: {
                let searchVC = CommunitySearchVC()
                let searchReactor = CommunitySearchReactor()
                searchVC.reactor = searchReactor
                searchVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(searchVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        writeFloatingBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.divideUserPermission() {
                    self?.navigator?.instantiateVC(destinationViewControllerType: CommunityWriteVC.self, useStoryboard: false, storyboardName: "", naviType: .present, modalPresentationStyle: .fullScreen) { communityWriteVC in
                        communityWriteVC.reactor = CommunityWriteReactor()
                        communityWriteVC.sendPostTypeDelegate = self
                    }
                }
            })
            .disposed(by: disposeBag)
        
        filterBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentHalfModalView()
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                reactor.action.onNext(.refreshControl(majorID: reactor.currentState.filterMajorID, type: PostFilterType(rawValue: self.communitySegmentedControl.selectedSegmentIndex) ?? .community))
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: State
    private func bindState(_ reactor: CommunityMainReactor) {
        reactor.state
            .map { $0.communityList }
            .bind(to: communityTV.rx.items) { tableView, index, item in
                
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath)
                
                guard let communityCell = cell as? CommunityTVC else { return UITableViewCell() }
                communityCell.setEssentialCommunityCellInfo(data: item)
                
                return communityCell
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .subscribe(onNext: { [weak self] _ in
                self?.communityTV.layoutIfNeeded()
                
                if let contentHeight = self?.communityTV.contentSize.height {
                    self?.communityTV.snp.updateConstraints {
                        $0.height.equalTo(contentHeight)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.loading }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(onNext: { [weak self] loading in
                self?.view.bringSubviewToFront(self?.activityIndicator ?? UIView())
                if loading {
                    self?.activityIndicator.startAnimating()
                    self?.setEmptyLabelIsHidden(isHidden: true)
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.communitySV.contentOffset.y = 0
                    self?.setEmptyLabelIsHidden(isHidden: reactor.currentState.communityList.isEmpty ? false : true)
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.filterBtnSelected }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(onNext: { [weak self] filled in
                self?.filterBtn.isSelected = filled
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.refreshLoading }
            .distinctUntilChanged()
            .map { $0 }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    /// CommunityTV를 bind하는 메서드
    private func bindCommunityTV() {
        communityTV.rx.modelSelected(PostListResModel.self)
            .subscribe(onNext: { [weak self] item in
                self?.divideUserPermission() {
                    self?.navigator?.instantiateVC(destinationViewControllerType: CommunityPostDetailVC.self, useStoryboard: true, storyboardName: "CommunityPostDetailSB", naviType: .push) { postDetailVC in
                        postDetailVC.postID = item.postID
                        postDetailVC.hidesBottomBarWhenPushed = true
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension CommunityMainVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([naviView, topStickyBar, communitySV, contentEmptyLabel, writeFloatingBtn])
        topStickyBar.addSubviews([communitySegmentedControl, filterBtn])
        communitySV.addSubview(contentView)
        contentView.addSubview(communityTV)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        topStickyBar.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        communitySV.snp.makeConstraints {
            $0.top.equalTo(topStickyBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        writeFloatingBtn.snp.makeConstraints {
            $0.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            $0.width.height.equalTo(64)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        communitySegmentedControl.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(244)
        }
        
        filterBtn.snp.makeConstraints {
            $0.centerY.equalTo(communitySegmentedControl)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(24)
            $0.width.equalTo(48)
        }
        
        contentEmptyLabel.snp.makeConstraints {
            $0.centerX.equalTo(communitySV)
            $0.centerY.equalToSuperview()
        }
        
        communityTV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.bottom.equalToSuperview().offset(-16)
        }
    }
    
    private func setEmptyLabelIsHidden(isHidden: Bool) {
        contentEmptyLabel.isHidden = isHidden
    }
}

// MARK: - Custom Methods
extension CommunityMainVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        communityTV.register(CommunityTVC.self, forCellReuseIdentifier: CommunityTVC.className)
    }
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        communityTV.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// segment Action을 설정하는 메서드
    private func setUpSegmentAction(type: PostFilterType) {
        reactor?.action.onNext(.reloadCommunityTV(type: type))
    }
    
    /// communityTV의 refreshControl을 등록하는 메서드
    private func setUpCommunitySVRefreshControl() {
        refreshControl.endRefreshing()
        communitySV.refreshControl = refreshControl
    }
    
    // HalfModalView를 present하는 메서드
    private func presentHalfModalView() {
        let slideVC = HalfModalVC()
        slideVC.vcType = .communityFilter
        slideVC.cellType = .star
        slideVC.setUpTitleLabel("특정학과 글 불러오기")
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.selectCommunityDelegate = self
        slideVC.selectFilterIndex = reactor?.currentState.filterMajorID ?? MajorIDConstants.regardlessMajorID
        self.present(slideVC, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension CommunityMainVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CommunityMainVC: UIViewControllerTransitioningDelegate {
    
    /// presentationController - forPresented
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        HalfModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - SendPostTypeDelegate
extension CommunityMainVC: SendPostTypeDelegate {
    func sendPostType(postType: PostFilterType) {
        let postFilterType = postType
        communitySegmentedControl.selectedSegmentIndex = postFilterType.rawValue
        setUpSegmentAction(type: postFilterType)
    }
}

// MARK: - SendCommunityInfoDelegate
extension CommunityMainVC: SendCommunityInfoDelegate {
    func sendCommunityInfo(majorID: Int, majorName: String) {
        reactor?.action.onNext(.filterFilled(fill: majorName == "" ? false : true, majorID: majorID, type: PostFilterType(rawValue: communitySegmentedControl.selectedSegmentIndex) ?? .community))
    }
}
