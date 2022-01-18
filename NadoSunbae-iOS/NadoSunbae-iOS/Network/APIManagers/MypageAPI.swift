//
//  MypageAPI.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation
import Moya

class MypageAPI {
    static let shared = MypageAPI()
    private var provider = MoyaProvider<MypageService>()
    
    private init() {}
}

// MARK: - API
extension MypageAPI {
    
    /// [GET] 특정 유저 정보 조회
    func getUserInfo(userID: Int, accessToken: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getUserInfo(userID: userID, accessToken: accessToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getUserInfoJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

// MARK: - judgeData
extension MypageAPI {
    private func getUserInfoJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<MypageUserInfoModel>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200:
            return .success(decodedData.data ?? "None-Data")
        case 400...500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}

