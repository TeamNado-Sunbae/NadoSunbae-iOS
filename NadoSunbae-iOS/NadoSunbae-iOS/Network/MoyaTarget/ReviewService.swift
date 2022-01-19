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
}

extension ReviewService: TargetType {
    var baseURL: URL {
        return URL(string: APIConstants.baseURL)!
    }
    
    var path: String {
        switch self {
            
        case .createReviewPost:
            return "/review-post"
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .createReviewPost:
            return .post
        }
    }
    
    var task: Task {
        switch self {
            
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
        }
    }
    
    var headers: [String : String]? {
        let accessToken: String = UserDefaults.standard.string(forKey: UserDefaults.Keys.AccessToken) ?? ""
        print(accessToken)
        
        switch self {
            
        case .createReviewPost:
            return ["accesstoken" : accessToken]
        }
    }
}
