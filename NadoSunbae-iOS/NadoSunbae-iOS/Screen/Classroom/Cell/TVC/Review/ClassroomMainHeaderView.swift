//
//  ClassroomMainHeaderView.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/08/15.
//

import UIKit
import SnapKit
import Then

class ClassroomMainHeaderView: UITableViewHeaderFooterView {

    private let classroomSegmentedControl = NadoSegmentedControl(items: ["후기", "1:1질문"])
    
    private let filterBtn = UIButton().then {
        $0.setImage(UIImage(named: "btnFilter"), for: .normal)
    }
    
    private let arrangeBtn = UIButton().then {
        $0.setImage(UIImage(named: "btnArray"), for: .normal)
    }
    
    // MARK: init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: setNeedsLayout
    override func setNeedsLayout() {
        classroomSegmentedControl.setUpNadoSegmentFrame()
    }
}

// MARK: - UI
extension ClassroomMainHeaderView {
    private func configureUI() {
        contentView.addSubviews([classroomSegmentedControl, filterBtn, arrangeBtn])
        contentView.backgroundColor = .white
        
        classroomSegmentedControl.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(36)
            $0.width.equalTo(160)
        }
        
        arrangeBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(classroomSegmentedControl)
            $0.width.equalTo(68)
            $0.height.equalTo(24)
        }
        
        filterBtn.snp.makeConstraints {
            $0.trailing.equalTo(arrangeBtn.snp.leading).offset(-12)
            $0.centerY.equalTo(classroomSegmentedControl)
            $0.width.equalTo(48)
            $0.height.equalTo(24)
        }
    }
}
