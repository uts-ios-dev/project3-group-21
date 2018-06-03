//
//  LoginViewController.swift
//  AccountKitTest
//
//  Created by Test on 01.11.17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import AccountKit

class LoginViewController: UIViewController, AKFViewControllerDelegate {
    
    var accountKit: AKFAccountKit!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        dbConfiguration.createTables()
        dbConfiguration.addData()
        dbConfiguration.testQuery()
//               dbConfiguration.deletedata();
//              dbConfiguration.deleteTables();
//

        //Init Account Kit
        if accountKit == nil {
            self.accountKit = AKFAccountKit(responseType: .accessToken)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (accountKit.currentAccessToken != nil) {
            print("User already logged in, go to the home screen")
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "ShowHome", sender: self)
            })
        }
    }
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        loginViewController.delegate = self
        loginViewController.setAdvancedUIManager(nil)
        
        //Customize the theme
        let theme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        loginViewController.setTheme(theme)
    }
    
    @IBAction func loginWithPhone(_ sender: UIButton) {
        //login with Phone
        let inputState = UUID().uuidString
        let viewController = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func loginWithEmail(_ sender: UIButton) {
        //login with Email
        let inputState = UUID().uuidString
        let viewController = accountKit.viewControllerForEmailLogin(withEmail: nil, state: inputState) as AKFViewController
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToLogin(_ sender: UIStoryboardSegue){
        
    }

}
