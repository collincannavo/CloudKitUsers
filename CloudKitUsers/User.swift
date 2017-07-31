//
//  User.swift
//  CloudKitUsers
//
//  Created by Collin Cannavo on 6/21/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit


class User {

    static private let usernameKey = "username"
    static private let emailKey = "email"
    static private let ageKey = "age"
    static let appleUserReferenceKey = "appleUserReference"
    static let recordType = "user"
    
    var username: String
    var email: String
    var age: String
    
    // this is the reference to the pre-made Apple 'Users' record
    let appleUserReference: CKReference
    
    init(username: String, email: String, age: String, appleUserReference: CKReference) {
        
        self.username = username
        self.email = email
        self.age = age
        self.appleUserReference = appleUserReference
        
    }
    
    //This is like dictionaryRepresentation for Networking, but for CloudKit. This is the only way the database can read the record and save it to our store.
  
    var cloudKitRecord: CKRecord {
        let record = CKRecord(recordType: User.recordType)
    
    //setValue is what creates the object's properties for CKRecord to save
        record.setValue(username, forKey: User.usernameKey)
        record[User.emailKey] = email as CKRecordValue
        record.setValue(age, forKey: User.ageKey)
        record.setValue(appleUserReference, forKey: User.appleUserReferenceKey)
        
        return record
    }
    
   convenience init?(cloudKitRecord: CKRecord) {
     
        guard let username = cloudKitRecord[User.usernameKey] as? String,
            let email = cloudKitRecord[User.emailKey] as? String,
            let age = cloudKitRecord[User.ageKey] as? String,
            let appleUserReference = cloudKitRecord[User.appleUserReferenceKey] as? CKReference
            else  { return nil }
        
        self.init(username: username, email: email, age: age, appleUserReference: appleUserReference)
        
    }
    
}


// This accomplishes the same thing as var cloudKitRecord
extension CKRecord {
    
    convenience init(user: User) {
        
        // self.init is what creates the record and then setValue is what puts 'inside' the record the things you need to save
        self.init(recordType: User.recordType)
        
        self.setValue(user.username, forKey: "username")
        self.setValue(user.email, forKey: "email")
        self.setValue(user.age, forKey: "age")
        self.setValue(user.appleUserReference, forKey: "appleUserReference")
        
    }
    
}










