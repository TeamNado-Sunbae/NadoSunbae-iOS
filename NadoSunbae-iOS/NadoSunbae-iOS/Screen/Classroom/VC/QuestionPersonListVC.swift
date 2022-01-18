//
//  QuestionPersonListVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/17.
//

import UIKit
import SnapKit
import Then

class QuestionPersonListVC: UIViewController {
    
    // MARK: Properties
    private let questionPersonNaviBar = NadoSunbaeNaviBar().then {
        $0.setUpNaviStyle(state: .backDefault)
        $0.configureTitleLabel(title: "국어국문학과")
    }
    
    private let questionPersonCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        $0.collectionViewLayout = layout
        $0.backgroundColor = .paleGray
        $0.contentInset = UIEdgeInsets.init(top: 16, left: 27, bottom: 0, right: 28)
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpDelegate()
        registerCell()
        registerXib()
        setUpTapNaviBackBtn()
    }
}

// MARK: - UI
extension QuestionPersonListVC {
    
    /// UI 구성 메서드
    private func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubviews([questionPersonNaviBar, questionPersonCV])
        
        questionPersonNaviBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(56)
        }
        
        questionPersonCV.snp.makeConstraints {
            $0.top.equalTo(questionPersonNaviBar.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
    }
}

// MARK: - Custom Methods
extension QuestionPersonListVC {
    
    /// 대리자 위임 메서드
    private func setUpDelegate() {
        questionPersonCV.delegate = self
        questionPersonCV.dataSource = self
    }
    
    /// 셀 등록 메서드
    private func registerCell() {
        questionPersonCV.register(QuestionPersonCVC.self, forCellWithReuseIdentifier: QuestionPersonCVC.className)
    }
    
    /// xib 등록 메서드
    private func registerXib() {
        let nibName = UINib(nibName: "QuestionPeopleHeaderView", bundle: nil)
        questionPersonCV.register(nibName, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "QuestionPeopleHeaderView")
    }
    
    /// 네비 back 버튼을 눌렀을 때 액션 set 메서드
    private func setUpTapNaviBackBtn() {
        questionPersonNaviBar.backBtn.press {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension QuestionPersonListVC: UICollectionViewDataSource {
    
    /// numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    /// numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return OnQuestionUserList.count
        case 1:
            return offQuestionUserList.count
        default:
            return 0
        }
    }
    
    /// cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let questionPeopleCell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionPersonCVC.className, for: indexPath) as? QuestionPersonCVC else { return UICollectionViewCell() }
        switch indexPath.section {
        case 0:
            questionPeopleCell.onSetData(model: OnQuestionUserList[indexPath.row])
            return questionPeopleCell
        case 1:
            questionPeopleCell.offSetData(model: offQuestionUserList[indexPath.row])
            return questionPeopleCell
        default: assert(false)
        }
    }
    
    /// viewForSupplementaryElementOfKind
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "QuestionPeopleHeaderView", for: indexPath) as? QuestionPeopleHeaderView else { return UICollectionReusableView() }
            switch indexPath.section {
            case 0:
                headerView.headerTitleLabel.text = "질문 가능해요"
                return headerView
            case 1:
                headerView.headerTitleLabel.text = "쉬고 있어요"
                return headerView
            default: headerView.headerTitleLabel.text = "질문 가능해요"
                return headerView
            }
        default: assert(false)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension QuestionPersonListVC: UICollectionViewDelegate {
    
    /// sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96.0, height: 120.0)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension QuestionPersonListVC: UICollectionViewDelegateFlowLayout {
    
    /// insetForSectionAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 40, right: 0)
    }
    
    /// referenceSizeForHeaderInSection
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 35
        return CGSize(width: width, height: height)
    }
}
