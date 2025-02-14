//
//  NotificationManager.swift
//  my-onarken-ios
//
//  Created by Kyle Chart on 05/02/2025.
//

import Foundation
import NotificationCenter

@MainActor
class NotificationManager: NSObject ,ObservableObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    @Published var isGranted: Bool = false
    @Published var pendingRequests: [UNNotificationRequest] = []
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    ///Delegate Function - Presnet notifications in foreground(Whilst app is still running)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notifucation: UNNotification) async -> UNNotificationPresentationOptions {
        await getPendingRequest()
        return [.sound, .banner]
    }
    
    ///Request notification permissions
    func requestPermissions() async throws  {
        try await notificationCenter.requestAuthorization(options: [.sound, .badge, .alert])
        await getCurrentSettings()
    }
    
    ///Get current notification settings
    func getCurrentSettings() async {
        let currentSettings = await notificationCenter.notificationSettings()
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    ///Open settings to request access to push notifications
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                   await UIApplication.shared.open(url)
                }
            }
        }
    }
    
    ///Setting the paramanets for the notification message.
    func schedule(notification: Notification) async {
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = .default
        
        if notification.scheduleType == .time {
            guard let timeInterval = notification.timeInterval else { return }
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval , repeats: notification.repeats)
            let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        } else {
            guard let dateComponents = notification.dateComponents else { return }
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: notification.repeats)
            let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)
            try? await notificationCenter.add(request)
        }
        await getPendingRequest()
    }
    
    ///Gets the pending requests array when ever a new notification request is present
    func getPendingRequest() async {
        pendingRequests = await notificationCenter.pendingNotificationRequests()
    }
    
    ///Remove pending notification requests
    func removePending(withIntentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        if let index = pendingRequests.firstIndex(where: {$0.identifier == identifier}) {
            pendingRequests.remove(at: index)
        }
    }
    
    ///Clear all pending notification requests
    func clearRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
        pendingRequests.removeAll()
    }
}
