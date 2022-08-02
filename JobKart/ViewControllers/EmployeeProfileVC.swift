//
//  EmployeeProfileVC.swift
//  JobKart

import UIKit

class EmployeeProfileVC: UIViewController {

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnUnBlock: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblSkills: UILabel!
    @IBOutlet weak var lblAboutMe: UILabel!
    @IBOutlet weak var lblExp: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var data: UserDataModel!
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnBlock {
            self.blockData(uid: data.docID, isBlock: true)
        }else if sender == btnUnBlock {
            self.blockData(uid: data.docID, isBlock: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.vwMain.layer.cornerRadius = 23.0
            self.btnBlock.layer.cornerRadius = self.btnBlock.frame.height/2
            self.btnUnBlock.layer.cornerRadius = self.btnUnBlock.frame.height/2
        }
        // Do any additional setup after loading the view.
    }
    
    
    func blockData(uid: String,isBlock: Bool) {
        let ref = AppDelegate.shared.db.collection(jUser).document(uid)
        ref.updateData([
            jIsBlock: isBlock,
        ]){  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}