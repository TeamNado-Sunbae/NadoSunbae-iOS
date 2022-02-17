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
    func getUserInfo(userID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getUserInfo(userID: userID)) { result in
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
    
    /// [GET] 유저에게 온 1:1 질문글 리스트 조회
    func getUserPersonalQuestionList(userID: Int, sort: ListSortType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getUserPersonalQuestionList(userID: userID, sort: sort)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getUserPersonalQuestionListJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 내가 쓴 글 - 질문/정보 조회
    func getMypageMyPostList(postType: MypageMyPostType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getMypageMyPostList(postType: postType)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getMypageMyPostListJudgeData(status: statusCode, data: data))
                
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
    
    private func getUserPersonalQuestionListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<QuestionOrInfoListModel>.self, from: data) else { return .pathErr }

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
    
    private func getMypageMyPostListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<MypageMyPostListModel>.self, from: data) else { return .pathErr }

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
