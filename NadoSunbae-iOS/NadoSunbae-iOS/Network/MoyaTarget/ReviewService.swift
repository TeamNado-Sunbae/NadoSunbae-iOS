//
//  ReviewService.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/06.
//

import Foundation
import Moya

enum ReviewService {
    case createReviewPost(majorID: Int, bgImgID: Int, oneLineReview: String, prosCons: String, curriculum: String, career: String, recommendLecture: String, nonRecommendLecture: String, tip: String)
    case getReviewMainPostList(majorID: Int, writerFilter: String, tagFilter: String, sort: String)
    case getReviewPostDetail(postID: Int)
    case getReviewHomepageURL(majorID: Int)
    case deleteReviewPost(postID: Int)
    case editReviewPost(postID: Int, bgImgID: Int, oneLineReview: String, prosCons: String, curriculum: String, career: String, recommendLecture: String, nonRecommendLecture: String, tip: String)
}

extension ReviewService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .createReviewPost:
            return "/review-post"
        case .getReviewMainPostList(let majorID, _, _, _):
            return "/review/major/\(majorID)"
        case .getReviewPostDetail(let postID), .deleteReviewPost(let postID):
            return "review/\(postID)"
        case .getReviewHomepageURL(let majorID):
            return "/major/\(majorID)"
        case .editReviewPost(let postID, _, _, _, _, _, _, _, _ ):
            return "/review-post/\(postID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .createReviewPost:
            return .post
        case .getReviewMainPostList, .getReviewPostDetail, .getReviewHomepageURL:
            return .get
        case .deleteReviewPost:
            return .delete
        case .editReviewPost:
            return .put
        }
    }
    
    var task: Task {
        switch self {
            
        /// 후기글 작성 경우
        case .createReviewPost(let majorID, let bgImgID, let oneLineReview, let prosCons, let curriculum, let career, let recommendLecture, let nonRecommendLecture, let tip):
            let body: [String : Any] = [
                "majorId" : majorID,
                "backgroundImageId" : bgImgID,
                "oneLineReview" : oneLineReview,
                "prosCons" : prosCons,
                "curriculum" : curriculum,
                "career" : career,
                "recommendLecture" : recommendLecture,
                "nonRecommendLecture" : nonRecommendLecture,
                "tip" : tip
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
        
        /// 후기글 수정 경우
        case .editReviewPost( _, let bgImgID, let oneLineReview, let prosCons, let curriculum, let career, let recommendLecture, let nonRecommendLecture, let tip):
            let body: [String : Any] = [
                "backgroundImageId" : bgImgID,
                "oneLineReview" : oneLineReview,
                "prosCons" : prosCons,
                "curriculum" : curriculum,
                "career" : career,
                "recommendLecture" : recommendLecture,
                "nonRecommendLecture" : nonRecommendLecture,
                "tip" : tip
            ]
            return .requestParameters(parameters: body, encoding: JSONEncoding.prettyPrinted)
            
        /// 후기 메인 뷰에서 리스트를 요청하는 경우
        case .getReviewMainPostList(_, let writerFilter, let tagFilter, let sort):
            let query: [String: Any] = [
                "writerFilter": writerFilter,
                "tagFilter": tagFilter,
                "sort": sort
            ]
            
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
            
        case .getReviewPostDetail, .getReviewHomepageURL, .deleteReviewPost:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let accessToken = UserToken.shared.accessToken ?? ""
        switch self {
            
        case .createReviewPost, .getReviewMainPostList, .getReviewPostDetail, .getReviewHomepageURL, .deleteReviewPost, .editReviewPost:
            return ["accesstoken" : accessToken]
        }
    }
}
