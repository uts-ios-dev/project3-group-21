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
            try db.run(jobTable.insert(name <- "ios developer",
                                       Expression<String>("salary") <- "1000/m",
                                       Expression<String>("experience") <- "3+years",
                                       Expression<String>("position") <- "software_developer",
                                       Expression<Int64>("companyId") <- 1))
            try db.run(skillTable.insert(name <- "swift"))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 1,
                                            Expression<Int64>("skillId") <- 1))
        }catch{
            print(error)
        }
    }
    
    static func testQuery()
    {
        let query = jobTable.select(id).where(Expression<String>("position") == "software_developer")
        let advancedQuery = jobTable.join(companyTable, on: Expression<Int64>("companyId") == companyTable[id])
            .where(Expression<String>("position") == "software_developer")
        for row in try! db.prepare(advancedQuery){
            print("id:\(row[jobTable[id]]), companyId: \(row[companyTable[id]])")
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

