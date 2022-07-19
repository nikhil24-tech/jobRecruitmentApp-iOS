//
//  LoginVC.swift
//  JobKart

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: BlueThemeButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    var index = 0
    var flag: Bool = true
    var socialData: SocialLoginDataModel!
    
    @IBAction func btnClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation(email: self.txtEmail.text?.trim() ?? "", password: self.txtPassword.text?.trim() ?? "")
        
        if error.isEmpty {
            if self.txtEmail.text == "Admin@gmail.com" && self.txtPassword.text == "Admin@1234" && index == 2{
                UIApplication.shared.setAdmin()
            }else{
                let type = (index == 1) ? jJSeeker : jEmp
                self.loginUser(email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "", userType: type)
            }
        }else{
            Alert.shared.showAlert(message: error, completion: nil)
        }
       
    }
    
    private func validation(email:String, password:String) -> String {
        if email.isEmpty {
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email) {
            return STRING.errorValidEmail
        }else if password.isEmpty {
            return STRING.errorPassword
        }
        
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if index == 1 {
            self.lblTitle.text = "I’m \nJobSeeker"
        }else if index == 2 {
            self.lblTitle.text = "Admin"
        }
        
        if socialData != nil {
            self.txtEmail.text = socialData.email
            self.txtEmail.isUserInteractionEnabled = false
        }
        // Do any additional setup after loading the view.
    }

}


//MARK:- Extension for Login Function
extension LoginVC {
    func loginUser(email:String,password:String,userType:String) {
        _ = AppDelegate.shared.db.collection(jUser).whereField(jEmail, isEqualTo: email).whereField(jPassword, isEqualTo: password).whereField(jUserType, isEqualTo: userType).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let name: String = data1[jName] as? String, let phone: String = data1[jPhone] as? String, let email: String = data1[jEmail] as? String, let password: String = data1[jPassword] as? String, let oType: String = data1[jOrganizationType] as? String {
                    GFunction.user = UserModel(docID: docId, name: name, mobile: phone, email: email, password: password, organizationType: oType, userType: userType)
                }
                GFunction.shared.firebaseRegister(data: email)
                if self.index == 0 {
                    UIApplication.shared.setEmp()
                }else if self.index == 1 {
                    UIApplication.shared.setSeeker()
                }
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}

