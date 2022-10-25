//
//  SignUpModalVC.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/09/13.
//

import UIKit

class SignUpModalVC: BaseVC {
    
    // MARK: Components
    private let titleLabel = UILabel().then {
        $0.font = .PretendardM(size: 16)
        $0.textColor = .black
        $0.text = "학과선택"
    }
    
    private let cancelBtn = UIButton().then {
        $0.setImage(UIImage(named: "btnX"), for: .normal)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .mainDefault
    }
    
    private let majorTV = UITableView().then {
        $0.separatorStyle = .none
    }
    
    private let completeBtn = NadoSunbaeBtn().then {
        $0.isActivated = false
        $0.setTitle("선택 완료", for: .normal)
    }
    
    private let searchTextField = NadoTextField().then {
        $0.setSearchStyle()
        $0.returnKeyType = .done
    }
    
    // MARK: Properties
    var enterType: SignUpMajorInfoEnterType = .firstMajor
    var univID = 0
    private var startList: [String] = []
    private var majorList: [MajorInfoModel] = []
    private var filteredList: [MajorInfoModel] = []
    private var dataSourceForMajor: UITableViewDiffableDataSource<Section, MajorInfoModel>?
    private var snapshotForMajor: NSDiffableDataSourceSnapshot<Section, MajorInfoModel>?
    private var dataSourceForStart: UITableViewDiffableDataSource<Section, String>?
    private var snapshotForStart: NSDiffableDataSourceSnapshot<Section, String>?
    var selectMajorDelegate: SendUpdateModalDelegate?
    var vcType: ModalType = .basic
    var cellType: MajorCellType = .basic
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(type: vcType)
        setCompleteBtnAction()
        setUpSearchTextField()
        setMajorTableViewDataSource()
        setData(enterType: enterType)
        setCompleteBtnAction()
        setUpMajorTV()
        tapCancelBtnAction()

    }
    
    private func setData(enterType: SignUpMajorInfoEnterType) {
        switch enterType {
        case .firstMajor:
            requestGetMajorList(univID: univID, filterType: "firstMajor")
            applySnapshotForMajor(filter: "")
        case .firstMajorStart, .secondMajorStart:
            setStartList()
            applySnapshotForStart()
        case .secondMajor:
            requestGetMajorList(univID: univID, filterType: "secondMajor")
            applySnapshotForMajor(filter: "")
        }
    }
    
    private func setStartList() {
        for i in stride(from: 22, to: 14, by: -1) {
            self.startList.append("\(i)-2")
            self.startList.append("\(i)-1")
        }
        self.startList.append("15년 이전")
        applySnapshotForStart()
    }
    
    private func setMajorTableViewDataSource() {
        switch enterType {
        case .firstMajor, .secondMajor:
            self.dataSourceForMajor = UITableViewDiffableDataSource<Section, MajorInfoModel>(tableView: self.majorTV) { (tableView, indexPath, data) -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorTVC.className, for: indexPath) as? MajorTVC else { preconditionFailure() }
                cell.cellType = self.cellType
                cell.setData(majorName: data)
                return cell
            }
        case .firstMajorStart, .secondMajorStart:
            self.dataSourceForStart = UITableViewDiffableDataSource<Section, String>(tableView: self.majorTV) { (tableView, indexPath, data) -> UITableViewCell? in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorTVC.className, for: indexPath) as? MajorTVC else { preconditionFailure() }
                cell.cellType = self.cellType
                cell.setMajorNameLabel(data: data)
                return cell
            }
        }
    }
    
    private func setCompleteBtnAction() {
        completeBtn.press {
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
            })
            
            switch self.enterType {
            case .firstMajor, .secondMajor:
                let sendData = { () -> MajorInfoModel in
                    return self.filteredList[self.majorTV.indexPathForSelectedRow?.row ?? 0]
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
    
    private func setUpMajorTV() {
        majorTV.delegate = self
        MajorTVC.register(target: majorTV)
    }
    
    private func setUpSearchTextField() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func applySnapshotForMajor(filter: String?) {
        let filtered = self.majorList.filter { $0.majorName.contains(filter ?? "")}
        
        snapshotForMajor = NSDiffableDataSourceSnapshot<Section, MajorInfoModel>()
        snapshotForMajor?.appendSections([.recent])
        if searchTextField.isEmpty {
            filteredList = majorList
            snapshotForMajor?.appendItems(majorList, toSection: .recent)
        } else {
            filteredList = filtered
            snapshotForMajor?.appendItems(filtered)
        }
        self.dataSourceForMajor?.apply(snapshotForMajor ?? NSDiffableDataSourceSnapshot<Section, MajorInfoModel>(), animatingDifferences: true)
    }
    
    private func applySnapshotForStart() {
        snapshotForStart = NSDiffableDataSourceSnapshot<Section, String>()
        snapshotForStart?.appendSections([.recent])
        snapshotForStart?.appendItems(startList, toSection: .recent)
        self.dataSourceForStart?.apply(snapshotForStart ?? NSDiffableDataSourceSnapshot<Section, String>(), animatingDifferences: true)
    }
    
    private func tapCancelBtnAction() {
        cancelBtn.press { [weak self] in
            self?.dismiss(animated: true)
        }
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
                    if let data = res as? [MajorInfoModel] {
                        for i in 0..<data.count {
                            self.majorList.append(MajorInfoModel(majorID: data[i].majorID, majorName: data[i].majorName))
                        }
                        self.activityIndicator.stopAnimating()
                        self.applySnapshotForMajor(filter: "")
                    }
                }
            case .requestErr(let msg):
                self.activityIndicator.stopAnimating()
                if let message = msg as? String {
                    print(message)
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                }
            default:
                self.activityIndicator.stopAnimating()
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpModalVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
            
    @objc
    func textFieldDidChange(_ sender: Any?) {
        applySnapshotForMajor(filter: searchTextField.text)
    }
}

// MARK: - UITableViewDelegate
extension SignUpModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.adjustedH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeBtn.isActivated = true
        completeBtn.titleLabel?.textColor = UIColor.mainDefault
    }
}


// MARK: - UI
extension SignUpModalVC {
    private func setTitleLabel(title: String) {
        titleLabel.text = title
    }
    
    private func configureUI(type: ModalType) {
        view.backgroundColor = .white
        setTitleLabel(title: enterType.rawValue)
        
        view.addSubviews([titleLabel, cancelBtn, lineView, majorTV, completeBtn, searchTextField])
        
        switch type {
        case .basic:
            titleLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(24)
            }
            
            cancelBtn.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.trailing.equalToSuperview().inset(16)
            }
            
            lineView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(15)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(1)
            }
            
            majorTV.snp.makeConstraints {
                $0.top.equalTo(lineView.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview().inset(32)
            }
            
            completeBtn.snp.makeConstraints {
                $0.top.equalTo(majorTV.snp.bottom).offset(27)
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.bottom.equalToSuperview().inset(34)
                $0.height.equalTo(60)
            }
            
        case .search, .communityFilter:
            titleLabel.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(24)
            }
            
            cancelBtn.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.trailing.equalToSuperview().inset(16)
            }
            
            lineView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(15)
                $0.leading.trailing.equalToSuperview().inset(16)
                $0.height.equalTo(1)
            }
            
            searchTextField.snp.makeConstraints {
                $0.top.equalTo(lineView.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(28)
                $0.height.equalTo(48)
            }
            
            majorTV.snp.makeConstraints {
                $0.top.equalTo(searchTextField.snp.bottom).offset(12)
                $0.leading.trailing.equalToSuperview().inset(32)
            }
            
            completeBtn.snp.makeConstraints {
                $0.top.equalTo(majorTV.snp.bottom).offset(27)
                $0.leading.trailing.equalToSuperview().inset(32)
                $0.bottom.equalToSuperview().inset(34)
                $0.height.equalTo(60)
            }
        }
    }
}
