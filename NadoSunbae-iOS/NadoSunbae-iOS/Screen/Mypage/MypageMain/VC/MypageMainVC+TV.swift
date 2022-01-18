//
//  MypageMainVC+TV.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/16.
//

import UIKit

// MARK: - UITableDataSource
extension MypageMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MypageQuestionTVC.className, for: indexPath) as? MypageQuestionTVC else { return UITableViewCell() }
        cell.setData(data: questionList[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MypageMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: 나중에 1:1 뷰랑 연결
        let vc = UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
