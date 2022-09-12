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
    }
    
    // MARK: Properties
    private let communityDummyData = [
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1)),
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1)),
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1)),
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1)),
        PostListResModel(postID: 0, type: "전체", title: "커뮤니티 제목", content: "커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목커뮤니티 제목", createdAt: "2022-08-14T01:35:59.500Z", majorName: "전체", writer: CommunityWriter(writerID: 0, nickname: "정빈걸"), commentCount: 1, like: Like(isLiked: true, likeCount: 1))
    ].shuffled()
    
    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setRecentPostTV()
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
}

// MARK: - UITableViewDataSource
extension HomeCommunityTVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTVC.className, for: indexPath) as? CommunityTVC else { return CommunityTVC() }
        cell.setCommunityData(data: communityDummyData[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeCommunityTVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("didselectRowAt")
    }
}

// MARK: - UI
extension HomeCommunityTVC {
    private func configureUI() {
        contentView.addSubviews([recentPostTV])
        
        recentPostTV.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
