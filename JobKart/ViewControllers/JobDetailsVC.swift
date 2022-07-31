//
//  JobDetailsVC.swift
//  JobKart

import UIKit

class JobDetailsVC: UIViewController {

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblRequirement: UILabel!
    @IBOutlet weak var lblContactInfo: UILabel!
    @IBOutlet weak var lblAddressInfo: UILabel!
    @IBOutlet weak var btnApplyJob: UIButton!
    @IBOutlet weak var btnSaveJob: UIButton!
    
    var isSeeker : Bool = false
    var isFromAdmin: Bool = false
    var isFav : Bool = true
    var data: PostModel!
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnApplyJob {
            Alert.shared.showAlert(message: "Under Development", completion: nil)
        }else if sender == btnSaveJob {
            if isFromAdmin {
                Alert.shared.showAlert("JobKart", actionOkTitle: "Delete", actionCancelTitle: "Cancel", message: "Are you sure you want to delete this job ?") { Bool in
                    self.removeFromPost(data: self.data)
                }
                
            }else{
                self.isFav = false
                self.checkAddToSave(data: data, email: GFunction.user.email )
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnSaveJob.isHidden =  isSeeker
        self.btnApplyJob.isHidden = isSeeker
        
        if self.isFromAdmin {
            self.btnSaveJob.isHidden = !isFromAdmin
            self.btnApplyJob.isHidden = isFromAdmin
            self.btnSaveJob.setTitle("Delete Job", for: .normal)
        }
        
        DispatchQueue.main.async {
            self.btnSaveJob.layer.cornerRadius = self.btnSaveJob.frame.height/2
            self.btnApplyJob.layer.cornerRadius = self.btnApplyJob.frame.height/2
            self.btnHours.layer.cornerRadius = self.btnHours.frame.height/2
        }
        self.vwMain.layer.cornerRadius = 23
        
        if data != nil {
            self.lblName.text = data.job_name.description
            self.lblOName.text = data.job_oType.description
            self.lblAddress.text = data.address.description
            self.lblDescription.text = data.description.description
            self.lblAddressInfo.text = data.job_address.description
            self.lblContactInfo.text = data.job_email.description
            self.lblRequirement.text = data.requirement.description
            self.btnHours.setTitle(data.job_salary.description, for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    func savejobs(data: PostModel, email:String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(jJobSave).addDocument(data:
                                                                        [
                                                                            jJobAddress: data.job_address,
                                                                            jPostName : data.job_name,
                                                                            jJobOType: data.job_oType,
                                                                            jJobEmail: data.job_email,
                                                                            jAddress: data.address,
                                                                            jJobSalary : data.job_salary,
                                                                            jDescription : data.description,
                                                                            jRequirement : data.requirement,
                                                                            jUserEmail : email,
                                                                            jFavID: data.docID,
                                                                            jUID: GFunction.user.docID
                                                                        ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Job has been added into Save list!!!") { (true) in
                    UIApplication.shared.setEmp()
                }
            }
        }
    }
    
    
    func checkAddToSave(data: PostModel, email:String) {
        _ = AppDelegate.shared.db.collection(jJobSave).whereField(jUserEmail, isEqualTo: email).whereField(jFavID, isEqualTo: data.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count == 0 {
                self.isFav = true
                self.savejobs(data: data,email: email)
            }else{
                if !self.isFav {
                    Alert.shared.showAlert(message: "Job has been already existing into Save list!!!", completion: nil)
                }
                
            }
        }
    }
    
    func removeFromPost(data: PostModel){
        let ref = AppDelegate.shared.db.collection(jJobs).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
