//
//  NotificationAPI.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation
import Moya

class NotificationAPI: BaseAPI {
    static let shared = NotificationAPI()
    private var provider = MoyaProvider<NotificationService>()
    
    private override init() {}
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
                
                let networkResult = self.judgeStatus(by: statusCode, data, GetNotiListResponseData.self)
                completion(networkResult)

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

                let networkResult = self.judgeStatus(by: statusCode, data, ReadNotificationDataModel.self)
                completion(networkResult)

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
                
                let networkResult = self.judgeStatus(by: statusCode, data, DeleteNotificationDataModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
