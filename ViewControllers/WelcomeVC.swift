
import UIKit
import Photos
import XLActionController

var backgroundImgURL = "https://picsum.photos/\(375*1.5)/\(657*1.5)/?image=\(arc4random_uniform(900))"

class WelcomeVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var registerView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var profilePicView: RoundedImageView!
    @IBOutlet weak var registerNameField: UITextField!
    @IBOutlet weak var registerEmailField: UITextField!
    @IBOutlet weak var registerPasswordField: UITextField!
    @IBOutlet var waringLabels: [UILabel]!
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    //@IBOutlet weak var cloudsView: UIImageView!
    //@IBOutlet weak var cloudsViewLeading: NSLayoutConstraint!
    @IBOutlet var inputFields: [UITextField]!
    var loginViewTopConstraint: NSLayoutConstraint!
    var registerTopConstraint: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    var isLoginViewVisible = true
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: Methods
    func customization()  {
        
        self.imagePicker.delegate = self
        self.profilePicView.layer.borderColor = GlobalVariables.blue.cgColor
        
        //LoginView customization
        self.view.insertSubview(self.loginView, belowSubview: self.darkView)
        self.view.insertSubview(self.registerView, belowSubview: self.darkView)
        
        self.loginView.layer.cornerRadius = 15
        self.registerView.layer.cornerRadius = 15
        
        self.registerView.center = view.center
        self.loginView.center = view.center
        
        self.registerView.alpha = 0
    }
   
    
    
    func showLoading(state: Bool)  {
        if state {
            self.darkView.isHidden = false
            self.spinner.startAnimating()
            UIView.animate(withDuration: 0.3, animations: { 
                self.darkView.alpha = 0.5
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.darkView.alpha = 0
            }, completion: { _ in
                self.spinner.stopAnimating()
                self.darkView.isHidden = true
            })
        }
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") //as! NavVC
        self.show(vc!, sender: nil)
    }
    
    func openPhotoPickerWith(source: PhotoSource) {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func switchViews(_ sender: UIButton) {
        var animTime = 0.1
        if self.isLoginViewVisible {
            
            self.isLoginViewVisible = false
            UIView.animate(withDuration: animTime) {
                self.loginView.alpha = 0
                self.registerView.alpha = 1
            }
           
            sender.setTitle("Login", for: .normal)
            
        } else {
            self.isLoginViewVisible = true
            UIView.animate(withDuration: animTime) {
                self.loginView.alpha = 1
                self.registerView.alpha = 0
            }
            sender.setTitle("Create New Account", for: .normal)
            
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        for item in self.waringLabels {
            item.isHidden = true
        }
    }
    
    @IBAction func register(_ sender: Any) {
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        self.showLoading(state: true)
        User.registerUser(withName: self.registerNameField.text!, email: self.registerEmailField.text!, password: self.registerPasswordField.text!, profilePic: self.profilePicView.image!) { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                weakSelf?.showLoading(state: false)
                for item in self.inputFields {
                    item.text = ""
                }
                if status == true {
                    weakSelf?.pushTomainView()
                    weakSelf?.profilePicView.image = UIImage.init(named: "profile pic")
                } else {
                    /*for item in (weakSelf?.waringLabels)! {
                        item.isHidden = false
                    }*/
                    self.showCardView(theme: .error, title: "Wrong parameters", body: "One of fields is filled incorrectly")
                }
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        //self.showLoading(state: true)
        User.loginUser(withEmail: self.loginEmailField.text!, password: self.loginPasswordField.text!) { [weak weakSelf = self](status) in
            DispatchQueue.main.async {
                weakSelf?.showLoading(state: false)
                for item in self.inputFields {
                    item.text = ""
                }
                if status == true {
                    weakSelf?.pushTomainView()
                } else {
                    /*for item in (weakSelf?.waringLabels)! {
                        item.isHidden = false
                    }*/
                    self.showCardView(theme: .error, title: "Wrong parameters", body: "One of fields is filled incorrectly")
                }
                weakSelf = nil
            }
        }
    }
    
    @IBAction func selectPic(_ sender: Any) {
        let pictureSelectionSheet = TwitterActionController()
        pictureSelectionSheet.headerData = "Select profile picture"
        pictureSelectionSheet.addAction(Action(ActionData(title: "Library", image: #imageLiteral(resourceName: "SettingsStickersIcon") ), style: .default, handler: { action in
            self.openPhotoPickerWith(source: .library)
        }))
        pictureSelectionSheet.addAction(Action(ActionData(title: "Camera", image: #imageLiteral(resourceName: "ModernGodModeIcon") ), style: .default, handler: { action in
            self.openPhotoPickerWith(source: .camera)
        }))
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.present(pictureSelectionSheet, animated: true, completion: nil)
    }
    
    //MARK: Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for item in self.waringLabels {
            item.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            if pickedImage != nil {
                self.profilePicView.image = pickedImage
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        getImageFromURL(backgroundImgURL, backgroundImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.layoutIfNeeded()
    }
}
func getImageFromURL(_ url_str:String, _ imageView:UIImageView)
{
    let url:URL = URL(string: url_str)!
    let session = URLSession.shared
    
    let task = session.dataTask(with: url, completionHandler: {
        (
        data, response, error) in
        if data != nil
        {
            let image = UIImage(data: data!)
            if(image != nil)
            {
                DispatchQueue.main.async(execute: {
                    imageView.image = image
                    imageView.alpha = 0
                    UIView.animate(withDuration: 2.5, animations: {
                        imageView.alpha = 1.0
                    })
                })
            }
        }
    })
    
    task.resume()
}
