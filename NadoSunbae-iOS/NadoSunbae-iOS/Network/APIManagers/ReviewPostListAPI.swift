//
//  ReviewPostListAPI.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/20.
//

import Foundation
import Moya

class ReviewPostListAPI {
    static let shared = ReviewPostListAPI()
    var userProvider = MoyaProvider<ReviewMainPostListService>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    /// [POST] 후기글 리스트 API
    func getReviewPostListAPI(majorID: Int, writerFilter: Int, tagFilter: [Int], completion: @escaping (NetworkResult<Any>) -> (Void)) {
        userProvider.request(.getReviewMainPostList(majorID: majorID, writerFilter: writerFilter, tagFilter: tagFilter)) { result in
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
extension ReviewPostListAPI {
    
    /// getReviewPostListJudgeData
    func getReviewPostListJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(GenericResponse<ReviewMainPostListData>.self, from: data)
        
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
