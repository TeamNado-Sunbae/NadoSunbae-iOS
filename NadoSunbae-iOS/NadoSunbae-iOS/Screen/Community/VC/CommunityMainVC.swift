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
import RxSwift

class CommunityMainVC: BaseVC, View {
    
    // MARK: Components
    private var tabLabel = UILabel().then {
        $0.text = "커뮤니티"
    }
    
    private let communityTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    private var communityData: [CommunityPostList] = []
    var disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerCell()
        reactor?.action.onNext(.reloadCommunityTV)
    }
    
    func bind(reactor: CommunityMainReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind
extension CommunityMainVC {
    private func bindAction(_ reactor: CommunityMainReactor) {
        
    }
    
    private func bindState(_ reactor: CommunityMainReactor) {
        reactor.state
            .map { $0.communityList }
            .bind(to: self.communityTV.rx.items) { tableView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath)
                
                guard let communityCell = cell as? CommunityTVC else { return UITableViewCell() }
                communityCell.setCommunityData(data: item)
                return communityCell
            }
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.loading }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(onNext: { [weak self] loading in
                self?.view.bringSubviewToFront(self?.activityIndicator ?? UIView())
                loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension CommunityMainVC {
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews([tabLabel, communityTV])
        
        tabLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        communityTV.snp.makeConstraints {
            $0.top.equalTo(tabLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-16)
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
