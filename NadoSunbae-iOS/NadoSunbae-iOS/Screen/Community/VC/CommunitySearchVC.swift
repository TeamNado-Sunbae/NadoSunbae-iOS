//
//  CommunitySearchVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/08/11.
//

import UIKit
import Then
import SnapKit
import ReactorKit

enum searchCase {
    case enterKeyword
    case doneSearch
}

final class CommunitySearchVC: BaseVC, View {
    
    // MARK: Components
    private let searchNaviBar = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backWithSearchBar)
        $0.searchBar.becomeFirstResponder()
    }
    
    private let searchSV = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    private let contentView = UIView()
    
    private let representStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fillProportionally
    }
    
    private let representStateImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let representStateLabel = UILabel().then {
        $0.font = UIFont.PretendardM(size: 18.0)
        $0.textColor = .gray2
    }
    
    private let searchTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.isScrollEnabled = false
    }
    
    // MARK: Variables
    var disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        configureUI()
        registerCell()
    }
    
    func bind(reactor: CommunitySearchReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - Bind Action & State
extension CommunitySearchVC {
    
    // MARK: Action
    private func bindAction(_ reactor: CommunitySearchReactor) {
        searchNaviBar.backBtn.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: State
    private func bindState(_ reactor: CommunitySearchReactor) {
        reactor.state
            .map { $0.searchList }
            .bind(to: searchTV.rx.items) { tableView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath)
                
                guard let communityCell = cell as? CommunityTVC else { return UITableViewCell() }
                communityCell.setCommunityData(data: item)
                
                return communityCell
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.searchList }
            .subscribe(onNext: { [weak self] data in
                if data.isEmpty {
                    self?.searchTV.isHidden = true
                    self?.representStackView.isHidden = false
                    self?.setUpEmptyViewBySearchList(searchCase: .doneSearch)
                } else {
                    self?.searchTV.isHidden = false
                    self?.representStackView.isHidden = true
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state
            .subscribe(onNext: { [weak self] _ in
                self?.searchTV.layoutIfNeeded()
                
                if let contentHeight = self?.searchTV.contentSize.height {
                    self?.searchTV.snp.updateConstraints {
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
    }
}

// MARK: - UI
extension CommunitySearchVC {
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews([searchNaviBar, representStackView, searchSV])
        
        searchSV.addSubview(contentView)
        contentView.addSubview(searchTV)
        
        representStackView.addArrangedSubview(representStateImageView)
        representStackView.addArrangedSubview(representStateLabel)
        
        searchNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(104)
        }
        
        representStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        searchSV.snp.makeConstraints {
            $0.top.equalTo(searchNaviBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().priority(.low)
            $0.centerX.top.bottom.equalToSuperview()
        }
        
        searchTV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.bottom.equalToSuperview().offset(-16)
        }
    }
}

// MARK: - Custom Methods
extension CommunitySearchVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        searchTV.register(CommunityTVC.self, forCellReuseIdentifier: CommunityTVC.className)
    }
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        searchTV.rx.setDelegate(self)
            .disposed(by: disposeBag)
        searchNaviBar.searchBar.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// searchCase에 따라 EmptyView stack의 내용을 채우는 메서드
    private func setUpEmptyViewBySearchList(searchCase: searchCase) {
        switch searchCase {
        case .enterKeyword:
            representStateImageView.image = UIImage(named: "searchFind")
            representStateLabel.text = "커뮤니티의 글을 검색해보세요."
        case .doneSearch:
            representStateImageView.image = UIImage(named: "searchEmpty")
            representStateLabel.text = "검색 결과가 없습니다."
        }
    }
}

// MARK: - UISearchBarDelegate
extension CommunitySearchVC: UISearchBarDelegate {
    
    /// searchBarSearchButtonClicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reactor?.action.onNext(.tapCompleteSearchBtn(searchKeyword: searchBar.searchTextField.text ?? ""))
        view.endEditing(true)
    }
    
    /// searchBarShouldEndEditing
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // 키보드가 내려갈 때 endEditing 상태가 되어도 cancelBtn은 활성화되어있도록 설정
        DispatchQueue.main.async {
            if let cancelBtn = searchBar.value(forKey: "cancelButton") as? UIButton {
                cancelBtn.isEnabled = true
            }
        }
        return true
    }
     
    /// searchBarShouldBeginEditing
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchTV.isHidden = true
        reactor?.action.onNext(.sendEmptyKeyword)
        setUpEmptyViewBySearchList(searchCase: .enterKeyword)
        return true
    }
}

// MARK: - UITableViewDelegate
extension CommunitySearchVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
