//
//  SelectMajorModalVC+TV.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/10.
//

import UIKit

extension SelectMajorModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return majorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectMajorModalTVC.className, for: indexPath) as? SelectMajorModalTVC else { return UITableViewCell() }
        cell.setData(majorName: majorList[indexPath.row])
        return cell
    }
}

extension SelectMajorModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.adjusted
    }
}
