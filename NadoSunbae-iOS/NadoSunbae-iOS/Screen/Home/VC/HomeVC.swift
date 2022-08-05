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
