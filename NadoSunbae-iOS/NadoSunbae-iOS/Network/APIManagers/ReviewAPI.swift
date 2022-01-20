//
//  ReviewAPI.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import Foundation
import Moya

class ReviewAPI {
    static let shared = ReviewAPI()
    var userProvider = MoyaProvider<ReviewService>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    /// [POST] 후기글 등록 API
    func createReviewPostAPI(majorID: Int, bgImgID: Int, oneLineReview: String, prosCons: String, curriculum: String, career: String, recommendLecture: String, nonRecommendLecture: String, tip: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.createReviewPost(majorID: majorID, bgImgID: bgImgID, oneLineReview: oneLineReview, prosCons: prosCons, curriculum: curriculum, career: career, recommendLecture: recommendLecture, nonRecommendLecture: nonRecommendLecture, tip: tip)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.createReviewPostJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [POST] 후기글 리스트 API
    func getReviewPostListAPI(majorID: Int, writerFilter: Int, tagFilter: [Int], completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.getReviewMainPostList(majorID: majorID, writerFilter: writerFilter, tagFilter: tagFilter, sort: "recent")) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.getReviewPostListJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err)
            }
        }
    }
}

// MARK: - JudgeData
extension ReviewAPI {
    
    /// createReviewPostJudgeData
    func createReviewPostJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(GenericResponse<ReviewPostRegisterData>.self, from: data)
        
        switch status {
        case 200...204:
            return .success(decodedData?.data ?? "None-Data")
        case 400...409:
            return .requestErr(decodedData?.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
    
    /// getReviewPostListJudgeData
    func getReviewPostListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(GenericResponse<[ReviewMainPostListData]>.self, from: data)
        
        switch status {
        case 200...204:
            return .success(decodedData?.data ?? "None-Data")
        case 400...409:
            return .requestErr(decodedData?.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
 }
