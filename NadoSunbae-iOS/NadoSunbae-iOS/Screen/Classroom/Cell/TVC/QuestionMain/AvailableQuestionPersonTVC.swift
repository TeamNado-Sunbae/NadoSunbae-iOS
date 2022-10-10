//
//  AvailableQuestionPersonTVC.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/13.
//

import UIKit
import Then
import SnapKit

final class AvailableQuestionPersonTVC: CodeBaseTVC {
    
    // MARK: Properties
    private let availableQuestionPersonCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 19
        $0.contentInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = true
    }
    
    private var majorUserList = MajorUserListDataModel(onQuestionUserList: [
//        QuestionUser(userID: 0, profileImageID: 1, isOnQuestion: true, nickname: "지으니", isFirstMajor: true, majorStart: "22-1"),
//        QuestionUser(userID: 0, profileImageID: 1, isOnQuestion: true, nickname: "지으니", isFirstMajor: true, majorStart: "22-1"),
//        QuestionUser(userID: 0, profileImageID: 1, isOnQuestion: true, nickname: "지으니", isFirstMajor: true, majorStart: "22-1"),
//        QuestionUser(userID: 0, profileImageID: 1, isOnQuestion: true, nickname: "지으니", isFirstMajor: true, majorStart: "22-1"),
//        QuestionUser(userID: 0, profileImageID: 1, isOnQuestion: true, nickname: "지으니", isFirstMajor: true, majorStart: "22-1"),
//        QuestionUser(userID: 0, profileImageID: 1, isOnQuestion: true, nickname: "지으니", isFirstMajor: true, majorStart: "22-1"),
//        QuestionUser(userID: 0, profileImageID: 1, isOnQuestion: true, nickname: "지으니", isFirstMajor: true, majorStart: "22-1"),
//        QuestionUser(userID: 0, profileImageID: 1, isOnQuestion: true, nickname: "지으니", isFirstMajor: true, majorStart: "22-1")
    ], offQuestionUserList: [])
    
    override func setViews() {
        configureUI()
        registerCVC()
        setUpDelegate()
        setUpUI()
    }
}

// MARK: - UI
extension AvailableQuestionPersonTVC {
    private func configureUI() {
        addSubview(availableQuestionPersonCV)
        
        availableQuestionPersonCV.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(140)
        }
    }
    
    private func setUpUI() {
        contentView.isHidden = true
        backgroundColor = .paleGray
        availableQuestionPersonCV.makeRounded(cornerRadius: 16)
    }
}

// MARK: - Custom Methods
extension AvailableQuestionPersonTVC {
    
    /// cell 등록 함수
    private func registerCVC() {
        availableQuestionPersonCV.register(AvailableQuestionPersonCVC.self, forCellWithReuseIdentifier: AvailableQuestionPersonCVC.className)
        availableQuestionPersonCV.register(SeeMoreQuestionPersonCVC.self, forCellWithReuseIdentifier: SeeMoreQuestionPersonCVC.className)
    }
    
    /// 대리자 위임
    private func setUpDelegate() {
        availableQuestionPersonCV.delegate = self
        availableQuestionPersonCV.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension AvailableQuestionPersonTVC: UICollectionViewDataSource {
    
    /// numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    /// cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let questionPeopleCell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableQuestionPersonCVC.className, for: indexPath) as? AvailableQuestionPersonCVC,
              let seeMoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeMoreQuestionPersonCVC.className, for: indexPath) as? SeeMoreQuestionPersonCVC else { return UICollectionViewCell() }

        // 마지막 셀은 더보기 셀 return
        if indexPath.row == 8 {
            return seeMoreCell
        } else {
            questionPeopleCell.setData(model: majorUserList.onQuestionUserList[indexPath.row])
            return questionPeopleCell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AvailableQuestionPersonTVC: UICollectionViewDelegateFlowLayout {
    
    /// sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 69.0, height: 108.0)
    }
}
