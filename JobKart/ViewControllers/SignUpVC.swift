//
//  SignUpVC.swift
//  JobKart
//
//  Created by 2022M3 on 07/07/22.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtOType: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtCPassword: UITextField!
    
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: BlueThemeButton!
    
    
    var index = 0
    var flag: Bool = true
    var socialData: SocialLoginDataModel!
    
    
    @IBAction func btn(_ sender: UIButton) {
        if sender == btnSignIn {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
                vc.index = index
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnSignUp {
            self.flag = false
            let userType = (index == 1) ? jJSeeker : jEmp
            
            let error = self.validation(name: self.txtName.text ?? "", email: self.txtEmail.text ?? "", phone: self.txtPhone.text ?? "", Otype: self.txtOType.text ?? "", password: self.txtPassword.text ?? "", confirmPass: self.txtCPassword.text ?? "")
            
            if error.isEmpty {
                self.getExistingUser(name: self.txtName.text ?? "", email: self.txtEmail.text ?? "", mobile: self.txtPhone.text ?? "", password: self.txtPassword.text ?? "", organizationType: self.txtOType.text ?? "", userType: userType)
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }
    }
    
    
    private func validation(name: String,email:String,phone:String,Otype:String,password:String,confirmPass:String) -> String {
        if name.isEmpty{
            return STRING.errorEnterName
        }else if email.isEmpty{
            return STRING.errorEmail
        }else if !Validation.isValidEmail(email){
            return STRING.errorValidEmail
        }else if phone.isEmpty{
            return STRING.errorMobile
        }else if !Validation.isValidPhoneNumber(phone) {
            return STRING.errorValidMobile
        }else if Otype.isEmpty {
            return STRING.errorOType
        }else if password.isEmpty {
            return STRING.errorPassword
        } else if password.count < 8 {
            return STRING.errorPasswordCount
        } else if !Validation.isValidPassword(password) {
            return STRING.errorValidCreatePassword
        } else if confirmPass.isEmpty {
            return STRING.errorConfirmPassword
        } else if password != confirmPass {
            return STRING.errorPasswordMismatch
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
            self.txtName.text = "\(socialData.firstName ?? "") \(socialData.lastName ?? "")"
            self.txtEmail.text = socialData.email
            self.txtEmail.isUserInteractionEnabled = false
        }
        // Do any additional setup after loading the view.
    }

}


//MARK:- Extension for Login Function
extension SignUpVC {

    func createAccount(name: String, email: String, mobile: String, password: String, organizationType: String, usertType: String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(jUser).addDocument(data:
            [
              jPhone: mobile,
              jEmail: email,
              jName: name,
              jPassword : password,
              jOrganizationType:  organizationType,
              jUserType: usertType
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                GFunction.shared.firebaseRegister(data: email)
                GFunction.user = UserModel(docID: ref?.documentID ?? "", name: name,  mobile: mobile, email: email, password: password, organizationType: organizationType,userType: usertType)
                    
                if let vc = UIStoryboard.main.instantiateViewController(withClass: CreateProfileVC.self){
                    vc.index = self.index
                    vc.email = email
                    vc.phone = mobile
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                self.flag = true
            }
        }
    }

    func getExistingUser(name: String, email: String, mobile: String, password: String, organizationType:String,userType:String) {

        _ = AppDelegate.shared.db.collection(jUser).whereField(jEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            if snapshot.documents.count == 0 {
                self.createAccount(name: name, email: email, mobile: mobile, password: password, organizationType: organizationType, usertType: userType)
                self.flag = true
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Email is already exist !!!", completion: nil)
                    self.flag = true
                }
            }
        }
    }
}
