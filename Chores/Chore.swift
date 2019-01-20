//
//  Chore.swift
//  Chores
//
//  Created by Jason Ellul on 2019-01-19.
//  Copyright © 2019 Jason Ellul. All rights reserved.
//

import Foundation
import Firebase

struct Chore {
    
    // name of the person who did the Chore
    let name: String
    // 0 for garbage, 1 for recyling
    let type: Int
    // time the chore was done
    let time: Int64
    // device token
    let fcmToken: String
    
    // Initializer for instantiating a new Chore in code
    init(name: String, type: Int, time: Int64, fcmToken: String) {
        self.name = name
        self.type = type
        self.time = time
        self.fcmToken = fcmToken
    }
    
}
