//
//  AddPostVC.swift
//  JobKart

import UIKit

class AddPostVC: UIViewController {

    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtOAddress: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtOType: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtSalary: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtRequirments: UITextField!
    @IBOutlet weak var btnPost: BlueThemeButton!
    
    
    var flag = true
    
    
    private func validation(name: String, oAddress:String, email:String, Otype:String, address:String, salary:String ,description:String, requirement:String ) -> String {
        if name.isEmpty{
            return STRING.errorEnterJobName
        }else if email.isEmpty{
            return STRING.errorEnterJobEmail
        }else if !Validation.isValidEmail(email){
            return STRING.errorValidEmail
        }else if Otype.isEmpty {
            return STRING.errorOType
        }else if oAddress.isEmpty{
            return STRING.errorEnterJobAddress
        }else if salary.isEmpty {
            return STRING.errorEnterJobSalary
        } else if description.isEmpty {
            return STRING.errorEnterJobDescription
        } else if requirement.isEmpty {
            return STRING.errorEnterJobRequirement
        }
        return ""
        
    }
    
    
    @IBAction func btnClick(_ sender: UIButton){
        if sender == btnPost {
            let error = self.validation(name: self.txtname.text?.trim() ?? "", oAddress: self.txtOAddress.text?.trim() ?? "", email: self.txtEmail.text?.trim() ?? "", Otype: self.txtOType.text?.trim() ?? "", address: self.txtAddress.text?.trim() ?? "", salary: self.txtSalary.text?.trim() ?? "", description: self.txtDescription.text?.trim() ?? "", requirement: self.txtRequirments.text?.trim() ?? "")
            
            if error.isEmpty {
                self.flag = false
                self.addCreateData(name: self.txtname.text?.trim() ?? "", oAddress: self.txtOAddress.text?.trim() ?? "", email: self.txtEmail.text?.trim() ?? "", Otype: self.txtOType.text?.trim() ?? "", address: self.txtAddress.text?.trim() ?? "", salary: self.txtSalary.text?.trim() ?? "", description: self.txtDescription.text?.trim() ?? "", requirement: self.txtRequirments.text?.trim() ?? "", user_Email: GFunction.user.email ?? "")
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addCreateData(name: String, oAddress:String, email:String, Otype:String, address:String, salary:String ,description:String, requirement:String, user_Email: String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(jJobs).addDocument(data:
                                                                            [
                                                                                "job_address": oAddress,
                                                                                "job_name" : name,
                                                                                "job_oType": Otype,
                                                                                "job_email": email,
                                                                                "address": address,
                                                                                "job_salary" : salary,
                                                                                "description" : description,
                                                                                "requirement" : requirement,
                                                                                "user_email" : user_Email
                                                                            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Job post added successfully !!!") { Bool in
                    if Bool {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

