//
//  HalfModalVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit
import SnapKit
import Then
import Moya

enum ModalType {
    case basic
    case search
    case communityFilter
}

enum Section: CaseIterable {
    case recent
}

class HalfModalVC: BaseVC {
    
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
    
    private let majorTV = UITableView()
    
    private let completeBtn = NadoSunbaeBtn().then {
        $0.isActivated = false
        $0.setTitle("선택 완료", for: .normal)
    }
    
    private let searchTextField = NadoTextField().then {
        $0.setSearchStyle()
        $0.returnKeyType = .done
    }
    
    // MARK: Properties
    private var majorList: [MajorInfoModel] = []
    private var filteredList: [MajorInfoModel] = []
    var secondMajorList: [MajorInfoModel] = []
    var dataSource: UITableViewDiffableDataSource<Section, MajorInfoModel>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, MajorInfoModel>!
    var selectMajorDelegate: SendUpdateModalDelegate?
    var selectFilterDelegate: SendUpdateStatusDelegate?
    var selectCommunityDelegate: SendCommunityInfoDelegate?
    var vcType: ModalType = .basic
    var cellType: MajorCellType = .basic
    var hasNoMajorOption: Bool = true
    var isSecondMajorSheet: Bool = false
    var selectFilterIndex: Int = 0
    var filteredIndex: Int = 0
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(type: vcType)
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        setUpMajorList(hasNoMajorOption: hasNoMajorOption)
        setUpDelegate()
        setUpTV()
        applySnapshot(filter: "")
        tapCancelBtnAction()
        tapCompleteBtnAction(type: vcType)
        setUpDefaultStatus()
    }
}

// MARK: - UI
extension HalfModalVC {
    private func configureUI(type: ModalType) {
        view.backgroundColor = .white
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

// MARK: - Custom Methods
extension HalfModalVC {
    private func setUpDelegate() {
        majorTV.delegate = self
        searchTextField.delegate = self
    }
    
    private func setUpTV() {
        majorTV.separatorStyle = .none
        MajorTVC.register(target: majorTV)
        
        self.dataSource = UITableViewDiffableDataSource<Section, MajorInfoModel>(tableView: self.majorTV) { (tableView, indexPath, majorModel) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorTVC.className, for: indexPath) as? MajorTVC else { preconditionFailure() }
            
            cell.cellType = self.cellType
            cell.setData(model: majorModel, indexPath: indexPath)
            cell.sendBtnStatusDelegate = self
            
            return cell
        }
    }
    
    private func applySnapshot(filter: String?, applyAnimation: Bool = true) {
        let filtered = self.majorList.filter { $0.majorName.contains(filter ?? "")}
        
        snapshot = NSDiffableDataSourceSnapshot<Section, MajorInfoModel>()
        snapshot.appendSections([.recent])
        if searchTextField.isEmpty {
            filteredList = majorList
            snapshot.appendItems(majorList, toSection: .recent)
        } else {
            filteredList = filtered
            snapshot.appendItems(filtered)
        }
        self.dataSource.apply(snapshot, animatingDifferences: applyAnimation)
    }
    
    private func tapCancelBtnAction() {
        cancelBtn.press { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    /// 선택완료 버튼 클릭 시 데이터 전달
    private func tapCompleteBtnAction(type: ModalType) {
        completeBtn.press { [weak self] in
            guard let self = self else { return }
            
            var selectedMajorName: String = ""
            var selectedMajorID: Int = MajorIDConstants.allMajorID // 기본값을 allMajorID로 설정
            
            switch type {
                
            case .basic, .search:
                selectedMajorName = self.filteredList[self.majorTV.indexPathForSelectedRow?.row ?? 0].majorName
                selectedMajorID = self.filteredList[self.majorTV.indexPathForSelectedRow?.row ?? 0].majorID
            case .communityFilter:
                if let selectRow = self.majorTV.indexPathForSelectedRow?.row {
                    selectedMajorName = self.filteredList[selectRow].majorName
                    selectedMajorID = self.filteredList[selectRow].majorID
                }
            }
            
            // selectMajorDelegate일 때
            if let selectMajorDelegate = self.selectMajorDelegate {
                MajorInfo.shared.selectedMajorName = selectedMajorName
                MajorInfo.shared.selectedMajorID = selectedMajorID
                selectMajorDelegate.sendUpdate(data: selectedMajorName)
            }
            
            // communityDelegate일 때
            if let selectCommunityDelegate = self.selectCommunityDelegate {
                // 선택된 값이 없을 때에는 majorID: 0 (전체), majorName: "" 으로 전달
                selectCommunityDelegate.sendCommunityInfo(majorID: selectedMajorID, majorName: selectedMajorName)
            }
            
            if self.selectFilterDelegate != nil {
                ReviewFilterInfo.shared.selectedBtnList = [false, false, false, false, false, false, false]
                self.selectFilterDelegate?.sendStatus(data: false)
            }
            
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name.dismissHalfModal, object: nil)
            })
        }
    }
    
    /// 인덱스 셀이 초기 선택되도록하는 메서드
    private func setUpDefaultStatus() {
        switch vcType {
            
        case .basic, .search:
            if majorList[0].majorName == "학과 무관" || majorList[0].majorName == "미진입" {
                self.majorTV.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
                completeBtn.isActivated = true
                completeBtn.titleLabel?.textColor = UIColor.mainDefault
            }
        case .communityFilter:
            
            // 초기값은 아무것도 선택되어있지 않은 상태여야 함
            if selectFilterIndex != 0 {
                // 학과무관의 ID값이 넘어올 경우
                if selectFilterIndex == MajorIDConstants.regardlessMajorID {
                    // indexPath를 지정해주기 위해 값을 0으로 변경한다
                    selectFilterIndex = 0
                }
                
                for i in 0...filteredList.count - 1 {
                    if filteredList[i].majorID == selectFilterIndex {
                        filteredIndex = i
                    }
                }
                
                self.majorTV.selectRow(at: IndexPath(row: filteredIndex, section: 0), animated: false, scrollPosition: .top)
                completeBtn.isActivated = true
                completeBtn.titleLabel?.textColor = UIColor.mainDefault
            }
        }
    }
    
    /// 학과 리스트 삽입 메서드 (학과 무관 옵션 유무 Bool값으로 결정)
    private func setUpMajorList(hasNoMajorOption: Bool) {
        if hasNoMajorOption {
            majorList = MajorInfo.shared.majorList ?? []
            if isSecondMajorSheet {
                majorList = secondMajorList
            }
        } else {
            var classroomList = MajorInfo.shared.majorList
            classroomList?.remove(at: 0)
            majorList = classroomList ?? []
        }
    }
    
    /// 타이틀 변경 메서드
    func setUpTitleLabel(_ title: String) {
        self.titleLabel.text = title
    }
}

// MARK: - UITextFieldDelegate
extension HalfModalVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    @objc
    func textFieldDidChange(_ sender: Any?) {
        applySnapshot(filter: searchTextField.text)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        makeAnalyticsEvent(eventName: .bottomsheet_function, parameterValue: "search_major")
    }
}

// MARK: - SendCellBtnStatusDelegate
extension HalfModalVC: SendCellBtnStatusDelegate {
    func sendBtnState(indexPath: IndexPath, selectedState: Bool) {
        majorList[indexPath.row].isFavorites = selectedState
        filteredList[indexPath.row].isFavorites = selectedState
        registerFavoriteMajor(majorID: filteredList[indexPath.row].majorID)
    }
}

// MARK: - UITableViewDelegate
extension HalfModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.adjustedH
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch vcType {
            
        case .basic, .search:
            return indexPath
        case .communityFilter:
            guard let cellIndexPath = tableView.cellForRow(at: indexPath) else { return IndexPath(row: 0, section: 0) }
            
            // 이미 선택된 셀을 다시 선택할 경우
            if cellIndexPath.isSelected {
                // 선택 해제
                tableView.deselectRow(at: indexPath, animated: true)
                return nil
            } else {
                return indexPath
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeBtn.isActivated = true
        completeBtn.titleLabel?.textColor = UIColor.mainDefault
    }
}

// MARK: - Network
extension HalfModalVC {
    
    /// 학과 리스트 조회 메서드
    private func requestGetMajorList(univID: Int, filterType: String, userID: Int) {
        PublicAPI.shared.getMajorListAPI(univID: univID, filterType: filterType, userID: userID) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if let data = res as? [MajorInfoModel] {
                    MajorInfo.shared.majorList = data
                }
            case .requestErr(let res):
                if let _ = res as? String {
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.requestGetMajorList(univID: univID, filterType: filterType, userID: userID)
                    }
                }
            default:
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
    
    /// 즐겨찾기 등록 및 취소 메서드
    private func registerFavoriteMajor(majorID: Int) {
        PublicAPI.shared.registerFavoriteMajorAPI(majorID: majorID) { networkResult in
            switch networkResult {
                
            case .success(let res):
                if let favoriteData = res as? FavoriteMajorPostResModel {
                    self.applySnapshot(filter: self.searchTextField.text?.isEmpty ?? false ? "" : self.searchTextField.text, applyAnimation: false)
                    self.requestGetMajorList(univID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.univID), filterType: "all", userID: UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID))
                    self.makeAnalyticsEvent(eventName: .bottomsheet_function, parameterValue: favoriteData.isDeleted ? "favorite_off" : "favorite_on")
                }
            case .requestErr(let res):
                if let _ = res as? String {
                    self.activityIndicator.stopAnimating()
                    self.makeAlert(title: AlertType.networkError.alertMessage)
                } else if res is Bool {
                    self.updateAccessToken { _ in
                        self.registerFavoriteMajor(majorID: majorID)
                    }
                }
            default:
                self.makeAlert(title: AlertType.networkError.alertMessage)
            }
        }
    }
}
