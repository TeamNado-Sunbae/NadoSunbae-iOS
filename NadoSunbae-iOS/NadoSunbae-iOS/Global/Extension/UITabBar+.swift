//
//  UITabBar+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/06.
//

import UIKit

extension UITabBar {
    
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
