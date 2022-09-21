//
//  HomeAPI.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/09/20.
//

import Foundation
import Moya

class HomeAPI: BaseAPI {
    static let shared = HomeAPI()
    private var provider = MoyaProvider<HomeService>()
    
    private override init() {}
}

extension HomeAPI {
    
    /// [GET] 배너 리스트 조회
    func getBannerList(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getBannerList) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, GetBannerListResponseData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 학교 후기 전체 최신순 조회
    func getAllReviewList(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getAllReviewList) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, HomeRecentReviewResponseData.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}
