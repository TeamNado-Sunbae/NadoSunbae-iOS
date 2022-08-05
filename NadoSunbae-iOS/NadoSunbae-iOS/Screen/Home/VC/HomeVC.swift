//
//  HomeVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/07/11.
//

import UIKit
import SnapKit
import Then

class HomeVC: BaseVC {

    // MARK: Components
    private var backgroundTV = UITableView().then {
        $0.separatorStyle = .none
        $0.backgroundColor = .white
    }
    
    // MARK: - Properties
    enum HomeBackgroundTVSectionType: Int {
        case banner = 0, review, questionPerson, community
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setBackgroundTV()
    }
    
    private func setBackgroundTV() {
        backgroundTV.dataSource = self
        backgroundTV.delegate = self
        
        backgroundTV.sectionHeaderTopPadding = 0
        
        backgroundTV.register(HomeBannerHeaderCell.self, forCellReuseIdentifier: HomeBannerHeaderCell.className)
        backgroundTV.register(HomeTitleHeaderCell.self, forCellReuseIdentifier: HomeTitleHeaderCell.className)
        backgroundTV.register(HomeFooterCell.self, forCellReuseIdentifier: HomeFooterCell.className)
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // MARK: Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .banner:
                return 1
            case .review:
                return 2
            case .questionPerson:
                return 4
            case .community:
                return 2
            }
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: indexPath.section) {
            switch tableSection {
            case .banner:
                return UITableViewCell()
            case .review:
                return UITableViewCell()
            case .questionPerson:
                return UITableViewCell()
            case .community:
                return UITableViewCell()
            }
        } else { return UITableViewCell() }
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    
    // MARK: Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .banner:
                guard let headerView = tableView.dequeueReusableCell(withIdentifier: HomeBannerHeaderCell.className) as? HomeBannerHeaderCell else { return HomeBannerHeaderCell() }
                return headerView
            case .review:
                guard let headerView = tableView.dequeueReusableCell(withIdentifier: HomeTitleHeaderCell.className) as? HomeTitleHeaderCell else { return HomeTitleHeaderCell() }
                headerView.setTitleLabel(titleText: "후기")
                return headerView
            case .questionPerson:
                guard let headerView = tableView.dequeueReusableCell(withIdentifier: HomeTitleHeaderCell.className) as? HomeTitleHeaderCell else { return HomeTitleHeaderCell() }
                headerView.setTitleLabel(titleText: "1:1질문")
                return headerView
            case .community:
                guard let headerView = tableView.dequeueReusableCell(withIdentifier: HomeTitleHeaderCell.className) as? HomeTitleHeaderCell else { return HomeTitleHeaderCell() }
                headerView.setTitleLabel(titleText: "커뮤니티")
                return headerView
            }
        } else { return UIView() }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .banner:
                let headerHeight = 60.0
                tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: headerHeight))
                tableView.contentInset = UIEdgeInsets(top: -headerHeight, left: 0, bottom: 0, right: 0)
                return headerHeight
            case .review, .questionPerson, .community:
                return 70
            }
        } else { return 0 }
    }
    
    }
}

// MARK: - UI
extension HomeVC {
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        view.addSubviews([backgroundTV])
        
        backgroundTV.snp.makeConstraints {
            $0.horizontalEdges.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
