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
    case getReviewMainPostList(majorID: Int, writerFilter: Int, tagFilter:[Int], sort: String)
    case getReviewPostDetail(postID: Int)
}

extension ReviewService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .createReviewPost:
            return "/review-post"
        case .getReviewMainPostList:
            return "/review-post/list"
        case .getReviewPostDetail(let postID):
            return "/review-post/\(postID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .createReviewPost:
            return .post
        case .getReviewMainPostList:
            return .post
        case .getReviewPostDetail:
            return .get
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
            return .requestParameters(parameters: body, encoding: URLEncoding.httpBody)
            
        /// 후기 메인 뷰에서 리스트를 요청하는 경우
        case .getReviewMainPostList(let majorID, let writerFilter, let tagFilter, let sort):
            let body: [String : Any] = [
                "majorId" : majorID,
                "writerFilter" : writerFilter,
                "tagFilter" : tagFilter
            ]
            
            let query = [ "sort" : sort ]
            
            // 배열값([Int])을 보낼 때는 JSONEncoding.prettyPrinted 사용해야함
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: JSONEncoding.prettyPrinted, urlParameters: query)
            
        case .getReviewPostDetail:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let accessToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken) ?? ""
        print(accessToken)
        
        switch self {
            
        case .createReviewPost, .getReviewMainPostList, .getReviewPostDetail:
            return ["accesstoken" : accessToken]
        }
    }
}
