

import UIKit
import Foundation

import SwiftKeychainWrapper


class PersonalizationVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(theme)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let darkThemeCell = tableView.dequeueReusableCell(withIdentifier: "darkThemeApply")!
     let lightThemeCell = tableView.dequeueReusableCell(withIdentifier: "lightThemeApply")!
     let accentColorCell = tableView.dequeueReusableCell(withIdentifier: "accentColorTheme")!
     return 0
     
     }*/
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertTitle = "Restart Required"
        let alertMessage = "To set \(theme) theme double press on Home button and swipe up the program."
        if indexPath.row == 1 {
            darkThemeApply = true
            print("Applied dark theme")
            
            KeychainWrapper.standard.set("dark", forKey: "theme")
            
            alert(title: alertTitle, message: alertMessage, in: self)
        }
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        if indexPath.row == 2   {
            //darkThemeApply = false
            print("Applied light theme")
            KeychainWrapper.standard.set("light", forKey: "theme")
            alert(title: alertTitle, message: alertMessage, in: self)
            
        }
        if indexPath.row == 3 {
            //darkThemeApply = false
            print("Applied accient color")
            KeychainWrapper.standard.set("light", forKey: "theme")
            alert(title: alertTitle, message: alertMessage, in: self)
        
        }
        print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
