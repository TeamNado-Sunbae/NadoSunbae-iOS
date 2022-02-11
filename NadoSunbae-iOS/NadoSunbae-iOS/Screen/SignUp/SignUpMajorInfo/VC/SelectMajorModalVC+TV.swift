//
//  SelectMajorModalVC+TV.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/10.
//

import UIKit

extension SelectMajorModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enterdBtnTag {
        case 0, 2:
            print("majorList: ", majorList)
            print("majorListCount: ", majorList.count)
            return majorList.count
        case 1, 3:
            return startList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectMajorModalTVC.className, for: indexPath) as? SelectMajorModalTVC else { return UITableViewCell() }
        
        switch enterdBtnTag {
        case 0, 2:
            cell.setData(majorName: majorList[indexPath.row].majorName)
        case 1, 3:
            cell.setData(majorName: startList[indexPath.row])
        default:
            break
        }
        
        return cell
    }
}

extension SelectMajorModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.adjusted
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeBtn.isActivated = true
        completeBtn.isEnabled = true
    }
}
