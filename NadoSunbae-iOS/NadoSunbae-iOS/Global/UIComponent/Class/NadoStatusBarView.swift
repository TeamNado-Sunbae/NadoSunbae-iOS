//
//  NadoStatusBarView.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/22.
//

import UIKit
import SnapKit
import Then

final class NadoStatusBarView: UIView {
    
    // MARK: Components
    private var contentLabel = UILabel()
    private (set) var rightQuestionMarkButton = UIButton().then {
        $0.setImage(UIImage(named: "ic_questionmark"), for: .normal)
    }
    
    // MARK: Initialization
    init(contentText: String, type: NadoStatusBarType) {
        super.init(frame: .zero)
        configureUI(type: type)
        setContentLabel(contentText: contentText)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    private func setContentLabel(contentText: String) {
        contentLabel.setLabel(text: contentText, color: .mainDark, size: 12, weight: .regular)
    }
}

// MARK: - UI
extension NadoStatusBarView {
    private func configureUI(type: NadoStatusBarType) {
        backgroundColor = .mainLight
        
        addSubviews([contentLabel])
        
        contentLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(26)
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
}
