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
    var provider = MoyaProvider<MypageSettingService>()
    
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
    
    /// [GET] 차단 유저 목록 조회
    func getBlockList(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getBlockList) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getBlockListJudgeData(status: statusCode, data: data))
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 비밀번호 재설정
    func requestResetPW(email: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestResetPW(email: email)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.requestResetPWJudgeData(status: statusCode, data: data))
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
        case 401:
            return .requestErr(false)
        case 400, 402...409:
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
        case 401:
            return .requestErr(false)
        case 400, 402...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    private func getBlockListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<[GetBlockListResponseModel]>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data ?? "None-Data")
        case 401:
            return .requestErr(false)
        case 400, 402...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
        
    private func requestResetPWJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data ?? "None-Data")
        case 400:
            return .requestErr(decodedData.message)
        case 401...500:
            return .serverErr
        default:
            return .networkFail
        }
    }
 }
