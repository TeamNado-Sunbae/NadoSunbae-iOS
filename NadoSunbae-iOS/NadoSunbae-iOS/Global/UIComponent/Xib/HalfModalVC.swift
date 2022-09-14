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
}

class HalfModalVC: UIViewController {
    
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
    var selectMajorDelegate: SendUpdateModalDelegate?
    var selectFilterDelegate: SendUpdateStatusDelegate?
    var vcType: ModalType = .basic
    var cellType: MajorCellType = .basic
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(type: vcType)
        majorList = MajorInfo.shared.majorList ?? []
        setUpTV()
        setUpDelegate()
        tapCancelBtnAction()
        tapCompleteBtnAction()
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
            
        case .search:
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
    
    /// TableView setting 함수
    private func setUpTV() {
        MajorTVC.register(target: majorTV)
        
        majorTV.dataSource = self
        majorTV.delegate = self
        majorTV.separatorStyle = .none
    }
    
    private func setUpDelegate() {
        searchTextField.delegate = self
    }
    
    private func tapCancelBtnAction() {
        cancelBtn.press { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    /// 선택완료 버튼 클릭 시 데이터 전달
    private func tapCompleteBtnAction() {
        completeBtn.press { [weak self] in
            guard let self = self else { return }
            
            let selectedMajorName = self.majorList[self.majorTV.indexPathForSelectedRow?.row ?? 0].majorName
            let selectedMajorID = self.majorList[self.majorTV.indexPathForSelectedRow?.row ?? 0].majorID

            if let selectMajorDelegate = self.selectMajorDelegate {
                MajorInfo.shared.selectedMajorName = selectedMajorName
                MajorInfo.shared.selectedMajorID = selectedMajorID
                selectMajorDelegate.sendUpdate(data: selectedMajorName)
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
}

// MARK: - UITextFieldDelegate
extension HalfModalVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDelegate
extension HalfModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54.adjustedH
    }
}

// MARK: - UITableViewDelegate
extension HalfModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return majorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorTVC.className) as? MajorTVC else { return UITableViewCell() }
        
        cell.cellType = self.cellType
        cell.setData(majorName: majorList[indexPath.row].majorName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        completeBtn.isActivated = true
        completeBtn.titleLabel?.textColor = UIColor.mainDefault
    }
}

