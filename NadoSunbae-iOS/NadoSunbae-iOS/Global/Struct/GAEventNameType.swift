//
//  GAEventNameType.swift
//  NadoSunbae
//
//  Created by hwangJi on 2022/11/01.
//

import Foundation

enum GAEventNameType {
    case signup_process
    case write_request_alert
    case review_process
    case community_write
    case review_read
    case question_read_1on1
    case senior_click
    case community_read
    case question_answered_1on1
    case mention_function
    case review_write
    case question_write_1on1
    case update_opt
    case user_post
    case home_viewmore
    case banner_click
    case profile_change
    case first_login
    case search_function
    case alert_opt
    case remail_button
    case like_click
    case bottomsheet_function
    case new_question_button_1on1
}

extension GAEventNameType {
    var parameterName: String {
        switch self {
        case .signup_process, .review_process, .senior_click:
            return "journey"
        case .write_request_alert, .alert_opt:
            return "choice"
        case .community_write, .question_read_1on1, .community_read, .mention_function, .review_write, .question_write_1on1, .profile_change, .remail_button:
            return "type"
        case .home_viewmore:
            return "tap"
        case .banner_click:
            return "number"
        case .user_post:
            return "post_type"
        case .like_click:
            return "like_on"
        default: return ""
        }
    }
    
    var hasParameter: Bool {
        switch self {
        case .review_read, .question_answered_1on1, .update_opt, .first_login, .search_function, .bottomsheet_function, .new_question_button_1on1:
            return false
        default: return true
        }
    }
}
