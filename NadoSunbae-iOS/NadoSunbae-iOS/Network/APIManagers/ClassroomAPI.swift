//
//  ClassroomAPI.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/19.
//

import Foundation
import Moya

class ClassroomAPI: BaseAPI {
    static let shared = ClassroomAPI()
    var classroomProvider = MoyaProvider<ClassroomService>()
    
    private override init() {}
    
    /// [GET] 1:1질문, 전체 질문 상세 조회 API 메서드
    func getQuestionDetailAPI(postID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.getQuestionDetail(postID: postID)) { [self] result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ClassroomQuestionDetailData.self)

                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [GET] 정보글 상세 조회 API 메서드
    func getInfoDetailAPI(postID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.getInfoDetail(postID: postID)) { [self] result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, InfoDetailDataModel.self)

                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 1:1질문, 전체 질문, 정보글에 댓글 등록 API 메서드
    func createCommentAPI(postID: Int, comment: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.postComment(postID: postID, comment: comment)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, AddCommentData.self)

                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    /// [GET] 선택한 학과 user 구성원 목록 조회
    func getMajorUserListAPI(majorID: Int, isExclude: Bool, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.getMajorUserList(majorID: majorID, isExclude: isExclude)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, MajorUserListDataModel.self)

                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 1:1질문, 전체 질문, 정보글에 글 등록 API 메서드
    func createClassroomContentAPI(majorID: Int, answerID: Int?, postTypeID: Int, title: String, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.postClassroomContent(majorID: majorID, answerID: answerID, postTypeID: postTypeID, title: title, content: content)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, CreateClassroomPostModel.self)

                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [DELETE] 1:1질문, 전체 질문, 정보글 댓글 삭제 API 메서드
    func deletePostCommentAPI(commentID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.deletePostComment(commentID: commentID)) { result in
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
