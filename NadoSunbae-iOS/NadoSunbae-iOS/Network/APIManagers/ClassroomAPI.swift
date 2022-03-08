//
//  ClassroomAPI.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/19.
//

import Foundation
import Moya

class ClassroomAPI {
    static let shared = ClassroomAPI()
    var classroomProvider = MoyaProvider<ClassroomService>()
    
    private init() {}
    
    /// [GET] 1:1질문, 전체 질문 상세 조회 API 메서드
    func getQuestionDetailAPI(postID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.getQuestionDetail(postID: postID)) { [self] result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(getQuestionDetailJudgeData(status: statusCode, data: data))
                
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
                
                completion(getInfoDetailJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [GET] 전체 질문, 정보글 전체 목록 조회 및 정렬 API 메서드
    func getGroupQuestionOrInfoListAPI(majorID: Int, postTypeID: Int, sort: ListSortType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.getGroupQuestionOrInfoList(majorID: majorID, postTypeID: postTypeID, sort: sort)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getGroupQuestionOrInfoListJudgeData(status: statusCode, data: data))
                
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
                
                completion(self.createCommentJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    /// [GET] 선택한 학과 user 구성원 목록 조회
    func getMajorUserListAPI(majorID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.getMajorUserList(majorID: majorID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getMajorUserListJudgeData(status: statusCode, data: data))
                
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
                
                completion(self.createClassroomPostJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 1:1질문, 전체 질문, 정보글에 좋아요 다는 API 메서드
    func postClassroomLikeAPI(postID: Int, postTypeID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.likePost(postID: postID, postTypeID: postTypeID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.postClassroomLikeJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }

    /// [PUT] 1:1질문, 전체 질문, 정보글 질문 수정 API 메서드
    func editPostQuestionAPI(postID: Int, title: String, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.editPostQuestion(postID: postID, title: title, content: content)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.editPostQuestionJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [PUT] 1:1질문, 전체 질문, 정보글 댓글 수정 API 메서드
    func editPostCommentAPI(commentID: Int, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.editPostComment(commentID: commentID, content: content)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.editPostCommentJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [DELETE] 1:1질문, 전체 질문, 정보글 질문 삭제 API 메서드
    func deletePostQuestionAPI(postID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.deletePostQuestion(postID: postID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.deletePostJudgeData(status: statusCode, data: data))
                
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
                
                completion(self.deletePostJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
}


// MARK: - JudgeData
extension ClassroomAPI {
    
    /// 1:1질문, 전체 질문 상세 조회
    private func getQuestionDetailJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<ClassroomQuestionDetailData>.self, from: data) else {
            return .pathErr }
        
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
    
    /// 정보글 상세 조회
    private func getInfoDetailJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<InfoDetailDataModel>.self, from: data) else {
            return .pathErr }
        
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
    
    /// 전체 질문, 정보글 전체 목록 조회 및 정렬
    private func getGroupQuestionOrInfoListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<[ClassroomPostList]>.self, from: data) else {
            return .pathErr }
        
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
    
    /// 1:1질문, 전체 질문, 정보글에 댓글 등록
    private func createCommentJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<AddCommentData>.self, from: data) else {
            return .pathErr }
        
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
    
    
    /// 선택한 학과 user 구성원 목록 조회
    private func getMajorUserListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<MajorUserListDataModel>.self, from: data) else {
            return .pathErr }
        
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
    
    /// 1:1질문, 전체 질문, 정보글에 글 등록
    private func createClassroomPostJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<CreateClassroomPostModel>.self, from: data) else {
            return .pathErr }
        
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
    
    /// 좋아요 요청
    private func postClassroomLikeJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<PostLikeResModel>.self, from: data) else {
            return .pathErr }
        
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
    
    /// 질문글 수정
    private func editPostQuestionJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<EditPostQuestionModel>.self, from: data) else {
            return .pathErr }
        
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
    
    /// 댓글 수정
    private func editPostCommentJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<EditPostCommentModel>.self, from: data) else {
            return .pathErr }
        
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
    
    /// 질문, 댓글 삭제
    private func deletePostJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<String>.self, from: data) else {
            return .pathErr }
        
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
}
