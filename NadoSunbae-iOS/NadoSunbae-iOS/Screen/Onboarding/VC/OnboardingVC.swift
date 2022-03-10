//
//  OnboardingVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/03/08.
//

import UIKit

class OnboardingVC: BaseVC {

    // MARK: IBOutlet
    @IBOutlet weak var onboardingCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: NadoSunbaeBtn! {
        didSet {
            signUpBtn.isActivated = true
            signUpBtn.setTitleWithStyle(title: "회원가입", size: 14, weight: .semiBold)
            signUpBtn.makeRounded(cornerRadius: 8.adjusted)
        }
    }
    
    // MARK: Properties
    var onboardingData: [OnboardingContentData] = []
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setUpCV()
        registerCVC()
        initOnboardingData()
    }
    
    // MARK: IBAction
    @IBAction func tapSignUpBtn(_ sender: UIButton) {
        presentToSignUpVC()
    }
    
    @IBAction func tapSignInBtn(_ sender: UIButton) {
        presentToSignInVC()
    }
}

// MARK: - UI
extension OnboardingVC {
    private func configureUI() {
        pageControl.isUserInteractionEnabled = false
    }
}

// MARK: - Custom Methods
extension OnboardingVC {
    private func setUpCV() {
        onboardingCV.delegate = self
        onboardingCV.dataSource = self
    }
    
    private func registerCVC() {
        OnboardingCVC.register(target: onboardingCV)
        FirstOnboardingCVC.register(target: onboardingCV)
        ThirdOnboardingCVC.register(target: onboardingCV)
    }
    
    private func initOnboardingData() {
        onboardingData.append(contentsOf: [
            OnboardingContentData(title: "생생한 학과 후기", subtitle: "장단점, 뭘배우나요?, 추천수업, 비추수업,\n향후진로, 꿀팁 등으로 구성되어 있어요.", onboardingImgName: "group687"),
            OnboardingContentData(title: "다양한 정보 공유까지 !", subtitle: "학과 공지사항, 족보 등의 유용한 자료들이\n정보 게시판에 학과 별로 누적되고 있어요. ", onboardingImgName: "lastPage")
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDataSource
extension OnboardingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let onboardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCVC.className, for: indexPath) as? OnboardingCVC,
              let firstOnboardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstOnboardingCVC.className, for: indexPath) as? FirstOnboardingCVC,
              let thirdOnboardingCell = collectionView.dequeueReusableCell(withReuseIdentifier: ThirdOnboardingCVC.className, for: indexPath) as? ThirdOnboardingCVC else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            return firstOnboardingCell
        } else if indexPath.row == 1 {
            onboardingCell.setData(contentData: onboardingData[0])
            return onboardingCell
        } else if indexPath.row == 2 {
            return thirdOnboardingCell
        } else if indexPath.row == 3 {
            onboardingCell.setData(contentData: onboardingData[1])
            return onboardingCell
        }
        return UICollectionViewCell()
    }
}
