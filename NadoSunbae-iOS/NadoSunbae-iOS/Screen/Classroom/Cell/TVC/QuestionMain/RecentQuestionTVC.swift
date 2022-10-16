//
//  RecentQuestionTVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/14.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa

final class RecentQuestionTVC: CodeBaseTVC, View {
    
    let recentQuestionTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.isScrollEnabled = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        $0.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    var disposeBag = DisposeBag()
    
    override func setViews() {
        configureUI()
        setUpDelegate()
        registerCell()
    }
    
    func bind(reactor: RecentQuestionTVCReactor) {
        bindState(reactor)
    }
}

// MARK: - Bind State
extension RecentQuestionTVC {
    
    /// State
    private func bindState(_ reactor: RecentQuestionTVCReactor) {
        reactor.state
            .map { $0.questionList }
            .bind(to: recentQuestionTV.rx.items) { tableView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: BaseQuestionTVC.className, for: indexPath)
                
                guard let questionCell = cell as? BaseQuestionTVC else { return UITableViewCell() }
                questionCell.setEssentialCellInfo(data: item)
                questionCell.removeBottomSeparator(isLast: tableView.isLast(for: indexPath))
                
                return questionCell
            }
            .disposed(by: self.disposeBag)
        
        // recentQuestionTV의 변하는 TableViewHeight 구독하는 부분
        reactor.state
            .subscribe(onNext: { [weak self] _ in
                self?.recentQuestionTV.layoutIfNeeded()
                if let contentHeight = self?.recentQuestionTV.contentSize.height {
                    NotificationCenter.default.post(name: Notification.Name.sendChangedHeight, object: contentHeight)
                    self?.recentQuestionTV.snp.updateConstraints {
                        $0.height.equalTo(contentHeight)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension RecentQuestionTVC {
    private func configureUI() {
        contentView.addSubview(recentQuestionTV)
        
        recentQuestionTV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(0)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        contentView.backgroundColor = .paleGray
    }
}

// MARK: - Custom Methods
extension RecentQuestionTVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        recentQuestionTV.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        recentQuestionTV.register(BaseQuestionTVC.self, forCellReuseIdentifier: BaseQuestionTVC.className)
    }
}

// MARK: - UITableViewDelegate
extension RecentQuestionTVC: UITableViewDelegate {
    
    /// estimatedHeightForRowAt
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 157
    }
    
    /// heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
