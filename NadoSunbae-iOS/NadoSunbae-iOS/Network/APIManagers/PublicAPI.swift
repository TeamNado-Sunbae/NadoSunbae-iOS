//
//  PublicAPI.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation
import Moya

class PublicAPI {
    static let shared = PublicAPI()
    var userProvider = MoyaProvider<PublicService>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    /// [GET] 학과 리스트 조회  API
    func getMajorListAPI(univID: Int, filterType: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.getMajorList(univID: univID, filter: filterType)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.majorListJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
}

// MARK: - JudgeData
extension PublicAPI {
    
    /// majorListJudgeData
    func majorListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(GenericResponse<[MajorListData]>.self, from: data)
        
        switch status {
        case 200...204:
            return .success(decodedData?.data ?? "None-Data")
        case 400...409:
            return .requestErr(decodedData?.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
 }
