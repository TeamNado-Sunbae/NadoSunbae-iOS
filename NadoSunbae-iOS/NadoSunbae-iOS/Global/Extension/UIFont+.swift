//
//  UIFont+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

enum FontWeight {
    case light, regular, medium, bold, semiBold
}

extension UIFont {
    
    // MARK: Pretendard Font
    class func PretendardL(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Light", size: size.adjusted)!
    }
    
    class func PretendardR(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size.adjusted)!
    }
    
    class func PretendardM(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Medium", size: size.adjusted)!
    }
    
    class func PretendardB(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Bold", size: size.adjusted)!
    }
    
    class func PretendardSB(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size.adjusted)!
    }
}


