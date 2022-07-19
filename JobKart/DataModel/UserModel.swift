//
//  UserModel.swift
//  JobKart


import Foundation


class UserModel {
    var docID: String
    var name: String
    var mobile: String
    var organizationType: String
    var email: String
    var password: String
    var userType: String
    
    init(docID: String,name: String,mobile: String,email: String, password:String, organizationType: String,userType: String){
        self.docID = docID
        self.name = name
        self.email = email
        self.mobile = mobile
        self.password = password
        self.organizationType = organizationType
        self.userType = userType
    }
}
