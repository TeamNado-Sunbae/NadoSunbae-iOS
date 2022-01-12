//
//  CVRegisterable.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/08.
//

import UIKit

protocol CVRegisterable {
    static var isFromNib: Bool { get }
    static func register(target: UICollectionView)
}

extension CVRegisterable where Self: UICollectionViewCell {
    static func register(target: UICollectionView) {
        if self.isFromNib {
          target.register(UINib(nibName: Self.className, bundle: nil), forCellWithReuseIdentifier: Self.className)
        } else {
          target.register(Self.self, forCellWithReuseIdentifier: Self.className)
        }
    }
}
