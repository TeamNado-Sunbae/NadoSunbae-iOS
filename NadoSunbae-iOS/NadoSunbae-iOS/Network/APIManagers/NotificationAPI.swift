//
//  NotificationAPI.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation
import Moya

class NotificationAPI {
    static let shared = NotificationAPI()
    private var provider = MoyaProvider<NotificationService>()
    
    private init() {}
}

// MARK: - API
extension NotificationAPI {
    
    /// [GET] 전체 알림 리스트 조회
    func getNotiList(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getNotiList) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                completion(self.getNotiListJudgeData(status: statusCode, data: data))

            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [PUT] 특정 알림 읽음 처리
    func readNoti(notiID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.readNoti(notiID: notiID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                completion(self.readNotiJudgeData(status: statusCode, data: data))

            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [DELETE] 특정 알림 삭제 처리
    func deleteNoti(notiID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.deleteNoti(notiID: notiID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data

                completion(self.deleteNotiJudgeData(status: statusCode, data: data))

            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

// MARK: - judgeData
extension NotificationAPI {
    private func getNotiListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<NotificationDataModel>.self, from: data) else { return .pathErr }
        
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
    
    private func readNotiJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<ReadNotificationDataModel>.self, from: data) else { return .pathErr }
        
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
    
    private func deleteNotiJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<DeleteNotificationDataModel>.self, from: data) else { return .pathErr }
        
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
