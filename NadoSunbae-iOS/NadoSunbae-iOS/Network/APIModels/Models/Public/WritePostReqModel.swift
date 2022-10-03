//
//  WritePostReqModel.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/09/28.
//

import Foundation

struct WritePostReqModel {
    var type: PostFilterType
    var majorID: Int
    var answererID: Int
    var title: String
    var content: String
}
