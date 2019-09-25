//
//  AlarmController.swift
//  myAlarm
//
//  Created by Austin Goetz on 9/24/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import UserNotifications

class AlarmController: AlarmScheduler {
    
    static let sharedInstance = AlarmController()
    
    var alarms: [Alarm] = []
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool, uuid: String) {
        let newAlarm = Alarm(fireDate: fireDate, name: name, uuid: uuid)
        newAlarm.enabled = enabled
        alarms.append(newAlarm)
        
        saveToPersistentStore()
    }
    
    func updateAlarm(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        
        scheduleUserNotification(for: alarm)

        cancelUserNotification(for: alarm)
        
        saveToPersistentStore()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let indexOfAlarmToDelete = alarms.firstIndex(of: alarm) else {
            return }
        alarms.remove(at: indexOfAlarmToDelete)
        
        saveToPersistentStore()
    }
    
    func toggleEnabled(alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        
        if alarm.enabled{
            scheduleUserNotification(for: alarm)
        } else{
            cancelUserNotification(for: alarm)
        }
    }
    
        private static func fileURL() -> URL {
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = path[0]
            let fileName = "alarm.json"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            return fileURL
        }
        
        private func saveToPersistentStore() {
            
            let encoder = JSONEncoder()
            
            do {
                let data = try encoder.encode(alarms)
                try data.write(to: AlarmController.fileURL())
            } catch {
                print("Failed to Save to Persistent Store \(error) \(error.localizedDescription)")
            }
        }
        
        func loadFromPersisentStore() -> [Alarm] {
            let decoder = JSONDecoder()
            
            do {
                let data = try Data(contentsOf: AlarmController.fileURL())
                let alarms = try decoder.decode([Alarm].self, from: data)
                return alarms
            } catch {
                print("Failed to Load from Persistent Store \(error) \(error.localizedDescription)")
            }
            return []
        }
    }

    protocol AlarmScheduler: class {
        func scheduleUserNotification(for alarm: Alarm)
        func cancelUserNotification(for alarm: Alarm)
    }

    extension AlarmScheduler {

        func scheduleUserNotification(for alarm: Alarm){

            let content = UNMutableNotificationContent()
            content.title = "Time to get up"
            content.body = "Time for \(alarm.name)"
            content.sound = UNNotificationSound.default()

            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                    print("Error scheduling local user notifications \(error.localizedDescription)  :  \(error)")
                }
            }
        }

        func cancelUserNotification(for alarm: Alarm){
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
