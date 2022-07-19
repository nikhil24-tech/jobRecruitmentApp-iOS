//
//  PostModel.swift
//  JobKart


import Foundation


class PostModel {
    var docID: String
    var job_address: String
    var job_name: String
    var job_oType: String
    var job_email: String
    var address: String
    var job_salary: String
    var description: String
    var requirement: String
    var user_email: String
    
    init(docId: String, job_address: String, job_name : String, job_oType: String, job_email: String, address: String, job_salary : String, description : String, requirement : String, user_email : String){
        self.job_name = job_name
        self.job_address = job_address
        self.job_oType = job_oType
        self.job_email = job_email
        self.address = address
        self.description = description
        self.job_salary = job_salary
        self.requirement = requirement
        self.user_email = user_email
        self.docID = docId
    }
}
