//
//  MajorTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit
import SnapKit
import Then

enum MajorCellType {
    case basic
    case star
}

class MajorTVC: CodeBaseTVC {

    // MARK: Components
    private let starBtn = UIButton().then {
        $0.setImgByName(name: "star", selectedName: "star_selected")
    }
    
    private let majorNameLabel = UILabel().then {
        $0.font = .PretendardR(size: 14)
        $0.textColor = .black
    }
    
    private let checkImgView = UIImageView().then {
        $0.image = UIImage(named: "small_check")
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .gray1
    }
    
    // MARK: Properties
    var cellType: MajorCellType = .basic
    var sendBtnStatusDelegate: SendCellBtnStatusDelegate?
    private var indexPath: IndexPath?
    
    // MARK: Life Cycle
    override func setViews() {
        tapStarBtnAction()
    }
    
    override func layoutIfNeeded() {
        configureUI(type: cellType)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        starBtn.isHidden = false
        starBtn.isSelected = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkImgView.isHidden = selected ? false : true
        if selected {
            majorNameLabel.setLabel(text: majorNameLabel.text ?? "", color: .mainDefault, size: 14, weight: .semiBold)
        } else {
            majorNameLabel.setLabel(text: majorNameLabel.text ?? "", color: .mainText, size: 14, weight: .regular)
        }
    }
}

// MARK: - UI
extension MajorTVC {
    func configureUI(type: MajorCellType) {
        contentView.addSubviews([majorNameLabel, checkImgView, lineView, starBtn])
        
        switch type {
            
        case .basic:
            majorNameLabel.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            checkImgView.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(10)
                $0.height.equalTo(6)
            }
            
            lineView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        case .star:
            starBtn.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(24)
            }
            
            majorNameLabel.snp.makeConstraints {
                $0.leading.equalTo(starBtn.snp.trailing).offset(12)
                $0.centerY.equalToSuperview()
            }
            
            checkImgView.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(16)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(10)
                $0.height.equalTo(6)
            }
            
            lineView.snp.makeConstraints {
                $0.leading.trailing.bottom.equalToSuperview()
                $0.height.equalTo(1)
            }
        }
    }
}

// MARK: - Custom Methods
extension MajorTVC {
    private func tapStarBtnAction() {
        starBtn.press { [weak self] in
            guard let self = self else { return }
        
            self.starBtn.isSelected.toggle()
            self.sendBtnStatusDelegate?.sendBtnState(indexPath: self.indexPath ?? IndexPath(item: 0, section: 0), selectedState: self.starBtn.isSelected)
        }
    }
    
    /// Label에 학과 이름 setting하는 함수
    func setData(model: MajorInfoModel, indexPath: IndexPath) {
        majorNameLabel.text = model.majorName
        starBtn.isHidden = model.majorName == "학과 무관" || model.majorName == "미진입" ? true : false
        starBtn.isSelected = model.isFavorites
        
        self.indexPath = indexPath
    }
    
    func setMajorNameLabel(data: String) {
        majorNameLabel.text = data
    }
}
