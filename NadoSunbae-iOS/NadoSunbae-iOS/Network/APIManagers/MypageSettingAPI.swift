//
//  MypageSettingAPI.swift
//  NadoSunbae-iOS
//
//  Created by madilyn on 2022/02/26.
//

import Foundation
import Moya

class MypageSettingAPI {
    static let shared = MypageSettingAPI()
    var provider = MoyaProvider<MypageSettingService>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    /// [PUT] 프로필 수정
    func editProfile(data: EditProfileRequestModel, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.editProfile(data: data)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.editProfileJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [GET] 앱 최신 버전 받기
    func getLatestVersion(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getLatestVersion) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getLatestVersionJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
}

// MARK: - JudgeData
extension MypageSettingAPI {
    private func editProfileJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<EditProfileResponseModel>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data ?? "None-Data")
        case 400...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func getLatestVersionJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<GetLatestVersionResponseModel>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data ?? "None-Data")
        case 400...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
 }
