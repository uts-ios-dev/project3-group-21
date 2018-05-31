//
//  JobDetailsViewController.swift
//  JOB DATING
//
//  Created by Md Istiaq Alam on 25/5/18.
//  Copyright © 2018 iOS-21. All rights reserved.
//

import UIKit
import SQLite

class JobDetailsViewController: UIViewController {
    var job: Job!
    let colId = Expression<Int64>("id")
    let colCompanyId = Expression<Int64>("companyId")
    let colSkillId = Expression<Int64>("skillId")
    let colName = Expression<String>("name")
    let colJobId = Expression<Int64>("jobId")
    let companyTable = dbConfiguration.companyTable
    let jobTable = dbConfiguration.jobTable
    let jobSkillTable = dbConfiguration.jobSkillTable
    let skillTable = dbConfiguration.skillTable
    var skillList:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        queryInfo()

        // Do any additional setup after loading the view.
    }
   
//    @IBAction func StartOverButton(_ sender: Any) {
//        presentingViewController?.dismiss(animated: true, completion: nil)
//    }
    @IBOutlet weak var jobTitle: UITextView!
    @IBOutlet weak var position: UITextView!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var phone: UITextView!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var salary: UITextView!
    @IBOutlet weak var experience: UITextView!
    @IBOutlet weak var skills: UITextView!
    @IBOutlet weak var companyName: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func queryInfo()
    {
        queryCompanyInfo()
        querySkillInfo()
    }
    
    func queryCompanyInfo()
    {
        let theCompany = jobTable.join(companyTable, on:  companyTable[colId] == jobTable[colCompanyId] ).where(jobTable[colId] == job.jobId)
        let companyRow = try! dbConfiguration.db.prepare(theCompany)
        for row in companyRow
        {
            jobTitle.text = row[jobTable[colName]]
            position.text = row[jobTable[Expression<String>("position")]]
            address.text = row[companyTable[Expression<String>("address")]]
            phone.text = String(row[companyTable[Expression<Int64>("phone")]])
            email.text = row[companyTable[Expression<String>("email")]]
            salary.text = String(row[jobTable[Expression<Int64>("salary")]]) + "/y"
            experience.text = row[jobTable[Expression<String>("experience")]]
            companyName.text = row[companyTable[colName]]
        }
    }
    
    func querySkillInfo()
    {
        let skillQuery = jobSkillTable.join(skillTable, on: jobSkillTable[colSkillId] == skillTable[colId]).where(jobSkillTable[colJobId] == job.jobId)
        let skillResult = try! dbConfiguration.db.prepare(skillQuery)
        for row in skillResult
        {
            skillList.append(row[skillTable[colName]])
        }
        
        let skillString = skillList.map { String($0) }
            .joined(separator: ", ")
        skills.text = skillString
    }

   
    
}
