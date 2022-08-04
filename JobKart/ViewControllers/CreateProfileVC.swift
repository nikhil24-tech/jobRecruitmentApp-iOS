//
//  CreateProfileVC.swift
//  JobKart
//
//  Created by 2022M3 on 07/07/22.
//

import UIKit

class CreateProfileVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var txtOName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtOType: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtEducationLevel: UITextField!
    @IBOutlet weak var txtJobExp: UITextField!
    @IBOutlet weak var txtSkills: UITextField!
    @IBOutlet weak var txtAboutMe: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnUpdateProfile: BlueThemeButton!
    
    var index : Int = 0
    var imgPicker = UIImagePickerController()
    var imgPicker1 = OpalImagePickerController()
    var isImageSelected : Bool = false
    var imageURL = ""
    var email: String = ""
    var phone: String = ""
    var uid: String = ""
    
    func setUp() {
        if index == 1 {
            self.updateView(data: true)
        } else {
            self.updateView(data: false)
        }
    }
    
    func updateView(data:Bool){
        self.txtEmail.isHidden = !data
        self.txtOType.isHidden = !data
        self.txtOName.isHidden = !data
        self.txtPhone.isHidden = !data
        
        self.txtSkills.isHidden = data
        self.txtJobExp.isHidden = data
        self.txtAboutMe.isHidden = data
        self.txtEducationLevel.isHidden = data
    }
    
    private func validation() -> String {
        if index == 1 {
            if self.txtOName.text?.trim() == "" {
                return STRING.errorOName
            }else if self.txtEmail.text?.trim() == "" {
                return STRING.errorEmail
            }else if self.txtPhone.text?.trim() == "" {
                return STRING.errorMobile
            }else if self.txtOType.text?.trim() == "" {
                return STRING.errorOType
            }else if self.txtAddress.text?.trim() == "" {
                return STRING.errorAddress
            }
            
        } else {
            if self.txtAddress.text?.trim() == "" {
                return STRING.errorAddress
            }else if self.txtEducationLevel.text?.trim() == "" {
                return STRING.errorEducationLevel
            }else if self.txtJobExp.text?.trim() == "" {
                return STRING.errorJobExp
            }else if self.txtSkills.text?.trim() == "" {
                return STRING.errorSkills
            }else if self.txtAboutMe.text?.trim() == "" {
                return STRING.errorAboutMe
            }
        }
        return ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtEmail.isUserInteractionEnabled = false
        self.txtPhone.isUserInteractionEnabled = false
        self.txtEmail.text = self.email
        self.txtPhone.text = self.phone
        self.setUp()

        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height/2
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.openPicker()
        }
        self.imgProfile.isUserInteractionEnabled = true
        self.imgProfile.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnAddClick(_ sender: UIButton) {
        let error = self.validation()
        if error == "" {
            self.addCreateData(address: self.txtAddress.text ?? "", oName: self.txtOName.text ?? "", oType: self.txtOType.text ?? "", educationLevel: self.txtEducationLevel.text ?? "", skills: self.txtSkills.text ?? "", aboutMe: self.txtAboutMe.text ?? "", email: self.email, phone: self.phone)
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
    }
    
    
    func openPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: "Select Image", preferredStyle: .actionSheet)
        
        let cameraPhoto = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return Alert.shared.showAlert(message: "Camera not Found", completion: nil)
            }
            GFunction.shared.isGiveCameraPermissionAlert(self) { (isGiven) in
                if isGiven {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.imgPicker.mediaTypes = ["public.image"]
                        self.imgPicker.sourceType = .camera
                        self.imgPicker.cameraDevice = .rear
                        self.imgPicker.allowsEditing = true
                        self.imgPicker.delegate = self
                        self.present(self.imgPicker, animated: true)
                    }
                }
            }
        })
        
        let PhotoLibrary = UIAlertAction(title: "Gallary", style: .default, handler:
                                            { [self]
            (alert: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos == .denied || photos == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized {
                            DispatchQueue.main.async {
                                self.imgPicker1 = OpalImagePickerController()
                                self.imgPicker1.imagePickerDelegate = self
                                self.imgPicker1.isEditing = true
                                present(self.imgPicker1, animated: true, completion: nil)
                            }
                        }
                    })
                }else if photos == .authorized {
                    DispatchQueue.main.async {
                        self.imgPicker1 = OpalImagePickerController()
                        self.imgPicker1.imagePickerDelegate = self
                        self.imgPicker1.isEditing = true
                        present(self.imgPicker1, animated: true, completion: nil)
                    }
                    
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            
        })
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        actionSheet.addAction(cameraPhoto)
        actionSheet.addAction(PhotoLibrary)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
}


//MARK:- UIImagePickerController Delegate Methods
extension CreateProfileVC: UIImagePickerControllerDelegate, OpalImagePickerControllerDelegate {
    func uploadImagePic(img1 :UIImage){
        let data = img1.jpegData(compressionQuality: 0.8)! as NSData
        // set upload path
        let imagePath = GFunction.shared.UTCToDate(date: Date())
        let filePath = "Profile/\(imagePath)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference(withPath: filePath)
        storageRef.putData(data as Data, metadata: metaData) { (metaData, error) in
            if let error = error {
                return
            }
            storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
                self.isImageSelected = true
                self.imageURL = url?.absoluteString ?? ""
                print(url?.absoluteString) // <- Download URL
                self.imgProfile.setImgWebUrl(url: self.imageURL, isIndicator: true)
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        if let image = info[.editedImage] as? UIImage {
            uploadImagePic(img1: image)
            self.imgProfile.image = image
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        do { picker.dismiss(animated: true) }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]){
        for image in assets {
            if let image = getAssetThumbnail(asset: image) as? UIImage {
                uploadImagePic(img1: image)
                self.imgProfile.image = image
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: (asset.pixelWidth), height: ( asset.pixelHeight)), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func addCreateData(address: String, oName:String,oType: String,educationLevel: String,skills: String, aboutMe:String, email:String, phone: String) {
        
        let ref = AppDelegate.shared.db.collection(jUser).document(uid)
        ref.updateData([
            jOrgAddress: address,
            jOrgName : oName,
            jOrgType: oType,
            jJSEduLevel: educationLevel,
            jSkills: skills,
            jOrgImageURL : self.imageURL,
            jJSAboutMe : aboutMe,
        ]){  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self){
                    vc.index = self.index
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
