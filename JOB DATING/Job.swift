//
//  Job.swift
//  JOB DATING
//
//  Created by Dat Tran on 29/5/18.
//  Copyright © 2018 iOS-21. All rights reserved.
//

import Foundation

class Job {
    var name = ""
    var matched : Int64 = 0
    var salary : Int64 = 0
    var location = ""
    var jobId:Int64 = 0
    
    init(jobId:Int64, name: String, matched: Int64, salary: Int64, location: String) {
        self.name = name
        self.matched = matched
        self.salary = salary
        self.location = location
        self.jobId = jobId
    }
    
}
