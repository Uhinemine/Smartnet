//
//  ProfileCustomizationVC.swift
//  Smartnet
//
//  Created by Art Zav on 5/24/18.
//

import UIKit
import Firebase
import Photos
import XLActionController
import SwiftMessages
class ProfileCustomizationVC: UITableViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: {[weak weakSelf = self] (user) in
                DispatchQueue.main.async {
                    weakSelf?.usernameField.text = user.name
                    //weakSelf?.emailLabel.text = user.email
                    weakSelf?.profileImg.image = user.profilePic
                    weakSelf = nil
                }
            })
        }
        showCardView(theme: .error, title: "Error", body: "Restart device")
        
        // Show the message.
        //SwiftMessages.show(view: view)
    }
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var profileImg: RoundedImageView!
    @IBOutlet weak var profileImgBtn: UIButton!
    
    @IBAction func selectImg(_ sender: Any) {
        let pictureSelectionSheet = SpotifyActionController()
        //pictureSelectionSheet.headerData = "Select profile picture"
        pictureSelectionSheet.addAction(Action(ActionData(title: "Library", image: #imageLiteral(resourceName: "SettingsStickersIcon") ), style: .default, handler: { action in
            self.openPhotoPickerWith(source: .library)
        }))
        pictureSelectionSheet.addAction(Action(ActionData(title: "Camera", image: #imageLiteral(resourceName: "ModernGodModeIcon") ), style: .default, handler: { action in
            self.openPhotoPickerWith(source: .camera)
        }))
         UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.present(pictureSelectionSheet, animated: true, completion: nil)
        /*let sheet = UIAlertController(title: nil, message: "Select the source", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .camera)
        })
        let photoAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openPhotoPickerWith(source: .library)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cameraAction)
        sheet.addAction(photoAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)*/
    }
    @IBAction func saveChanges(_ sender: Any) {
        let id = Auth.auth().currentUser?.uid
        
        alert(title: theme!, message: theme!, in: self)
        
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            if pickedImage != nil {
                self.profileImg.image = pickedImage
                User.changeUserPicture(withImage: pickedImage)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func showCardView(theme: Theme = .info, title: String, body: String, button: String = "OK"){
        let view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureTheme(theme)
        view.configureDropShadow()
        view.configureContent(title: title, body: body)
        
        SwiftMessages.show(view: view)
    }
}
