//
//  SavedJobVC.swift
//  JobKart

import UIKit

class SavedJobVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveJobCell", for: indexPath) as! SaveJobCell
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        
        cell.btnUnsaved.addAction(for: .touchUpInside) {
            Alert.shared.showAlert("JobCart", actionOkTitle: "Remove", actionCancelTitle: "Cancel", message: "Are you sure you want to remove this job from save?") { Bool in
                if Bool {
                    self.removeFromPost(data: data)
                }
            }
        }
        return cell
    }
    
    
    func removeFromPost(data: PostModel){
        let ref = AppDelegate.shared.db.collection(jJobSave).document(data.docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
                UIApplication.shared.setEmp()
            }
        }
    }

    @IBOutlet weak var tblList: UITableView!
    
    var array = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(jJobSave).whereField(jUID, isEqualTo: GFunction.user.docID).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if  let job_address: String = data1[jJobAddress] as? String,
                        let job_name: String = data1[jPostName] as? String,
                        let job_oType: String = data1[jJobOType] as? String,
                        let job_email: String = data1[jJobEmail] as? String,
                        let address: String = data1[jAddress] as?  String,
                        let job_salary: String = data1[jJobSalary] as? String,
                        let description: String = data1[jDescription] as? String,
                        let requirement: String = data1[jRequirement] as? String,
                        let user_email: String = data1[jUserEmail] as? String,
                        let uid: String = data1[jUID] as? String,
                        let favid: String = data1[jFavID] as? String
                    {
                    self.array.append(PostModel(docId: data.documentID, job_address: job_address, job_name: job_name, job_oType: job_oType, job_email: job_email, address: address, job_salary: job_salary, description: description, requirement: requirement, user_email: user_email,uid: uid,favID: favid))
                    }
                }
                
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}



class SaveJobCell: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnUnsaved: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 23.0
        DispatchQueue.main.async {
            self.btnApply.layer.cornerRadius = self.btnApply.frame.height/2
            self.btnHours.layer.cornerRadius = self.btnHours.frame.height/2
            self.btnUnsaved.layer.cornerRadius = self.btnUnsaved.frame.height/2
        }
    }
    
    func configCell(data: PostModel) {
        self.lblName.text = data.job_name.description
        self.lblAddress.text = data.job_address.description
        self.btnHours.setTitle(data.job_salary, for: .normal)
        self.lblOName.text = data.job_oType.description
    }
}
