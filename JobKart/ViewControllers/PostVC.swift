//
//  PostVC.swift
//  JobKart


import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var btnAdDPost: BlueThemeButton!
    @IBOutlet weak var btnEditPost: BlueThemeButton!
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnAdDPost {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddPostVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnEditPost {
            Alert.shared.showAlert(message: "Under Development", completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
