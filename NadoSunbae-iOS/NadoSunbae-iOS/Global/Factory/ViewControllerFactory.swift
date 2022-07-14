//
//  ViewControllerFactory.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class ViewControllerFactory: NSObject {
    
    static func viewController(for typeOfVC: TypeOfViewController) -> UIViewController {
        let metaData = typeOfVC.vcRepresentation()
        var vc = UIViewController()
        
        if metaData.storyboardName == "" {
            vc = metaData.vcClassName.getViewController() ?? UIViewController()
        } else {
            let sb = UIStoryboard(name: metaData.storyboardName, bundle: metaData.bundle)
            vc = sb.instantiateViewController(withIdentifier: metaData.vcClassName)
        }
        
        return vc
    }
}
