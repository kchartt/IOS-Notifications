//
//  Notificaiton.swift
//  my-onarken-ios
//
//  Created by Kyle Chart on 05/02/2025.
//

import Foundation

///Notification base model
struct Notification {
    
    ///Notification with time intervals
    internal init(identifier: String, title: String, body: String, timeInterval: Double, repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    ///Notification with calendar data
    internal init(identifier: String, title: String, body: String, dateComponents: DateComponents, repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .calendar
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    ///Set the notification type(Time, Calendar)
    enum ScheduleType {
        case time, calendar
    }
    
    var identifier: String
    var scheduleType: ScheduleType
    var title: String
    var body: String
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
}
