//
//  UserController.swift
//  CloudKitUsers
//
//  Created by Collin Cannavo on 6/21/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation
import CloudKit


class UserController {

    static let shared = UserController()
    let currentUserWasSetNotification = Notification.Name("currentUserWasSet")
    var currentUser: User? {
        didSet {
            print("Current user was set")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.currentUserWasSetNotification, object: nil)
            }
        }
    }
    func createUser(username: String, email: String, age: String) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("There was an error"); return }
            guard let appleUserRecordID = appleUserRecordID else { return }
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .none)
            let user = User(username: username, email: email, age: age, appleUserReference: appleUserReference)
            CKContainer.default().publicCloudDatabase.save(user.cloudKitRecord, completionHandler: { (record, error) in
                if let error = error { print(error.localizedDescription) }
                self.currentUser = user
            })
        }
    }
    func fetchCurrentUser() {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
             print(error.localizedDescription)
            }
            guard let appleUserRecordID = appleUserRecordID else { return }
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .none)
    // String format specifier is from Objective C  which is the 'recordID == %@' and you can look it up in the Apple Guide
            let predicate = NSPredicate(format: "appleUserReference == %@", appleUserReference)
            let query = CKQuery(recordType: User.recordType, predicate: predicate)
            CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                // We should get back only 1 record, but it comes back in an array. The .first will grab whatever is in that array. Even if it isn't in the array it won't crash the app
                guard let currentUserRecord = records?.first,
                    let currentUser = User(cloudKitRecord: currentUserRecord)
                else { return }
                self.currentUser = currentUser
            })
        }
    }
}










