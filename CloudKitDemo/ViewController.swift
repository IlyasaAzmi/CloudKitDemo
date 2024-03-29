//
//  ViewController.swift
//  CloudKitDemo
//
//  Created by Ilyasa Azmi on 24/09/19.
//  Copyright © 2019 Ilyasa Azmi. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    let privateDatabase = CKContainer.default().privateCloudDatabase

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func saveButton(_ sender: Any) {
        let title = textField.text!
        
        let record = CKRecord(recordType: "Note")
        
        record.setValue(title, forKey: "title")
        
        privateDatabase.save(record) { (savedRecord, error) in
            
            if error == nil {
                
                print("Record Saved")
                
            } else {
                
                print("Record Not Saved")
                
            }
            
        }
    }
    
    @IBAction func retrieveButton(_ sender: Any) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Note", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "modificationDate", ascending: false)]
        
        let operation = CKQueryOperation(query: query)
        
        titles.removeAll()
        recordIDs.removeAll()
        
        operation.recordFetchedBlock = { record in
            
            titles.append(record["title"]!)
            recordIDs.append(record.recordID)
            
        }
        
        operation.queryCompletionBlock = { cursor, error in
            
            DispatchQueue.main.async {
                
                print("Titles: \(titles)")
                print("RecordIDs: \(recordIDs)")
                
            }
            
        }
        
        privateDatabase.add(operation)
    }
    
    @IBAction func updateButton(_ sender: Any) {
        let newTitle = "Anything But The Old Title"
        
        let recordID = recordIDs.first!
        
        privateDatabase.fetch(withRecordID: recordID) { (record, error) in
            
            if error == nil {
                
                record?.setValue(newTitle, forKey: "title")
                
                self.privateDatabase.save(record!, completionHandler: { (newRecord, error) in
                    
                    if error == nil {
                        
                        print("Record Saved")
                        
                    } else {
                        
                        print("Record Not Saved")
                        
                    }
                    
                })
                
            } else {
                
                print("Could not fetch record")
                
            }
            
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let recordID = recordIDs.first!
        
        privateDatabase.delete(withRecordID: recordID) { (deletedRecordID, error) in
            
            if error == nil {
                
                print("Record Deleted")
                
            } else {
                
                print("Record Not Deleted")
                
            }
            
        }
    }
    
}

