//
//  ClassroomPageVC.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/16.
//

import UIKit

class ClassroomPageVC: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegate()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Custom Methods
extension ClassroomPageVC {
    private func setUpDelegate() {
        self.delegate = self
        self.dataSource = self
    }
}

// MARK: - UIPageViewControllerDelegate
extension ClassroomPageVC: UIPageViewControllerDelegate {
    
}

// MARK: - UIPageViewControllerDataSource
extension ClassroomPageVC: UIPageViewControllerDataSource {
    
    /// viewControllerBefore
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    /// viewControllerAfter
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
}
