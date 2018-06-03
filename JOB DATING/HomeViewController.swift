//
//  HomeViewController.swift
//  AccountKitTest
//
//  Created by Test on 01.11.17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import SQLite
import AccountKit

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default: return rhs < lhs
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class HomeViewController: UIViewController {
    
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var accountID: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var phoneOrEmailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phoneOrEmail: UILabel!
    @IBOutlet weak var phoneorEmailText: UITextField!
    @IBOutlet weak var alertMessage: UILabel!
    
    @IBOutlet weak var logout: UIButton!
    var accountKit: AKFAccountKit!
    var isUserExisted = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // showLogoutButton()
        //Init Account Kit
        let userList = dbConfiguration.getUserList()
        
        if accountKit == nil {
            self.accountKit = AKFAccountKit(responseType: .accessToken)
            accountKit.requestAccount({ (account, error) in
                self.accountID.text = account?.accountID
                if account?.emailAddress?.count > 0 {
                    //if the user is logged with Email
                    self.typeLabel.text = "Email Address"
                    let email = account!.emailAddress!
                    self.phoneOrEmailLabel.text = email
                    self.phoneOrEmail.text = "Phone Number"
                    for user in userList {
                        if user.email == email {
                            self.welcomeBack (user);
                            self.isUserExisted = true
                        }
                    }
                } else if account?.phoneNumber?.phoneNumber != nil {
                    self.typeLabel.text = "Phone Number"
                    let phone = account!.phoneNumber!.stringRepresentation()
                    self.phoneOrEmailLabel.text = phone
                    self.phoneOrEmail.text = "Email Address"
                    for user in userList {
                        if user.phone == Int64(phone)! {
                            self.welcomeBack (user);
                            self.isUserExisted = true
                        }
                    }
                }
            })
        }
       
        
    }
    func welcomeBack (_ user: User) {
        self.headLabel.text = "Welcome back, \(user.name)"
        self.nameLabel.text = ""
        self.addressLabel.text = ""
        self.phoneOrEmail.text = ""
        name.isHidden = true
        address.isHidden = true
        phoneorEmailText.isHidden = true
        logout.isHidden = false
    }
    
    @IBAction func showNextView(_ sender: UIButton) {
        if (!isUserExisted) {
            if name.text == "" || address.text == "" || phoneorEmailText.text == "" {
                showAlert()
            }
            else {
               saveUser()
            }
           
        }
        accountKit.logOut()
        let mainNavigationController = storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as! MainNavigationController
        present(mainNavigationController,  animated: true, completion: nil)
    }
    
//    func showLogoutButton()
//    {
//        if isUserExisted {
//            logout.isHidden = false
//        }else{
//            logout.isHidden = true
//        }
//    }
    
    func showAlert() {
        let warning = UIAlertController(title: "Error", message: "You need to fill in all information", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            NSLog("Ok Pressed")
        }
        warning.addAction(okAction)
        self.present(warning, animated: true, completion: nil)
        
    }
    func saveUser (){
        let userTable = dbConfiguration.userTable
        let userName = self.name.text!
        let userAddress = self.address.text!
        var userEmail = ""
        var userPhone: Int64 = 0
        if (phoneOrEmail.text == "Email Address") {
            userEmail = phoneorEmailText.text!
            userPhone = Int64(self.phoneOrEmailLabel.text!)!
        }
        else {
            userPhone = Int64(phoneorEmailText.text!)!
            userEmail = self.phoneOrEmailLabel.text!
        }
        try! dbConfiguration.db.run(userTable.insert(Expression<String>("name") <- userName, Expression<String>("address") <- userAddress, Expression<Int64>("phone") <- userPhone, Expression<String>("email") <- userEmail))
        print("userSaved\n")
    
        
    }
    
}
