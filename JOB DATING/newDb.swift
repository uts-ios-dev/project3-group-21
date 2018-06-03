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
    static var db = try! Connection()
    static let jobTable = Table("job")
    static let companyTable = Table("company")
    static let userTable = Table("user")
    static let skillTable = Table("skill")
    static let jobSkillTable = Table("jobSkillTable")
    static let id = Expression<Int64>("id")
    static let name = Expression<String>("name")
    
    static func createUserTable()
    {
        let tableCreate = userTable.create { (t) in
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
            t.column(Expression<Int64>("salary"))
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
            try db.run(userTable.insert(name <- "Md Alam",
                                           Expression<String>("address") <- "50 Marion street, Bankstown, Sydney",
                                           Expression<String>("email") <- "gollaboss@gmail.com",
                                           Expression<Int64>("phone") <- 61420447970
            ))
            try db.run(userTable.insert(name <- "Danny Tran",
                                        Expression<String>("address") <- "47 Marion street, Bankstown, Sydney",
                                        Expression<String>("email") <- "dannytranit@gmail.com",
                                        Expression<Int64>("phone") <- 61420419499
            ))
            try db.run(companyTable.insert(name <- "test_company_1",
                                           Expression<String>("address") <- "100 Wattle street, Broadway, Sydney",
                                           Expression<String>("email") <- "test@1.com",
                                           Expression<Int64>("phone") <- 123456
                                           ))
        
            try db.run(companyTable.insert(name <- "test_company_2",
                                           Expression<String>("address") <- "12/457 Goerges Avenue, Black Hights, Canberra",
                                           Expression<String>("email") <- "test@2.com",
                                           Expression<Int64>("phone") <- 1234567
            ))
            try db.run(companyTable.insert(name <- "test_company_3",
                                           Expression<String>("address") <- "1134 / 2 Middle Lane, Randton, New Castle",
                                           Expression<String>("email") <- "test@3.com",
                                           Expression<Int64>("phone") <- 123678
            ))
            try db.run(companyTable.insert(name <- "Logistic Organization",
                                           Expression<String>("address") <- "1055c / 10 Lee Street, Perth",
                                           Expression<String>("email") <- "test@4.com",
                                           Expression<Int64>("phone") <- 128678
            ))
            
            try db.run(jobTable.insert(name <- "IOS Developer",
                                       Expression<Int64>("salary") <- 100000,
                                       Expression<String>("experience") <- "3+years",
                                       Expression<String>("position") <- "Software Developer",
                                       Expression<Int64>("companyId") <- 1))
            try db.run(jobTable.insert(name <- "Android Developer",
                                       Expression<Int64>("salary") <- 95400,
                                       Expression<String>("experience") <- "3+years",
                                       Expression<String>("position") <- "Software Developer",
                                       Expression<Int64>("companyId") <- 1))
            try db.run(jobTable.insert(name <- "Android Developer",
                                       Expression<Int64>("salary") <- 122000,
                                       Expression<String>("experience") <- "5+years",
                                       Expression<String>("position") <- "Software Developer",
                                       Expression<Int64>("companyId") <- 2))
            try db.run(jobTable.insert(name <- "IT Support",
                                       Expression<Int64>("salary") <- 777500,
                                       Expression<String>("experience") <- "5+years",
                                       Expression<String>("position") <- "IT Engineer",
                                       Expression<Int64>("companyId") <- 3))
            try db.run(jobTable.insert(name <- "Accounts Officer",
                                       Expression<Int64>("salary") <- 787500,
                                       Expression<String>("experience") <- "2+years",
                                       Expression<String>("position") <- "Accounts Officer",
                                       Expression<Int64>("companyId") <- 4))
            try db.run(jobTable.insert(name <- "Accounts Payable",
                                       Expression<Int64>("salary") <- 788000,
                                       Expression<String>("experience") <- "1+years",
                                       Expression<String>("position") <- "Accounts Officer",
                                       Expression<Int64>("companyId") <- 4))
            
            try db.run(skillTable.insert(name <- "Swift"))
            try db.run(skillTable.insert(name <- "C++"))
            try db.run(skillTable.insert(name <- "Object Oriented Design"))
            try db.run(skillTable.insert(name <- "Java"))
            try db.run(skillTable.insert(name <- "C#"))
            try db.run(skillTable.insert(name <- ".Net"))
            try db.run(skillTable.insert(name <- "Windows Server"))
            try db.run(skillTable.insert(name <- "VNWare"))
            try db.run(skillTable.insert(name <- "Account Analysis"))
            try db.run(skillTable.insert(name <- "Accounting Principles"))
            try db.run(skillTable.insert(name <- "Crystal Reports"))
            try db.run(skillTable.insert(name <- "Financial Software"))
            try db.run(skillTable.insert(name <- "Oracle"))
            try db.run(skillTable.insert(name <- "Payroll"))
            try db.run(skillTable.insert(name <- "Invoices"))
            try db.run(skillTable.insert(name <- "Debt Management"))
            
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
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 5,
                                            Expression<Int64>("skillId") <- 14))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 5,
                                            Expression<Int64>("skillId") <- 13))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 5,
                                            Expression<Int64>("skillId") <- 9))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 5,
                                            Expression<Int64>("skillId") <- 10))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 6,
                                            Expression<Int64>("skillId") <- 11))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 6,
                                            Expression<Int64>("skillId") <- 12))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 6,
                                            Expression<Int64>("skillId") <- 9))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 6,
                                            Expression<Int64>("skillId") <- 14))
            try db.run(jobSkillTable.insert(Expression<Int64>("jobId") <- 6,
                                            Expression<Int64>("skillId") <- 15))
            
        }catch{
            print(error)
        }
    }
   
    static func testQuery()
    {
        let users = try! db.prepare(userTable)
        for user in users {
            
            print("userId: \(user[id]), userName: \(user[name]), userPhone: \(user[Expression<Int64>("phone")]), userEmail: \(user[Expression<String>("email")])")
        }
        let jobs = try! db.prepare(jobTable)
        for job in jobs {
            
            print("JobId: \(job[id]), JobName: \(job[name]), JobPosition: \(job[Expression<String>("position")]), Salary: \(job[Expression<Int64>("salary")]) CompanyID: \(job[Expression<Int64>("companyId")])")
        }
        let skills = try! db.prepare(skillTable)
        for skill in skills {
            
            print("SkillId: \(skill[id]), SkillName: \(skill[name])")
        }
        let companies = try! db.prepare(companyTable)
        for company in companies {
            print("companyId: \(company[id]), companyName: \(company[name]), address: \(company[Expression<String>("address")])")
        }

    }
    static func createTables()
    {
        createUserTable()
        createCompanyTable()
        createJobTable()
        createSkillTable()
        createJobSkillTable()
        print("Create Tables ")
    }
    static func deleteTables (){
        let tables = [companyTable,jobTable,jobSkillTable,skillTable]
        for table in tables
        {
            try! db.run(table.drop())
        }
    }
    static func deletedata() {
        let tables = [companyTable,jobTable,jobSkillTable,skillTable]
        for table in tables
        {
            try! db.run(table.delete())
        }
    }
    static func getUserList () -> [User]{
        var userList = [User]()
        let rows = try! db.prepare(userTable)
        for row in rows {
            let name = row[self.name]
            let address = row[Expression<String>("address")]
            let phone =  row[Expression<Int64>("phone")]
            let email =  row[Expression<String>("email")]
            let user = User(name: name, address: address, email: email, phone: phone)
            userList.append(user)

        }
        return userList
        
    }
}

