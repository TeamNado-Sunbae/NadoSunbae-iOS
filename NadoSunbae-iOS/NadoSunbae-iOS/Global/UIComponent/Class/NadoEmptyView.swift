//
//  NadoEmptyView.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/10/06.
//

import UIKit
import Then
import SnapKit

/**
 - 나도선배에서 자주 사용되는 Empty View
 - radius는 해당 인스턴스에서 따로 설정 필요
 ---
 - Note:
 - setTitleLabel: titleLabel의 텍스트 변경
 */
class NadoEmptyView: UIView {
    
    // MARK: Components
    private let titleLabel = UILabel().then {
        $0.font = .PretendardR(size: 14)
        $0.textColor = .gray2
        $0.textAlignment = .center
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureUI()
    }
}

// MARK: - UI
extension NadoEmptyView {
    private func configureUI() {
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    func setTitleLabel(titleText: String) {
        titleLabel.text = titleText
    }
}
