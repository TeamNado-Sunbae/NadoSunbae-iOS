//
//  GetBannerListResponseData.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/09/21.
//

import Foundation

struct GetBannerListResponseDataElement: Codable {
    var imageURL: String
    var redirectURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "imageUrl"
        case redirectURL = "redirectUrl"
    }
}

typealias GetBannerListResponseData = [GetBannerListResponseDataElement]
