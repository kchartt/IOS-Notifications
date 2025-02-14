//
//  ContentView.swift
//  my-onarken-ios
//
//  Created by Kyle Chart on 10/01/2025.
//

import SwiftUI
import SwiftData
import SwiftUI

struct ContentView: View {
    
    @State var alert: Bool = false
    @State var message: String = ""
    
    @EnvironmentObject var nManager: NotificationManager
    @Environment(\.scenePhase) var scenePhase
    
    @State var date: Date = Date.now
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                if nManager.isGranted {
                    Text("Permission Granted")
                } else {
                    Text("No Permission")
                    Button("Ask Perission") {
                        Task {
                            try await nManager.requestPermissions()
                        }
                    }
                    Button("Settings") {
                        nManager.openSettings()
                    }
                }
                GroupBox {
                    DatePicker("", selection: $date)
                }
                Button("Send Notification") {
                    Task {
                        let notification = Notification(
                            identifier: UUID().uuidString, title: "Testing Notification",
                            body: "Hello world i'm a notification",
                            timeInterval: 10,
                            repeats: false)
                        
                        await nManager.schedule(notification: notification)
                    }
                }
                Button("Calendar Notification") {
                    Task {
                        let dateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date)
                        let notification = Notification(identifier: UUID().uuidString, title: "Calendar", body: "I am a notification on the calendar", dateComponents: dateComponents, repeats: false)
                        await nManager.schedule(notification: notification)
                    }
                }
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                Task {
                    await nManager.getCurrentSettings()
                    await nManager.getPendingRequest()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
