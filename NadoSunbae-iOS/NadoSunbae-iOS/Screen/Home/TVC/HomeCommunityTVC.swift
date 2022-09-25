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
        $0.estimatedRowHeight = 150
        $0.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: Properties
    var communityList: [PostListResModel] = []
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setRecentPostTV()
        getRecentCommunityList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setRecentPostTV() {
        recentPostTV.dataSource = self
        recentPostTV.delegate = self
        
        recentPostTV.register(CommunityTVC.self, forCellReuseIdentifier: CommunityTVC.className)
        
        recentPostTV.removeSeparatorsOfEmptyCellsAndLastCell()
    }
    
    func updateRecentPostTVHeight() {
        self.recentPostTV.snp.updateConstraints {
            $0.height.equalTo(self.recentPostTV.contentSize.height)
        }
        self.recentPostTV.layoutIfNeeded()
        NotificationCenter.default.post(name: Notification.Name.sendChangedHeight, object: self.recentPostTV.contentSize.height)
    }
}

// MARK: - UITableViewDataSource
extension HomeCommunityTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return communityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath) as? CommunityTVC else { return CommunityTVC() }
        cell.setCommunityData(data: communityList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeCommunityTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Community Detail로 연결
        debugPrint("didselectRowAt")
    }
}

// MARK: - Network
extension HomeCommunityTVC {
    func getRecentCommunityList() {
        PublicAPI.shared.getPostList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), majorID: 0, filter: .community, sort: "recent", search: "") { networkResult in
            switch networkResult {
            case .success(let res):
                if let data = res as? [PostListResModel] {
                    for i in 0..<3 {
                        self.communityList.append(data[i])
                    }
                    self.recentPostTV.reloadData()
                    self.updateRecentPostTVHeight()
                }
            default:
                debugPrint(#function, "network error")
            }
        }
    }
}

// MARK: - UI
extension HomeCommunityTVC {
    private func configureUI() {
        contentView.addSubviews([recentPostTV])
        
        recentPostTV.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(148 * 3)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
