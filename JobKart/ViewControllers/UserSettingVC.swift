//
//  UserSettingVC.swift
//  JobKart


import UIKit

class UserSettingVC: UIViewController {

    @IBOutlet weak var btnEditProfile: BlueThemeButton!
    @IBOutlet weak var btnChangePassword: BlueThemeButton!
    @IBOutlet weak var btnSignOut: BlueThemeButton!
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignOut {
            UIApplication.shared.setStart()
        }else if sender == btnEditProfile {
            if GFunction.user.userType == jJSeeker {
                if let vc = UIStoryboard.main.instantiateViewController(withClass: EditSeekarProfile.self) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if let vc = UIStoryboard.main.instantiateViewController(withClass: EditEMPProfileVC.self) {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else if sender == btnChangePassword {
            Alert.shared.showAlert(message: "Under Development", completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
