//
//  HomeSeekerVC.swift
//  JobKart


import UIKit

class HomeSeekerVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSeekerCell", for: indexPath) as! SearchSeekerCell
        cell.configCell(data: self.array[indexPath.row])
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: JobDetailsVC.self){
                vc.isSeeker =  true
                vc.data = self.array[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        cell.vwMain.isUserInteractionEnabled = true
        cell.vwMain.addGestureRecognizer(tap)
        
        return cell
    }
    

    @IBOutlet weak var tblList: UITableView!
    
    var array = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getData()

        // Do any additional setup after loading the view.
    }
    
    
    
    func getData() {
        _ = AppDelegate.shared.db.collection(jJobs).addSnapshotListener{ querySnapshot, error in
            
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
                        let job_oType: String = data1[jOrgType] as? String,
                        //                        let job_email: String = data1[jJobEmail] as? String,
                        let address: String = data1[jLocation] as?  String,
                        let job_salary: String = data1[jJobSalary] as? String,
                        let description: String = data1[jJobDescription] as? String,
                        let requirement: String = data1[jRequirement] as? String,
                        let emp_email: String = data1[jEmpEmail] as? String,
                        let emp_Phone: String = data1[jPhone] as? String
                            
                    {
                    self.array.append(PostModel(docId: data.documentID, job_address: job_address, job_name: job_name, job_oType: job_oType, job_email:  data1[jJobEmail] as? String ?? "", address: address, job_salary: job_salary, description: description, requirement: requirement, user_email: emp_email,user_Phone: emp_Phone,uid: data1[jUID] as? String ?? "",favID: ""))
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
