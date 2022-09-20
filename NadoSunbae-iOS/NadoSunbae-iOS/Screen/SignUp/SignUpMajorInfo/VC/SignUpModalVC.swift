//
//  SignUpModalVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/09/13.
//

import UIKit

class SignUpModalVC: HalfModalVC {
    
    // MARK: Properties
    var enterType: SignUpMajorInfoEnterType = .firstMajor
    var univID = 0
    var startList: [String] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData(enterType: enterType)
        setCompleteBtnAction()
    }
    
    private func setData(enterType: SignUpMajorInfoEnterType) {
        switch enterType {
        case .firstMajor:
            requestGetMajorList(univID: univID, filterType: "firstMajor")
        case .firstMajorStart:
            setStartList()
        case .secondMajor:
            requestGetMajorList(univID: univID, filterType: "secondMajor")
        case .secondMajorStart:
            setStartList()
        }
    }
    
    private func setStartList() {
        for i in stride(from: 22, to: 14, by: -1) {
            self.startList.append("\(i)-2")
            self.startList.append("\(i)-1")
        }
        self.startList.append("15년 이전")
        self.majorTV.reloadData()
    }
    
    /// 기존 completeBtn의 action을 제거하고, SignUp에 맞게 새로 action을 추가하는 메서드
    private func setCompleteBtnAction() {
        completeBtn.removeTarget(nil, action: nil, for: .allEvents)
        completeBtn.press {
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
            })
            
            switch self.enterType {
            case .firstMajor, .secondMajor:
                let sendData = { () -> MajorInfoModel in
                    return self.majorList[self.majorTV.indexPathForSelectedRow?.row ?? 0]
                }()
                self.selectMajorDelegate?.sendUpdate(data: (sendData, self.enterType))
            case .firstMajorStart, .secondMajorStart:
                let sendData = { () -> String in
                    return self.startList[self.majorTV.indexPathForSelectedRow?.row ?? 0]
                }()
                self.selectMajorDelegate?.sendUpdate(data: (sendData, self.enterType))
            }
        }
    }
}

extension SignUpModalVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enterType {
        case .firstMajor, .secondMajor:
            return majorList.count
        case .firstMajorStart, .secondMajorStart:
            return startList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorTVC.className, for: indexPath) as? MajorTVC else { return UITableViewCell() }
        
        switch enterType {
        case .firstMajor, .secondMajor:
            cell.setData(majorName: majorList[indexPath.row].majorName)
        case .firstMajorStart, .secondMajorStart:
            cell.setData(majorName: startList[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - Network
extension SignUpModalVC {
    
    /// 학과 정보 리스트 조회
    func requestGetMajorList(univID: Int, filterType: String) {
        self.activityIndicator.startAnimating()
        PublicAPI.shared.getMajorListAPI(univID: univID, filterType: filterType) { networkResult in
            switch networkResult {
            case .success(let res):
                DispatchQueue.main.async {
                    if let data = res as? [MajorListData] {
                        for i in 0..<data.count {
                            self.majorList.append(MajorInfoModel(majorID: data[i].majorID, majorName: data[i].majorName))
                        }
                        self.activityIndicator.stopAnimating()
                        self.majorTV.reloadData()
                    }
                }
            case .requestErr(let msg):
                self.activityIndicator.stopAnimating()
                if let message = msg as? String {
                    print(message)
                    self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: "네트워크 오류로 인해\n데이터를 불러올 수 없습니다.\n다시 시도해 주세요.")
            }
        }
    }
}
