//
//  JobCatTableViewController.swift
//  JOB DATING
//
//  Created by Md Istiaq Alam on 25/5/18.
//  Copyright © 2018 iOS-21. All rights reserved.
//

import UIKit
import SQLite

class JobCatTableViewController: UITableViewController, UISearchBarDelegate {

    var categories = [String]()
    var jobNames = [String]()
    
    var searchedJobs = [String]()
    var searchCategories = [String()]
    var shouldShowSearchResults = false
    //let searchbar = UISearchBar()
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbConfiguration.createTables()
        dbConfiguration.addData()
        dbConfiguration.testQuery()
        createSearchbar()
        queryJobName()
        queryJobCategory()
        //searchQuery()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func createSearchbar() {

        searchbar.delegate = self as UISearchBarDelegate
        //self.navigationItem.titleView = searchbar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCategories.removeAll()
        searchedJobs = jobNames.filter({ (name: String) -> Bool in
            
            return  name.lowercased().contains(searchText.lowercased())
        })
        searchQuery()
        if searchText == "" {
            shouldShowSearchResults = false
        }else
        {
            shouldShowSearchResults = true
        }
        
        
        tableView.reloadData()
        //searchCategories.removeAll()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if shouldShowSearchResults
        {
            return searchCategories.count
        }
        else{
            return categories.count
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath) as? JobCatTableViewCell)
        if shouldShowSearchResults{
            cell?.CategoryName.text = searchCategories[indexPath.row]
            return cell!
        }
        else
        {
        cell?.CategoryName.text = categories[indexPath.row]
        
        // Configure the cell...
        
        return cell!
        }
    }
    func queryJobCategory() {
        
        //Query of showing the job categories goes here
        let categoryCol = Expression<String>("position")
        let jobTable = dbConfiguration.jobTable.select(distinct: categoryCol).order(categoryCol)
        let jobs = try! dbConfiguration.db.prepare(jobTable)
        for job in jobs {
            categories.append(job[Expression<String>("position")])
        }
    }
    
    func queryJobName() {
        
        //Query of showing the job categories goes here
        let nameCol = Expression<String>("name")
        let nameTable = dbConfiguration.jobTable.select(distinct: nameCol).order(nameCol)
        let names = try! dbConfiguration.db.prepare(nameTable)
        for name in names {
            jobNames.append(name[Expression<String>("name")])
        }
    }
    
    func searchQuery() {

        //Query of showing the skills goes here
        let jobTable = dbConfiguration.jobTable
        let categoryCol = Expression<String>("position")
        let query = jobTable.select(distinct: categoryCol).where(searchedJobs.contains(Expression<String>("name")))
        let jobs = try! dbConfiguration.db.prepare(query)
        for job in jobs {
            searchCategories.append(job[Expression<String>("position")])
        }


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is SkillsTableViewController
        {
            var selectedRowIndex = self.tableView.indexPathForSelectedRow
            let vc = segue.destination as? SkillsTableViewController
            if shouldShowSearchResults == true
            {
            vc?.catName = searchCategories[selectedRowIndex!.row]
            }else
            {
            vc?.catName = categories[selectedRowIndex!.row]
            }
        }
    }
    
    private func searchBarSearchButtonClicked(searchBar: UISearchBar){
        shouldShowSearchResults = true
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
    @IBAction func unwindToCat(_ sender: UIStoryboardSegue){
    
        
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

