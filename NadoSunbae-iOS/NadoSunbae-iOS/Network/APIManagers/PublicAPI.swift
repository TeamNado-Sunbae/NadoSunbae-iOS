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
    var publicProvider = MoyaProvider<PublicService>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    /// [GET] 학과 리스트 조회  API
    func getMajorListAPI(univID: Int, filterType: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.getMajorList(univID: univID, filter: filterType)) { result in
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
    
    /// [POST] 차단/차단해제 요청
    func requestBlockUnBlockUser(blockUserID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.requestBlockUnBlockUser(blockUserID: blockUserID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.requestBlockUnBlockUserJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 신고 요청
    func requestReport(reportedTargetID: Int, reportedTargetTypeID: Int, reason: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.requestReport(reportedTargetID: reportedTargetID, reportedTargetTypeID: reportedTargetTypeID, reason: reason)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.requestReportJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [GET] 앱 링크 조회
    func getAppLink(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.getAppLink) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getAppLinkJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
}

// MARK: - JudgeData
extension PublicAPI {
    
    /// majorListJudgeData
    private func majorListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<[MajorListData]>.self, from: data) else { return .pathErr }
        
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
    
    /// requestBlockUnBlockUser
    private func requestBlockUnBlockUserJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<RequestBlockUnblockUserModel>.self, from: data) else { return .pathErr }
        
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
    
    /// requestReport
    private func requestReportJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data ?? "None-Data")
        case 401:
            return .requestErr(false)
        case 409:
            return .requestErr(409)
        case 400, 402...408:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    /// getAppLink
    private func getAppLinkJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<AppLinkResponseModel>.self, from: data) else { return .pathErr }
        
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
