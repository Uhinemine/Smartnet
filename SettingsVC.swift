//
//  SettingsVC.swift
//  Smartnet
//
//  Created by Art Zav on 5/6/18.
//  Copyright © 2018 Mexonis. All rights reserved.
//

import UIKit
import Firebase
class SettingsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    weakSelf?.usernameLbl.text = user.name
                    weakSelf?.emailLbl.text = user.email
                    weakSelf?.userImg.image = user.profilePic
                   
                }
            })
        }
        //tableView.tableFooterView =
        //tableView.ta

    }
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = (tableView.cellForRow(at: indexPath!) as! UITableViewCell)
        
        if currentCell.textLabel!.text == "Music" {
            tabBarController?.tabBar.isHidden = true
            navigationController?.navigationBar.isHidden = true
        }
        
    }
}

