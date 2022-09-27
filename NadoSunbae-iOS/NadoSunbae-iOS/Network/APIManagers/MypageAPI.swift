//
//  MypageAPI.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/19.
//

import Foundation
import Moya

class MypageAPI: BaseAPI {
    static let shared = MypageAPI()
    private var provider = MoyaProvider<MypageService>(plugins: [NetworkLoggerPlugin()])
    
    private override init() {}
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
                
                let networkResult = self.judgeStatus(by: statusCode, data, MypageUserInfoModel.self)
                completion(networkResult)
                
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
                
                let networkResult = self.judgeStatus(by: statusCode, data, MypageQuestionListResponseData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 내가 쓴 글 - 1:1 질문, 커뮤니티 조회
    func getMypageMyPostList(postType: MypageMyPostType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getUserPostList(postType: postType)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, MypageMyPostListModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 내가 쓴 답글 - 질문/정보 조회
    func getMypageMyAnswerList(postType: MypageMyPostType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getMypageMyAnswerList(postType: postType)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, MypageMyAnswerListModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 내가 쓴 후기 조회
    func getMypageMyReviewList(userID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getMypageMyReviewList(userID: userID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, MypageMyReviewModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 학과후기 좋아요 목록 조회
    func getMypageMyLikeReviewListAPI(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getMypageMyLikeList(postType: MypageLikePostType.review)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, MypageLikeReviewData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 질문글, 정보글 좋아요 목록 조회
    func getMypageMyLikePostListAPI(postType: MypageLikePostType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getMypageMyLikeList(postType: postType)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, MypageLikePostData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
