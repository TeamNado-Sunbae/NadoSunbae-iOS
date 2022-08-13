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
        $0.allowsSelection = false
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
        backgroundTV.register(HomeBannerTVC.self, forCellReuseIdentifier: HomeBannerTVC.className)
        backgroundTV.register(HomeSubTitleHeaderCell.self, forCellReuseIdentifier: HomeSubTitleHeaderCell.className)
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
                guard let bannerCell = tableView.dequeueReusableCell(withIdentifier: HomeBannerTVC.className) as? HomeBannerTVC else { return HomeBannerTVC() }
                return bannerCell
            case .review:
                switch indexPath.row {
                case 0:
                    guard let subTitleCell = tableView.dequeueReusableCell(withIdentifier: HomeSubTitleHeaderCell.className) as? HomeSubTitleHeaderCell else { return HomeSubTitleHeaderCell() }
                    subTitleCell.setTitleLabel(title: "최근 후기")
                    subTitleCell.moreBtn.press {
                        debugPrint("최근 후기 more 버튼 클릭")
                    }
                    return subTitleCell
                case 1:
                    return UITableViewCell()
                default: return UITableViewCell()
                }
            case .questionPerson:
                switch indexPath.row {
                case 0:
                    guard let subTitleCell = tableView.dequeueReusableCell(withIdentifier: HomeSubTitleHeaderCell.className) as? HomeSubTitleHeaderCell else { return HomeSubTitleHeaderCell() }
                    subTitleCell.setTitleLabel(title: "선배랭킹")
                    subTitleCell.moreBtn.press {
                        debugPrint("선배랭킹 more 버튼 클릭")
                    }
                    return subTitleCell
                case 1:
                    return UITableViewCell()
                case 2:
                    guard let subTitleCell = tableView.dequeueReusableCell(withIdentifier: HomeSubTitleHeaderCell.className) as? HomeSubTitleHeaderCell else { return HomeSubTitleHeaderCell() }
                    subTitleCell.setTitleLabel(title: "최근 1:1 질문")
                    subTitleCell.moreBtn.press {
                        debugPrint("최근 1:1 질문 more 버튼 클릭")
                    }
                    return subTitleCell
                default: return UITableViewCell()
                }
            case .community:
                switch indexPath.row {
                case 0:
                    guard let subTitleCell = tableView.dequeueReusableCell(withIdentifier: HomeSubTitleHeaderCell.className) as? HomeSubTitleHeaderCell else { return HomeSubTitleHeaderCell() }
                    subTitleCell.setTitleLabel(title: "최근 게시글")
                    subTitleCell.moreBtn.press {
                        debugPrint("최근 게시글 more 버튼 클릭")
                    }
                    return subTitleCell
                case 1:
                    return UITableViewCell()
                default: return UITableViewCell()
                }
            }
        } else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: indexPath.section) {
            switch tableSection {
            case .banner:
                return 104
            case .review:
                switch indexPath.row {
                case 0:
                    return 40
                default: return 99
                }
            case .questionPerson:
                switch indexPath.row {
                case 0, 2:
                    return 40
                default: return 99
                }
            case .community:
                switch indexPath.row {
                case 0:
                    return 40
                default: return 99
                }
            }
        } else { return 0 }
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
    
    // MARK: Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .review, .questionPerson:
                guard let footerView = tableView.dequeueReusableCell(withIdentifier: HomeFooterCell.className) as? HomeFooterCell else { return HomeFooterCell() }
                return footerView
            default:
                return nil
            }
        } else { return nil }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let tableSection = HomeBackgroundTVSectionType(rawValue: section) {
            switch tableSection {
            case .review, .questionPerson:
                return 12
            default:
                return 0
            }
        } else { return 0 }
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
