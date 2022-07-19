//
//  SearchVC.swift
//  JobKart


import UIKit

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if GFunction.user.userType == jEmp {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell
            let data = self.arrData[indexPath.row]
            cell.configCell(data: data)
            let tap = UITapGestureRecognizer()
            tap.addAction {
                if let vc = UIStoryboard.main.instantiateViewController(withClass: JobDetailsVC.self){
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            cell.vwMain.isUserInteractionEnabled = true
            cell.vwMain.addGestureRecognizer(tap)
            
            cell.btnsave.addAction(for: .touchUpInside) {
                self.isFav = false
                Alert.shared.showAlert("JobCart", actionOkTitle: "Save", actionCancelTitle: "Cancel", message: "Are you sure you want to save this job?") { Bool in
                    if Bool {
                        self.checkAddToSave(data: data, email: GFunction.user.email)
                    }
                }
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchSeekerCell", for: indexPath) as! SearchSeekerCell
        cell.configCell(data: self.arrData[indexPath.row])
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: JobDetailsVC.self){
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        cell.vwMain.isUserInteractionEnabled = true
        cell.vwMain.addGestureRecognizer(tap)
        
        return cell
    }
    
    
    func savejobs(data: PostModel, email:String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(jJobSave).addDocument(data:
                                                                        [
                                                                            "job_address": data.job_address,
                                                                            "job_name" : data.job_name,
                                                                            "job_oType": data.job_oType,
                                                                            "job_email": data.job_email,
                                                                            "address": data.address,
                                                                            "job_salary" : data.job_salary,
                                                                            "description" : data.description,
                                                                            "requirement" : data.requirement,
                                                                            "user_email" : email,
                                                                            "fav_id": data.docID
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
        _ = AppDelegate.shared.db.collection(jJobSave).whereField("user_email", isEqualTo: email).whereField("fav_id", isEqualTo: data.docID).addSnapshotListener{ querySnapshot, error in
            
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

    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnCategory: UIButton!
    @IBOutlet weak var sbBar: UISearchBar!
    
    var array = [PostModel]()
    var arrData = [PostModel]()
    var isFav : Bool = true
    var pendingItem: DispatchWorkItem?
    var pendingRequest: DispatchWorkItem?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GFunction.user.userType == jEmp ? self.getEmpData() : self.getData()
        
        self.vwSearch.layer.cornerRadius = 23.0
        
        if let textfield = sbBar.value(forKey: "searchField") as? UITextField {
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.backgroundColor : UIColor.clear])
            textfield.backgroundColor = UIColor.hexStringToUIColor(hex: "#EFEEEE")
            textfield.borderStyle = .none
            if GFunction.user.userType == jEmp {
                self.getEmpData()
                textfield.placeholder = "Designer"
            }else {
                self.getData()
                textfield.placeholder = "Job Title, Keywords, or Company"
            }
            UITextField.appearance(whenContainedInInstancesOf: [type(of: sbBar)]).tintColor = .black
        }
        DispatchQueue.main.async {
            self.btnCategory.layer.cornerRadius = self.btnCategory.frame.height/2
        }
        // Do any additional setup after loading the view.
    }
    
    
    func getData() {
        _ = AppDelegate.shared.db.collection(jJobs).whereField("user_email", isEqualTo: GFunction.user.email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if  let job_address: String = data1["job_address"] as? String,
                        let job_name: String = data1["job_name"] as? String,
                        let job_oType: String = data1["job_oType"] as? String,
                        let job_email: String = data1["job_email"] as? String,
                        let address: String = data1["address"] as?  String,
                        let job_salary: String = data1["job_salary"] as? String,
                        let description: String = data1["description"] as? String,
                        let requirement: String = data1["requirement"] as? String,
                        let user_email: String = data1["user_email"] as? String
                    {
                    self.array.append(PostModel(docId: data.documentID, job_address: job_address, job_name: job_name, job_oType: job_oType, job_email: job_email, address: address, job_salary: job_salary, description: description, requirement: requirement, user_email: user_email))
                    }
                }
                
                self.arrData = self.array
                self.sbBar.delegate = self
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    func getEmpData() {
        _ = AppDelegate.shared.db.collection(jJobs).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if  let job_address: String = data1["job_address"] as? String,
                        let job_name: String = data1["job_name"] as? String,
                        let job_oType: String = data1["job_oType"] as? String,
                        let job_email: String = data1["job_email"] as? String,
                        let address: String = data1["address"] as?  String,
                        let job_salary: String = data1["job_salary"] as? String,
                        let description: String = data1["description"] as? String,
                        let requirement: String = data1["requirement"] as? String,
                        let user_email: String = data1["user_email"] as? String
                    {
                    self.array.append(PostModel(docId: data.documentID, job_address: job_address, job_name: job_name, job_oType: job_oType, job_email: job_email, address: address, job_salary: job_salary, description: description, requirement: requirement, user_email: user_email))
                    }
                }
                
                
                self.arrData = self.array
                self.tblList.delegate = self
                self.sbBar.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
}



class SearchCell: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnsave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 23.0
        DispatchQueue.main.async {
            self.btnApply.layer.cornerRadius = self.btnApply.frame.height/2
            self.btnHours.layer.cornerRadius = self.btnHours.frame.height/2
            self.btnsave.layer.cornerRadius = self.btnsave.frame.height/2
        }
    }
    
    func configCell(data: PostModel) {
        self.lblName.text = data.job_name.description
        self.lblAddress.text = data.job_address.description
        self.btnHours.setTitle(data.job_salary, for: .normal)
        self.lblOName.text = data.job_oType.description
    }
}


class SearchSeekerCell: UITableViewCell {
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnHours: UIButton!
    @IBOutlet weak var btnsave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.layer.cornerRadius = 23.0
        DispatchQueue.main.async {
            self.btnHours.layer.cornerRadius = self.btnHours.frame.height/2
            self.btnsave.layer.cornerRadius = self.btnsave.frame.height/2
        }
    }
    
    func configCell(data: PostModel) {
        self.lblName.text = data.job_name.description
        self.lblAddress.text = data.job_address.description
        self.btnHours.setTitle(data.job_salary, for: .normal)
        self.lblOName.text = data.job_oType.description
    }
}


//MARK:- UISearchBarDelegate Delegate methods :-
extension SearchVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.pendingRequest?.cancel()
        
        guard searchBar.text != nil else {
            return
        }
        
        if(searchText.count == 0 || (searchText == " ")){
            self.arrData = self.array
            self.tblList.reloadData()
            return
        }
        
        //self.isTextEdit = true
        
        self.pendingRequest = DispatchWorkItem{ [weak self] in
            
            guard let self = self else { return }
            
            self.arrData = self.array.filter({$0.job_name.localizedStandardContains(searchText)})
            self.tblList.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: self.pendingRequest!)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.arrData = self.array.filter({$0.job_name.localizedStandardContains(searchBar.text!)})
        self.tblList.reloadData()
        self.sbBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.arrData = self.array
        self.sbBar.resignFirstResponder()
    }
}
