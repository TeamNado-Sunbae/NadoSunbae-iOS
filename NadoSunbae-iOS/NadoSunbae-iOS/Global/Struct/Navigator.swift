//
//  Navigator.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/04/28.
//

import Foundation
import UIKit

struct Navigator {
    
    // MARK: Properties
    private var viewController: UIViewController
    
    // MARK: Init
    init(vc: UIViewController) {
        self.viewController = vc
    }
    
    // MARK: Public Methods
    public func instantiateVC<T>(destinationViewControllerType vcType: T.Type, useStoryboard: Bool, storyboardName sbName: String, naviType: NaviType = .present, modalPresentationStyle style: UIModalPresentationStyle = .fullScreen, completion: @escaping(T) -> ()) {
        var destinationVC: UIViewController = UIViewController()
        
        if useStoryboard {
            let storyboard = UIStoryboard(name: sbName, bundle: nil)
            destinationVC = storyboard.instantiateViewController(withIdentifier: String(describing: vcType.self))
        } else {
            if let vc = String(describing: vcType.self).getViewController() {
                destinationVC = vc
            }
        }
        
        switch naviType {
        case .push:
            completion(destinationVC as! T)
            viewController.navigationController?.pushViewController(destinationVC, animated: true)
        case .present:
            completion(destinationVC as! T)
            destinationVC.modalPresentationStyle = style
            viewController.present(destinationVC, animated: true, completion: nil)
        }
    }
}
