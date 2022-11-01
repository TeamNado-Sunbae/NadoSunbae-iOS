//
//  PublicAPI.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/19.
//

import Foundation
import Moya

class PublicAPI: BaseAPI {
    static let shared = PublicAPI()
    var publicProvider = MoyaProvider<PublicService>()
    
    private override init() {}
    
    /// [GET] 학과 리스트 조회  API
    func getMajorListAPI(univID: Int, filterType: String, userID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.getMajorList(univID: univID, filter: filterType, userID: userID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, [MajorInfoModel].self)

                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 즐겨찾기 학과 등록 및 취소 API
    func registerFavoriteMajorAPI(majorID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.registerFavoriteMajor(majorID: majorID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, FavoriteMajorPostResModel.self)

                completion(networkResult)
                
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
                let networkResult = self.judgeStatus(by: statusCode, data, RequestBlockUnblockUserModel.self)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 신고 요청
    func requestReport(reportedTargetID: Int, postType: ReportPostType, reason: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.requestReport(reportedTargetID: reportedTargetID, postType: postType, reason: reason)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, String.self)
                
                completion(networkResult)
                
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
                let networkResult = self.judgeStatus(by: statusCode, data, AppLinkResponseModel.self)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [GET] 전체 게시글 리스트 조회 - 커뮤니티, 1:1 질문 전체 글 리스트
    func getPostList(univID: Int, majorID: Int, filter: PostFilterType, sort: String, search: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.getPostList(univID: univID, majorID: majorID, filter: filter, sort: sort, search: search)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, [PostListResModel].self)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [GET] 게시글 상세 조회 - 커뮤니티(전체, 자유, 질문, 정보), 1:1 질문 글 상세보기
    func getPostDetail(postID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.getPostDetail(postID: postID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, PostDetailResModel.self)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 게시글 작성
    func requestWritePost(type: PostFilterType, majorID: Int, answererID: Int, title: String, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.requestWritePost(type: type, majorID: majorID, answererID: answererID, title: title, content: content)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, WritePostResModel.self)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 후기글, 1:1 질문글, 커뮤니티글에 좋아요/좋아요취소 요청하는 API 메서드
    func postLikeAPI(postID: Int, postType: RequestLikePostType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.likePost(postID: postID, postType: postType)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, PostLikeResModel.self)

                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [PUT] 게시글 수정 API 메서드
    func editPostAPI(postID: Int, title: String, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.editPost(postID: postID, title: title, content: content)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, EditPostQuestionModel.self)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [PUT] 댓글 수정 API 메서드
    func editPostCommentAPI(commentID: Int, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.editPostComment(commentID: commentID, content: content)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, EditPostCommentModel.self)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [DELETE] 게시글 삭제 API 메서드
    func deletePostAPI(postID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        publicProvider.request(.deletePost(postID: postID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, String.self)
                
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
}
