//
//  newDb.swift
//  JOB DATING
//
//  Created by Master_Cloud on 26/5/18.
//  Copyright © 2018 iOS-21. All rights reserved.
//

import Foundation
import SQLite
class dbConfiguration
{
    static var db: Connection!
    static let jobTable = Table("job")
    static let companyTable = Table("company")
    static let skillTable = Table("skill")
    static let comJobTable = Table("comJobTable")
    static let jobSkillTable = Table("jobSkillTable")
    static let id = Expression<Int64>("id")
    static let name = Expression<String>("name")
    
    static func buildDB()
    {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("job").appendingPathExtension("sqlite3")
            self.db = try Connection(fileUrl.path)
        } catch {
            print (error)
        }
    }
    
    static func createCompanyTable()
    {
        let tableCreate = companyTable.create { (t) in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(Expression<String>("address"))
            t.column(Expression<Int64>("phone"))
            t.column(Expression<String>("email"), check: Expression<String>("email").like("%@%"))
        }
        do {
            try db.run(tableCreate)
        }catch{
            print(error)
        }
    }
    
    static func createJobTable()
    {
        let tableCreate = jobTable.create { (t) in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(Expression<String>("salary"))
            t.column(Expression<String>("experience"))
            t.column(Expression<String>("position"))
            t.column(Expression<Int64>("companyId"), references: companyTable, id)
        }
        do {
            try db.run(tableCreate)
        }catch{
            print(error)
        }
    }
    
    static func createSkillTable()
    {
        let tableCreate = skillTable.create { (t) in
            t.column(id, primaryKey: true)
            t.column(name)
        }
        do {
            try db.run(tableCreate)
        }catch{
            print(error)
        }
    }
    
    static func createJobSkillTable()
    {
        let tableCreate = jobSkillTable.create { (t) in
            t.column(Expression<Int64>("jobId"), references: jobTable, id)
            t.column(Expression<Int64>("skillId"), references: skillTable, id)
            t.primaryKey(Expression<Int64>("jobId"),Expression<Int64>("skillId"))
        }
        do {
            try db.run(tableCreate)
        }catch{
            print(error)
        }
    }
    
    static func addData()
    {
        do {
            try db.run(companyTable.insert(name <- "test_company_1",
                                           Expression<String>("address") <- "test1 street",
                                           Expression<String>("email") <- "test@1.com",
                                           Expression<Int64>("phone") <- 123456
                                           ))
        
            try db.run(companyTable.insert(name <- "test_company_2",
                                           Expression<String>("address") <- "test2 street",
                                           Expression<String>("email") <- "test@2.com",
                                           Expression<Int64>("phone") <- 1234567
            ))
            try db.run(companyTable.insert(name <- "test_company_3",
                                           Expression<String>("address") <- "test3 street",
                                           Expression<String>("email") <- "test@3.com",
                                           Expression<Int64>("phone") <- 123678
            ))
            
            try db.run(jobTable.insert(name <- "IOS Developer",
                                       Expression<String>("salary") <- "7000/m",
                                       Expression<String>("experience") <- "3+years",
                                       Expression<String>("position") <- "Software Developer",
                                       Expression<Int64>("companyId") <- 1))
            try db.run(jobTable.insert(name <- "Android Developer",
                                       Expression<String>("salary") <- "5000/m",
                                       Expression<String>("experience") <- "3+years",
                                       Expression<String>("position") <- "Software Developer",
                                       Expression<Int64>("companyId") <- 1))
            try db.run(jobTable.insert(name <- "Android Developer",
                                       Expression<String>("salary") <- "5500/m",
                                       Expression<String>("experience") <- "5+years",
                                       Expression<String>("position") <- "Software Developer",
                                       Expression<Int64>("companyId") <- 2))
            try db.run(jobTable.insert(name <- "IT Support",
                                       Expression<String>("salary") <- "5500/m",
                                       Expression<String>("experience") <- "5+years",
                                       Expression<String>("position") <- "IT Engineer",
                                       Expression<Int64>("companyId") <- 3))
            
            try db.run(skillTable.insert(name <- "Swift"))
            try db.run(skillTable.insert(name <- "C++"))
            try db.run(skillTable.insert(name <- "Object Oriented Design"))
            try db.run(skillTable.insert(name <- "Java"))
            try db.run(skillTable.insert(name <- "C#"))
            try db.run(skillTable.insert(name <- ".Net"))
            try db.run(skillTable.insert(name <- "Windows Server"))
            try db.run(skillTable.insert(name <- "VNWare"))
            try db.run(skillTable.insert(name <- "Networking"))
            
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 1,
                                            Expression<Int64>("skillId") <- 1))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 1,
                                            Expression<Int64>("skillId") <- 2))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 1,
                                            Expression<Int64>("skillId") <- 3))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 2,
                                            Expression<Int64>("skillId") <- 3))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 2,
                                            Expression<Int64>("skillId") <- 4))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 2,
                                            Expression<Int64>("skillId") <- 5))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 3,
                                            Expression<Int64>("skillId") <- 3))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 3,
                                            Expression<Int64>("skillId") <- 5))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 3,
                                            Expression<Int64>("skillId") <- 6))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 4,
                                            Expression<Int64>("skillId") <- 7))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 4,
                                            Expression<Int64>("skillId") <- 8))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 4,
                                            Expression<Int64>("skillId") <- 9))
            
        }catch{
            print(error)
        }
    }
    
    static func testQuery()
    {

//let query = jobTable.select(id).where(Expression<String>("position") == "software_developer")
//        let cdelete = companyTable.delete()
//        try! db.run(cdelete)
//        let jdelete = jobTable.delete()
//        try! db.run(jdelete)
//        let sdelete = skillTable.delete()
//        try! db.run(sdelete)
//        let jkdelete = jobSkillTable.delete()
//        try! db.run(jkdelete)

//        let update = jobTable.filter(Expression<String>("position") == "Adriod Developer").update(Expression<String>("position") <- "Adroid Developer")
//        try!db.run(update)
        let jobs = try! db.prepare(jobTable)
        for job in jobs {
            
            print("JobId: \(job[id]), JobName: \(job[name]), JobPosition: \(job[Expression<String>("position")]), CompanyID: \(job[Expression<Int64>("companyId")])")
        }
        let skills = try! db.prepare(skillTable)
        for skill in skills {
            
            print("SkillId: \(skill[id]), SkillName: \(skill[name])")
        }
        let companies = try! db.prepare(companyTable)
        for company in companies {
            print("companyId: \(company[id]), companyName: \(company[name])")
        }
        let joins = try! db.prepare(jobSkillTable)
        for join in joins {
            
            print("JobId: \(join[Expression<Int64>("jobId")]), SkillId: \(join[Expression<Int64>("skillId")])")
        }
        
        let advancedQuery = jobTable.join(companyTable, on: Expression<Int64>("companyId") == companyTable[id])
            .where(Expression<String>("position") == "software_developer")
        for row in try! db.prepare(advancedQuery){
            print("JobId:\(row[jobTable[id]]), JobName: \(row[jobTable[name]]), companyId: \(row[companyTable[id]]), companyName: \(row[companyTable[name]])")
        }
       
        
    }
    
    static func createTables()
    {
        createCompanyTable()
        createJobTable()
        createSkillTable()
        createJobSkillTable()
    }
    
}

