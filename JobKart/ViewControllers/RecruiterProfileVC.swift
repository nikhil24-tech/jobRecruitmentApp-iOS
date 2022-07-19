//
//  RecruiterProfileVC.swift
//  JobKart


import UIKit



class RecruiterProfileVC: UIViewController {

    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnUnBlock: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRole: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDesription: UILabel!
    @IBOutlet weak var lblRequirements: UILabel!
    @IBOutlet weak var lblContactInfo: UILabel!
    @IBOutlet weak var lblAddressInfo: UILabel!
    
    @IBAction func btnClick(_ sender: UIButton) {
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

}
