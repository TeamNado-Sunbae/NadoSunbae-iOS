//
//  HomeRankerView.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/13.
//

import UIKit

enum RankerType {
    case first
    case secondThird
    case fourthFifth
}

final class HomeRankerView: UIView {
    
    // MARK: Components
    private let userNameLabel = UILabel()
    private let responseRateLabel = UILabel()
    private let profileImgView = UIImageView()
    
    // MARK: Properties
    var rankerType: RankerType = .first
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI
extension HomeRankerView {
    private func configureUI() {
        switch rankerType {
        case .first:
            
        case .secondThird:
            
        case .fourthFifth:
            
        }
    }
}
