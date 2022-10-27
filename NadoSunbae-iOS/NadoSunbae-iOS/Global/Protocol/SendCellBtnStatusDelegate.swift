//
//  SendCellBtnStatusDelegate.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/10/27.
//

import Foundation

protocol SendCellBtnStatusDelegate: AnyObject {
    func sendBtnState(indexPath: IndexPath, selectedState: Bool)
}
