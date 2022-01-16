//
//  AppDelegate.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Firebase 초기화
        FirebaseApp.configure()
        
        // APN에 토큰 매핑하는 프로세스
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
        UNUserNotificationCenter.current().delegate = self
        
        setUpRemoteNotification()
        setUpMessagingDelegate()
        
        // 자동 초기화 방지
        Messaging.messaging().isAutoInitEnabled = true
        
        // 현재 등록 토큰 가져오기
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                /// 여기 프린트는 나중에 서버에 넘겨줄 token인데 알림 받고싶으면 콘솔에 찍힌 token값 저한테 알려주세용
                print("FCM registration token: \(token)")
                UserDefaults.standard.set(token, forKey: UserDefaults.Keys.FCMTokenForDevice)
            }
        }
        
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
    
    // APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
}

// MARK - FCM Setting

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// 토큰 갱신 모니터링
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.set(fcmToken, forKey: UserDefaults.Keys.FCMTokenForDevice)
    }
}
extension AppDelegate: MessagingDelegate {
    
    /// 원격 알림 등록
    private func setUpRemoteNotification() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
    }
    
    /// 메시지 대리자 설정
    private func setUpMessagingDelegate() {
        Messaging.messaging().delegate = self
    }
    
    /// foreGround에서 실행 중일 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .badge, .sound])
    }
    
    /// backGround에서 실행 중일 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,didReceive response: UNNotificationResponse,withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
