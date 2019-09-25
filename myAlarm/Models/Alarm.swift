//
//  Alarm.swift
//  myAlarm
//
//  Created by Austin Goetz on 9/24/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var fireDate: Date
    var name: String
    var enabled: Bool
    let uuid: String
    
    var fireTimeAsString: String {
        let newDateFormatter = DateFormatter()
        newDateFormatter.dateStyle = .medium
        return newDateFormatter.string(from: fireDate)
    }
    
    init(fireDate: Date, name: String, enabled: Bool = true, uuid: String) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = uuid
    }
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.fireDate == rhs.fireDate && lhs.name == rhs.name && lhs.enabled == rhs.enabled && lhs.uuid == rhs.uuid
    }
}
