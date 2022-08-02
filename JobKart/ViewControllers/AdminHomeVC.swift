//
//  AdminHomeVC.swift
//  JobKart


import UIKit

class AdminHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblJobList: UITableView!
    
    var arrData = [PostModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSeekerCell", for: indexPath) as! SearchSeekerCell
        cell.configCell(data: self.arrData[indexPath.row])
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: JobDetailsVC.self){
                vc.isFromAdmin =  true
                vc.data = self.arrData[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        cell.vwMain.isUserInteractionEnabled = true
        cell.vwMain.addGestureRecognizer(tap)
        
        return cell
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(jJobs).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arrData.removeAll()
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
                        let uid: String = data1[jUID] as? String
                    {
                    self.arrData.append(PostModel(docId: data.documentID, job_address: job_address, job_name: job_name, job_oType: job_oType, job_email: job_email, address: address, job_salary: job_salary, description: description, requirement: requirement, user_email: user_email,uid: uid,favID: ""))
                    }
                }
                self.tblJobList.delegate = self
                self.tblJobList.dataSource = self
                self.tblJobList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }

}
