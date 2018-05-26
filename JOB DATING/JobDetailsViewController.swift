//
//  JobDetailsViewController.swift
//  JOB DATING
//
//  Created by Md Istiaq Alam on 25/5/18.
//  Copyright © 2018 iOS-21. All rights reserved.
//

import UIKit

class JobDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func StartOverButton(_ sender: Any) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    
}
