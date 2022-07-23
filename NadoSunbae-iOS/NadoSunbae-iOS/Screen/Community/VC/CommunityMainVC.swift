//
//  CommunityMainVC.swift
//  NadoSunbae-iOS
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
    private let topTouchBar = UIView().then {
        $0.backgroundColor = .paleGray
    }
    
    private let communitySegmentedControl = NadoSegmentedControl(items: CommunityType.allCases.map { $0.name })
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
        // TODO: 버튼 이미지 변경하기
        $0.setImage(UIImage(named: "btnWriteFloating"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCell()
        bindView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        communitySegmentedControl.setUpNadoSegmentFrame()
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
                    return CommunityMainReactor.Action.touchUpFreeControl
                case 2:
                    return CommunityMainReactor.Action.touchUpQuestionControl
                case 3:
                    return CommunityMainReactor.Action.touchUpInfoControl
                default:
                    return CommunityMainReactor.Action.touchUpEntireControl
                }
            }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        naviView.rightCustomBtn.rx.tap
            .map { print("검색 버튼 클릭")
                return CommunityMainReactor.Action.touchUpSearchBtn }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        writeFloatingBtn.rx.tap
            .map {
                print("플로팅 버튼 클릭")
                return CommunityMainReactor.Action.touchUpWriteFloatingBtn }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        filterBtn.rx.tap
            .map {
                print("학과 버튼 클릭")
                return CommunityMainReactor.Action.filterFilled }
            .bind(to: reactor.action)
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
                communityCell.setCommunityData(data: item)
                
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
                loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
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
    }
    
    // TODO: 📌 함수 네이밍 변경하기!!!!
    private func bindView() {
        reactor?.action.onNext(.reloadCommunityTV(type: .entire))
        communityTV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        communitySV.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension CommunityMainVC {
    private func configureUI() {
        view.backgroundColor = .paleGray
        view.addSubviews([naviView, communitySV, writeFloatingBtn])
        communitySV.addSubview(contentView)
        contentView.addSubviews([topTouchBar, communityTV])
        topTouchBar.addSubviews([communitySegmentedControl, filterBtn])
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        communitySV.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        writeFloatingBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-91)
            $0.width.height.equalTo(64)
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        topTouchBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
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
        
        communityTV.snp.makeConstraints {
            $0.top.equalTo(topTouchBar.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
}

// MARK: - Custom Methods
extension CommunityMainVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        communityTV.register(CommunityTVC.self, forCellReuseIdentifier: CommunityTVC.className)
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

// MARK: - UIScrollViewDelegate
extension CommunityMainVC: UIScrollViewDelegate {
    
    /// scrollViewDidScroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
}
