//
//  SignUpModalVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/09/13.
//

import UIKit

class SignUpModalVC: HalfModalVC {
    
    // MARK: Properties
    var enteredBtnTag = 0
    var univID = 0
    var startList: [String] = []
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleLabel()
    }
    /// enterBtnTag에 맞춰서 타이틀, 데이터 변경하는 함수
    private func setTitleLabel() {
        titleLabel.text = { () -> String in
            switch enteredBtnTag {
            case 0:
                self.activityIndicator.startAnimating()
                requestGetMajorList(univID: univID, filterType: "firstMajor")
                return "본전공"
            case 1:
                self.view.subviews.forEach {
                    $0.removeFromSuperview()
                }
                self.configureUI(type: .basic)
                self.searchTextField.removeFromSuperview()
                setStartList()
                return "본전공 진입시기"
            case 2:
                self.activityIndicator.startAnimating()
                requestGetMajorList(univID: univID, filterType: "secondMajor")
                return "제2전공"
            case 3:
                self.view.subviews.forEach {
                    $0.removeFromSuperview()
                }
                self.configureUI(type: .basic)
                self.searchTextField.removeFromSuperview()
                setStartList()
                return "제2전공 진입시기"
            default:
                return ""
            }
        }()
    }
    
    private func setStartList() {
        for i in stride(from: 22, to: 14, by: -1) {
            self.startList.append("\(i)-2")
            self.startList.append("\(i)-1")
        }
        self.startList.append("15년 이전")
        self.majorTV.reloadData()
    }
}

extension SignUpModalVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enteredBtnTag {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorTVC.className, for: indexPath) as? MajorTVC else { return UITableViewCell() }
        
        switch enteredBtnTag {
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

// MARK: - Network
extension SignUpModalVC {
    
    /// 학과 정보 리스트 조회
    func requestGetMajorList(univID: Int, filterType: String) {
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
