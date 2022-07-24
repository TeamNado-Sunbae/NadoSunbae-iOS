//
//  CommunityWriteVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/07/24.
//

import UIKit
import ReactorKit

final class CommunityWriteVC: WriteQuestionVC, View {
    
    // MARK: Components
    private let selectMajorLabel = UILabel().then {
        $0.text = "학과 선택"
    }
    
    private let majorSelectTextField = NadoTextField().then {
        $0.setSelectStyle()
        $0.setText(text: "학과 무관")
    }
    
    private let majorSelectBtn = UIButton()
    
    private let categoryLabel = UILabel().then {
        $0.text = "카테고리"
    }
    
    private let categoryCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let partitionBar = UIView().then {
        $0.backgroundColor = .gray0
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        configureUI()
        configureLabel()
        setUpInitAction()
        registerCell()
    }
    
    func bind(reactor: CommunityWriteReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
}

// MARK: - UI
extension CommunityWriteVC {
    private func configureUI() {
        view.backgroundColor = .white
        contentView.addSubviews([selectMajorLabel, majorSelectTextField, majorSelectBtn, categoryLabel, categoryCV, partitionBar])
        
        selectMajorLabel.snp.makeConstraints {
            $0.top.equalTo(questionWriteNaviBar.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
        }
        
        majorSelectTextField.snp.makeConstraints {
            $0.top.equalTo(selectMajorLabel.snp.bottom).offset(16)
            $0.leading.equalTo(selectMajorLabel)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(48)
        }
        
        majorSelectBtn.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(majorSelectTextField)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(majorSelectTextField.snp.bottom).offset(24)
            $0.leading.equalTo(selectMajorLabel)
        }
        
        categoryCV.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(22)
            $0.leading.equalTo(categoryLabel)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(20)
        }
        
        partitionBar.snp.makeConstraints {
            $0.top.equalTo(categoryCV.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        questionTitleTextField.snp.removeConstraints()
        questionTitleTextField.snp.makeConstraints {
            $0.top.equalTo(partitionBar.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
        }
        
        contentHeaderLabel.removeFromSuperview()
        
        questionWriteTextView.snp.removeConstraints()
        questionWriteTextView.snp.makeConstraints {
            $0.top.equalTo(textHighlightView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(questionTitleTextField)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-102)
        }
    }
    
    private func configureLabel() {
        [selectMajorLabel, categoryLabel].forEach {
            $0.textColor = .gray4
            $0.font = .PretendardSB(size: 14.0)
        }
    }
}

// MARK: - Bind Action & State
extension CommunityWriteVC {
    
    // MARK: Action
    private func bindAction(_ reactor: CommunityWriteReactor) {
        majorSelectBtn.rx.tap
            .map { CommunityWriteReactor.Action.majorSelectBtnDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    // MARK: State
    private func bindState(_ reactor: CommunityWriteReactor) {
        reactor.state
            .map { $0.printedText }
            .subscribe(onNext: { text in
                print(text)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.categoryData }
            .distinctUntilChanged()
            .map { $0 }
            .bind(to: categoryCV.rx.items) { collectionView, index, item in
                let indexPath = IndexPath(row: index, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommunityWriteCategoryCVC.className, for: indexPath)
                
                guard let categoryCell = cell as? CommunityWriteCategoryCVC else { return UICollectionViewCell() }
                categoryCell.setData(categoryText: item)
                
                if indexPath.row == 0 {
                    categoryCell.isSelected = true
                }
                
                return categoryCell
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Methods
extension CommunityWriteVC {
    
    /// 셀 등록 메서드
    private func registerCell() {
        categoryCV.register(CommunityWriteCategoryCVC.self, forCellWithReuseIdentifier: CommunityWriteCategoryCVC.className)
    }
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        categoryCV.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    /// 초기 Action 설정 메서드
    private func setUpInitAction() {
        reactor?.action.onNext(.loadCategoryData)
        categoryCV.selectItem(at: [0, 0], animated: false, scrollPosition: .top)
    }
}

extension CommunityWriteVC: UICollectionViewDelegateFlowLayout {
    
    /// sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 61.adjusted, height: 32.adjustedH)
    }
}
