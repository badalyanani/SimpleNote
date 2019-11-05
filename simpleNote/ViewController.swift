//
//  ViewController.swift
//  simpleNote
//
//  Created by Ani on 11/4/19.
//  Copyright © 2019 Ani. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    weak var note: Note?
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = note?.noteDescripton
        nameLabel.text = note?.noteName
        view.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
    
    //MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameLabel.text == "" || nameLabel.text == "Note" || descriptionLabel.text == "" || descriptionLabel.text == "Description" {
            
            let alertController = UIAlertController(title: "Missing Information", message:"You left one or more fields empty. Please make sure that all fields are filled before attempting to save.", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            if let note = note {
                saveText(notesID: note.objectID, info: descriptionLabel.text)
                self.navigationController!.popViewController(animated: true)
            }
            else {
                let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: UIApplication.appDelegate.persistentContainer.viewContext) as! Note
                note.noteName = nameLabel.text
                note.noteDescripton = descriptionLabel.text
                UIApplication.appDelegate.saveContext()
                UIApplication.appDelegate.persistentContainer.viewContext.refreshAllObjects()
                note.noteName = nameLabel.text
                note.noteDescripton = descriptionLabel.text
                UIApplication.appDelegate.saveContext()
                
                saveToCoreData() {
                    let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                    if isPresentingInAddFluidPatientMode {
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        self.navigationController!.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
     func textViewDidBeginEditing(_ textView: UITextView) {
          if (textView.text == "Description") {
              textView.text = ""
          }
      }
    
    func saveText(notesID: NSManagedObjectID, info text: String) {
        let note = UIApplication.appDelegate.persistentContainer.viewContext.object(with: notesID) as! Note
        note.noteDescripton = text
        UIApplication.appDelegate.saveContext()
        UIApplication.appDelegate.persistentContainer.viewContext.refreshAllObjects()
    }
    
    //MARK: - Private Interface
    private func saveToCoreData(complition: @escaping ()-> Void) {
        managedObjectContext?.perform {
            do {
                try self.managedObjectContext?.save()
                complition()
                print("Note saved to Core Data")
            }
            catch _ {
                print("could not save to Core Data")
            }
        }
    }
}

