//
//  String+.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

extension String {
    
    /// String을 UIImage로 반환하는 메서드
    func makeImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
    
    /// 서버에서 들어온 Date String을 Date 타입으로 반환하는 메서드
    private func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "KST")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("toDate() convert error")
            return Date()
        }
    }
    
    /// serverTimeToString의 용도 정의
    enum TimeStringCase {
        case forNotification
        case forDefault
    }
    
    /// 서버에서 들어온 Date String을 UI에 적용 가능한 String 타입으로 반환하는 메서드
    func serverTimeToString(forUse: TimeStringCase) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd"
        
        let currentTime = Int(Date().timeIntervalSince1970)
        
        switch forUse {
        case .forNotification:
            let getTime = self.toDate().timeIntervalSince1970
            let displaySec = currentTime - Int(getTime)
            let displayMin = displaySec / 60
            let displayHour = displayMin / 60
            let displayDay = displayHour / 24
            
            if displayDay >= 1 {
                return dateFormatter.string(from: self.toDate())
            } else if displayHour >= 1 {
                return "\(displayHour)시간 전"
            } else if displayMin >= 1 {
                return "\(displayMin)분 전"
            } else {
                return "1분 전"
            }
        case .forDefault:
            return dateFormatter.string(from: self.toDate())
        }
    }
    
    /// 전공정보 String으로 반환하는 함수
    func convertToMajorInfoString(_ firstMajorName: String, _ firstMajorStart: String, _ secondMajorName: String, _ secondMajorStart: String) -> String {
        if secondMajorName == "미진입" {
            return firstMajorName + " " + firstMajorStart + " " + "|" + " " + secondMajorName
        } else {
            return firstMajorName + " " + firstMajorStart + " " + "|" + " " + secondMajorName + " " + secondMajorStart
        }
    }
    
    /// 닉네임 + 전공정보 String으로 반환하는 함수
    func convertToUserInfoString(_ nickname: String, _ firstMajorName: String, _ firstMajorStart: String, _ secondMajorName: String, _ secondMajorStart: String) -> String {
        if secondMajorName == "미진입" {
            return nickname + "   " + firstMajorName + " " + firstMajorStart + "  |  " + secondMajorName
        } else {
            /// 닉네임 + 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 32자 넘을 때 (닉네임 텍스트 크기 고려)
            if (nickname.count + firstMajorName.count + firstMajorStart.count + secondMajorName.count + secondMajorStart.count) > 30 {
                
                if screenWidth == 375 {
                    /// 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 35자 넘을 때
                    if (firstMajorName.count + firstMajorStart.count + secondMajorName.count + secondMajorStart.count) > 35 {
                        return nickname + "\n" + firstMajorName + " " + firstMajorStart + "  |\n" + secondMajorName + " " + secondMajorStart
                    } else {
                        /// 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 35자 넘지 않을 때
                        return nickname + "\n" + firstMajorName + " " + firstMajorStart + "  |  " + secondMajorName + " " + secondMajorStart
                    }
                } else {
                    /// 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 37자 넘을 때
                    if (firstMajorName.count + firstMajorStart.count + secondMajorName.count + secondMajorStart.count) > 37 {
                        return nickname + "\n" + firstMajorName + " " + firstMajorStart + "  |\n" + secondMajorName + " " + secondMajorStart
                    } else {
                        /// 본전공명 + 본전공진입시기 + 제2전공 + 제2전공진입시기 글자수 37자 넘지 않을 때
                        return nickname + "\n" + firstMajorName + " " + firstMajorStart + "  |  " + secondMajorName + " " + secondMajorStart
                    }
                }
            } else {
                return nickname + "   " + firstMajorName + " " + firstMajorStart + "  |  " + secondMajorName + " " + secondMajorStart
            }
        }
    }
}
