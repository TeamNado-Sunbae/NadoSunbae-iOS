//
//  HomeCommunityTVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/14.
//

import UIKit

final class HomeCommunityTVC: BaseTVC {
    
    // MARK: Components
    private let recentPostTV = UITableView().then {
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray0.cgColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.contentInset = .zero
        $0.separatorColor = .gray0
        $0.isScrollEnabled = false
        $0.estimatedRowHeight = 120
        $0.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: Properties
    var communityList: [PostListResModel] = []
    var didSelectItem: ((Int) -> ())?
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setRecentPostTV()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateRecentPostTVHeight()
    }
    
    private func setRecentPostTV() {
        recentPostTV.dataSource = self
        recentPostTV.delegate = self
        
        recentPostTV.register(CommunityTVC.self, forCellReuseIdentifier: CommunityTVC.className)
        
        recentPostTV.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    func updateRecentPostTVHeight() {
        self.recentPostTV.reloadData()
        self.recentPostTV.snp.updateConstraints {
            $0.height.equalTo(self.recentPostTV.contentSize.height)
        }
        self.recentPostTV.layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource
extension HomeCommunityTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath) as? CommunityTVC else { return CommunityTVC() }
        cell.setEssentialCommunityCellInfo(data: communityList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeCommunityTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem?(communityList[indexPath.row].postID)
    }
}

// MARK: - UI
extension HomeCommunityTVC {
    private func configureUI() {
        contentView.addSubviews([recentPostTV])
        
        recentPostTV.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(148)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
