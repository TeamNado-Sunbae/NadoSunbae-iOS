//
//  AppDelegate.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit
import Firebase
import FirebaseAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        // MARK: Firebase 초기화
        FirebaseApp.configure()
        
        /// 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        /// 자동 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true
        
        
        /// 현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                UserDefaults.standard.set(token, forKey: UserDefaults.Keys.FCMTokenForDevice)
            }
        }
        
        FirebaseAnalytics.Analytics.logEvent("user_active", parameters: [
            "UserID": UserDefaults.standard.integer(forKey: UserDefaults.Keys.UserID),
            "FirstMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.FirstMajorName) ?? "",
            "SecondMajor": UserDefaults.standard.string(forKey: UserDefaults.Keys.SecondMajorName) ?? ""
        ])
        
        #if DEVELOPMENT || QA
        Analytics.setAnalyticsCollectionEnabled(false)
        #endif
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /// APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("apn Token setting", "called")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// APN 토큰과 등록 토큰 매핑 실패
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APN 토큰 등록 실패", "fail")
    }
    
    /// 디바이스 세로방향으로 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    /// 토큰 갱신 모니터링 메서드
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        UserDefaults.standard.set(fcmToken, forKey: UserDefaults.Keys.FCMTokenForDevice)
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// foreGround에 푸시알림이 올 때 실행되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .list, .banner])
    }
    
    /// 푸시알림을 클릭했을 때 실행되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        NotificationCenter.default.post(name: Notification.Name.pushNotificationClicked, object: nil)
        NotificationInfo.shared.isPushComes = true
        completionHandler()
    }
}
