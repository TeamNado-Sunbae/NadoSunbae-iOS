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
    var classroomProvider = MoyaProvider<ClassroomService>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    /// [GET] 1:1질문, 전체 질문 상세 조회 API 메서드
    func getQuestionDetailAPI(chatPostID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.getQuestionDetail(chatPostID: chatPostID)) { [self] result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(getQuestionDetaiJudgeData(status: statusCode, data: data))
                
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
    func createCommentAPI(chatID: Int, comment: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.postComment(chatPostID: chatID, comment: comment)) { result in
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
    func postClassroomLikeAPI(chatPostID: Int, postTypeID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        classroomProvider.request(.postLike(chatPostID: chatPostID, postTypeID: postTypeID)) { result in
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

}


// MARK: - JudgeData
extension ClassroomAPI {
    
    /// 1:1질문, 전체 질문 상세 조회
    private func getQuestionDetaiJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<ClassroomQuestionDetailData>.self, from: data) else {
            return .pathErr }
        
        switch status {
        case 200...204:
            return .success(decodedData.data.self as Any)
        case 400...409:
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
        case 400...409:
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
        case 400...409:
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
        case 400...409:
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
        case 400...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    /// 1:1질문, 전체 질문, 정보글에 글 등록
    private func postClassroomLikeJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<PostLike>.self, from: data) else {
            return .pathErr }
        
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
