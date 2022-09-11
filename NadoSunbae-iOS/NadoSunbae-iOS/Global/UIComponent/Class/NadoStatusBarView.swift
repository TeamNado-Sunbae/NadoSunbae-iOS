//
//  NadoStatusBarView.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/22.
//

import UIKit
import SnapKit
import Then

enum NadoStatusBarType {
    case label
    case labelQuestionMarkButton
}

/**
 Navi Bar 밑에 붙어 있는 민트색 Status Bar
 - Note:
 - label: 텍스트만
 - labelQuestionMarkButton: 텍스트 + 우측 물음표 버튼
 */
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
        
        if type == .labelQuestionMarkButton {
            addSubviews([rightQuestionMarkButton])
            
            rightQuestionMarkButton.snp.makeConstraints {
                $0.right.equalToSuperview().inset(20)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(17)
            }
        }
    }
}
