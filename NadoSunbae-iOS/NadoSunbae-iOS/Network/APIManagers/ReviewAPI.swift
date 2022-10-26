//
//  ReviewAPI.swift
//  NadoSunbae-iOS
//
//  Created by hwangJi on 2022/01/18.
//

import Foundation
import Moya

class ReviewAPI: BaseAPI {
    static let shared = ReviewAPI()
    var userProvider = MoyaProvider<ReviewService>()
    
    private override init() {}
    
    /// [POST] 후기글 등록 API
    func createReviewPostAPI(majorID: Int, bgImgID: Int, oneLineReview: String, prosCons: String, curriculum: String, recommendLecture: String, nonRecommendLecture: String, career: String, tip: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.createReviewPost(majorID: majorID, bgImgID: bgImgID, oneLineReview: oneLineReview, prosCons: prosCons, curriculum: curriculum, recommendLecture: recommendLecture, nonRecommendLecture: nonRecommendLecture, career: career, tip: tip)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ReviewPostDetailData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [GET] 후기글 리스트 API
    func getReviewPostListAPI(majorID: Int, writerFilter: WriterType, tagFilter: String, sort: ListSortType, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.getReviewMainPostList(majorID: majorID, writerFilter: writerFilter.rawValue, tagFilter: tagFilter, sort: sort.rawValue)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, [ReviewMainPostListData].self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 후기글 상세 조회 API
    func getReviewPostDetailAPI(postID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.getReviewPostDetail(postID: postID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ReviewPostDetailData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [GET] 후기탭 홈페이지 조회 API
    func getHomePageUrlAPI(majorID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.getReviewHomepageURL(majorID: majorID) ) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ReviewHomePageData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [DELETE] 후기글 삭제 API
    func deleteReviewPostAPI(postID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.deleteReviewPost(postID: postID)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ReviewDeleteResModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    /// [PUT] 후기글 수정 API
    func editReviewPostAPI(postID: Int, bgImgID: Int, oneLineReview: String, prosCons: String, curriculum: String, recommendLecture: String, nonRecommendLecture: String, career: String, tip: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.editReviewPost(postID: postID, bgImgID: bgImgID, oneLineReview: oneLineReview, prosCons: prosCons, curriculum: curriculum, recommendLecture: recommendLecture, nonRecommendLecture: nonRecommendLecture, career: career, tip: tip)) { result in
            switch result {
                
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, ReviewEditData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err)
            }
        }
    }
}
