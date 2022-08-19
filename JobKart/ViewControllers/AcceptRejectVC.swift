//
//  AcceptRejectVC.swift


import UIKit

class AcceptRejectVC: UIViewController {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAboutme: UILabel!
    @IBOutlet weak var lblSkills: UILabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnApproved: UIButton!
    
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnReject {
            self.updateData(docID: data.docID, isAccept: false)
        }else if sender == btnApproved {
            self.updateData(docID: data.docID, isAccept: true)
        }
    }
    
    
    var data: ApplyModel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if data != nil {
            self.lblName.text = data.empName.description
            self.lblEmail.text = data.empEmail.description
            self.lblAddress.text = data.address.description
            self.lblPhone.text  = data.empPhone.description
            self.lblAboutme.text = data.job_aboutme.description
            self.lblSkills.text = data.job_Skills.description
            
            if data.isRejected || data.isApproved {
                self.btnReject.isHidden = true
                self.btnApproved.isHidden = true
            }
        }
        
        self.btnReject.layer.cornerRadius = 10.0
        self.btnApproved.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
    
    func updateData(docID: String, isAccept: Bool) {
        
        let ref = AppDelegate.shared.db.collection(jApplyJobs).document(docID)
        
        var data = [String:Bool]()
        if isAccept {
            data = [
                jIsApproved: true
            ]
        }else{
            data = [
                jIsRejected: true
            ]
        }
        
        
        ref.updateData(data){  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
