//
//  SignAPI.swift
//  NadoSunbae-iOS
//
//  Created by 1v1 on 2022/01/20.
//

import Foundation
import Moya

class SignAPI: BaseAPI {
    static let shared = SignAPI()
    private var provider = MoyaProvider<SignService>()
    
    override private init() {}
}

// MARK: - API
extension SignAPI {
    
    /// [POST] 로그인 요청
    func requestSignIn(email: String, PW: String, deviceToken: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestSignIn(email: email, PW: PW, deviceToken: deviceToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                completion(self.signInJudgeData(status: statusCode, data: data))
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 회원가입 요청
    func requestSignUp(userData: SignUpBodyModel, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestSignUp(userData: userData)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, SignUpDataModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 닉네임 중복 확인 요청
    func checkNickNameDuplicate(nickName: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.checkNickNameDuplicate(nickName: nickName)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, String.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 이메일 중복 확인 요청
    func checkEmailDuplicate(email: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.checkEmailDuplicate(email: email)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, String.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 로그아웃 요청
    func requestSignOut(completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestSignOut) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, SignOutResponseModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 회원탈퇴 요청
    func requestWithDraw(PW: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.requestWithDraw(PW: PW)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, WithDrawResponseModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 회원가입 이메일 재전송 요청
    func resendSignUpMail(email: String, PW: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.resendSignUpMail(email: email, PW: PW)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, ResendSignUpMailResponseModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [POST] 토큰 갱신, 자동로그인
    func updateToken(refreshToken: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.updateToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, SignInDataModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    /// [GET] 학교 이메일 도메인 조회
    func getUnivEmailDomain(univID: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
        provider.request(.getUnivEmailDomain(univID: univID)) { result in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data, UnivEmailDomainDataModel.self)
                completion(networkResult)
                
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}


// MARK: - judgeData
extension SignAPI {
    private func signInJudgeData(status: Int, data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(GenericResponse<SignInDataModel>.self, from: data) else { return .pathErr }
        
        switch status {
        case 200, 201, 203, 204:
            return .success(decodedData.data ?? "None-Data")
        case 202:
            return .requestErr(false)
        case 400...409:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
