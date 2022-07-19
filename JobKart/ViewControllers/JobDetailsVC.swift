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
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnApplyJob {
            Alert.shared.showAlert(message: "Under Development", completion: nil)
        }else if sender == btnSaveJob {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.btnSaveJob.layer.cornerRadius = self.btnSaveJob.frame.height/2
            self.btnApplyJob.layer.cornerRadius = self.btnApplyJob.frame.height/2
            self.btnHours.layer.cornerRadius = self.btnHours.frame.height/2
        }
        self.vwMain.layer.cornerRadius = 23
        // Do any additional setup after loading the view.
    }
}
