//
//  SkillsTableViewController.swift
//  JOB DATING
//
//  Created by Md Istiaq Alam on 25/5/18.
//  Copyright © 2018 iOS-21. All rights reserved.
//

import UIKit
import SQLite

class SkillsTableViewController: UITableViewController {
    var catName = ""
    var skillsList = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("catName: \(catName)")
        querySkills()

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
        return skillsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as? SkillsTableViewCell

        cell?.skillName.text = skillsList[indexPath.row]
        // Configure the cell...

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCellAccessoryType.checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    func querySkills() {
        
        //Query of showing the skills goes here
       
        let jobTable = dbConfiguration.jobTable
        let jobSkillTable = dbConfiguration.jobSkillTable
        let skillIDQuery = jobTable.join(jobSkillTable, on: Expression<Int64>("id") == jobSkillTable[Expression<Int64>("jobId")]).where (Expression<String>("position") == catName)
        let skillIDRows = try! dbConfiguration.db.prepare(skillIDQuery)
        for row in skillIDRows {
            let skillID = row[jobSkillTable[Expression<Int64>("skillId")]]
            print ("skilLID: \(skillID)")
            let skillQuery = dbConfiguration.skillTable.where(Expression<Int64>("id") == skillID)
            let skills = try!dbConfiguration.db.prepare(skillQuery)
            for skill in skills {
                skillsList.append(skill[Expression<String>("name")])
            
            }
        }
        skillsList = Array(Set(skillsList))
        skillsList = skillsList.sorted(by: { (a, b) -> Bool in
            a <= b
        })
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is JobResultTableViewController
        {
         
            let selectedRowIndexs = self.tableView.indexPathsForSelectedRows
            if selectedRowIndexs == nil {
                let warning = UIAlertController(title: "Error", message: "You need to choose at least one skill", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) {
                    UIAlertAction in
                    NSLog("Ok Pressed")
                }
                warning.addAction(okAction)
                self.present(warning, animated: true, completion: nil)
            }
            else {
                let vc = segue.destination as? JobResultTableViewController
                print(selectedRowIndexs)
                for selectedRowIndex in selectedRowIndexs! {
                    
                    print(selectedRowIndex.row)
                    vc?.skillList.append(skillsList[selectedRowIndex.row])
                }
            
            }
            
            
            
           
        }
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
