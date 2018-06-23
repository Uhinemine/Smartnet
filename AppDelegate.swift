
import UIKit
import Firebase
import UserNotifications
import SwiftKeychainWrapper

var darkThemeApply = Bool()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        UINavigationBar.appearance().isTranslucent = false
        
        if theme == "dark" {
            UILabel.appearance().textColor = UIColor.white
            UITableViewCell.appearance().backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
            print(theme!)
            UITableView.appearance().backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            UITableView.appearance().separatorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            UITabBar.appearance().barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            UITabBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            UINavigationBar.appearance().tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            UITextField.appearance().textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
            
        }
        
        
        registerForPushNotifications()
        application.registerForRemoteNotifications()
        
        return true
    }
    
    
}
extension UITableViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        headerView.backgroundColor = UIColor.red
        
        return headerView
    }
    
}

