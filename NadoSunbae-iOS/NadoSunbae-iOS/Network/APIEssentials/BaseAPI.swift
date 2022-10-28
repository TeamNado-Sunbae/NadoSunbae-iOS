//
//  BaseAPI.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/09/07.
//

import Foundation
import Moya

class BaseAPI {
    func judgeStatus<T: Codable>(by statusCode: Int, _ data: Data, _ type: T.Type) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<T>.self, from: data)
                
        else { return .pathErr }

        switch statusCode {
        case 200...202:
            return .success(decodedData.data ?? "None-Data")
        case 401:
            return .requestErr(false)
        case 404:
            return .requestErr(404)
        case 400, 402, 403, 405..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
