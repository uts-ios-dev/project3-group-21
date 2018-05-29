//
//  JobResultTableViewController.swift
//  JOB DATING
//
//  Created by Md Istiaq Alam on 25/5/18.
//  Copyright © 2018 iOS-21. All rights reserved.
//

import UIKit
import SQLite

class JobResultTableViewController: UITableViewController {
    var categoryName = ""
    var skillList = [String] ()
    var jobName = ""
    var location = ""
    var salary : Int64 = 0
    var matchedPercentage : Int64 = 0
    var jobResults = [Job] ()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        queryJobResults()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobResults.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as? JobResultTableCell
        
        // Configure the cell...
        cell?.jobName.text = jobResults[indexPath.row].name
        cell?.matchedPecentage.text = String(jobResults[indexPath.row].matched)
        cell?.salary.text = String(jobResults[indexPath.row].salary)
        cell?.location.text = String(jobResults[indexPath.row].location)
        return cell!
    }

    
    func queryJobResults() {
        //Query of showing the job goes here
        
        let colName = Expression<String>("name")
        let colAddress = Expression<String>("address")
        let colID = Expression<Int64>("id")
        let colSkillID = Expression<Int64>("skillId")
        let colJobID = Expression<Int64>("jobId")
        let colCategory = Expression<String>("position")
        let colSalary = Expression<Int64>("salary")
        let colCompanyID = Expression<Int64>("companyId")
        
        
        let jobTable = dbConfiguration.jobTable.select(distinct: colName).order(colName)
        let jobSkillTable = dbConfiguration.jobSkillTable
        let skillTable = dbConfiguration.skillTable
        let companyTable = dbConfiguration.companyTable
        
        
       
        // get job ID list associated with skill list
        var jobIDList = [Int64]()
        for skillName in skillList {
            let joinQuery = skillTable.join(jobSkillTable, on: colID == jobSkillTable[colSkillID]).where(colName == skillName)
            let rows = try! dbConfiguration.db.prepare(joinQuery)
            for row in rows {
                jobIDList.append(row[jobSkillTable[colJobID]])
            }
        }
        jobIDList = Array(Set(jobIDList))
        //get Array of job name, matched % and company location
        for jobID in jobIDList {
            // get job name and company id
            
            var companyID : Int64 = 0
            let jobQuery = jobTable.select(colName, colCompanyID, colSalary).where(colCategory == categoryName && colID == jobID)
            let jobRows = try! dbConfiguration.db.prepare(jobQuery)
            for row in jobRows {
                jobName = row[colName]
                companyID = row[colCompanyID]
                salary = row[colSalary]
            }
            //get comapny locations
            let companyQuery = companyTable.select(colAddress).where(colID == companyID)
            let companyRows = try! dbConfiguration.db.prepare(companyQuery)
            for row in companyRows {
                location = convertAddressToLocation(row[colAddress])
                
            }

            // get skill list related to job
            var jobSkillList = [String]()
            let joinQuery = skillTable.join(jobSkillTable, on: colID == jobSkillTable[colSkillID]).where(jobSkillTable[colJobID] == jobID)
            let joinRows = try! dbConfiguration.db.prepare(joinQuery)
            for row in joinRows {
                jobSkillList.append(row[colName])
            }
            var matched = 0.0
            var count  = 0.0
            for skill in skillList {
                if jobSkillList.contains(skill) {
                    matched += 1
                }
            }
            count = Double(jobSkillList.count)
            matchedPercentage = Int64((matched/(count) * 100.0).rounded())
            let job = Job(name: jobName, matched: matchedPercentage, salary: salary, location: location)
            jobResults.append(job)
           
        }
        
    }
    
    func convertAddressToLocation (_ address: String) -> String {
        // code for converting address to location here
        var loc = ""
        let seperated = address.split(separator: ",")
        if let final = seperated.last {
            loc = String(final).trimmingCharacters(in: .whitespaces)
        }
        return loc
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
