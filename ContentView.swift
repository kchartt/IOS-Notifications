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
                        var notification = Notification(
                            identifier: UUID().uuidString, title: "Testing Notification",
                            body: "Hello world i'm a notification",
                            timeInterval: 10,
                            repeats: false)
                        
                        // Items that are not in the init methods on notification need to be added as so
                        notification.subtitle = "This is a notification subtitle"
//                        notification.bundleImageName = "imageName"
                        
                        // Setting a key value pair for the interaction function to check to display a certain view. 
                        notification.userInfo = ["nextView" : NextView.promo.rawValue]
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
            .sheet(item: $nManager.nextView, content: { nextView in
                //Returning the view function in a sheet
                nextView.view()
            })
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
