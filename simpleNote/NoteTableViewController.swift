//
//  NoteTableViewController.swift
//  simpleNote
//
//  Created by Ani on 11/4/19.
//  Copyright © 2019 Ani. All rights reserved.
//

import UIKit
import CoreData

class NoteTableViewController: UITableViewController, UISearchBarDelegate {
    
    var notename = UITextField()
    var notedescription = UITextField()
    var notes = [Note]()
    var managedOjetContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    @IBAction func addNewNote(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewControllerID")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ViewControllerID") as! ViewController
        vc.note = notes[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TableViewCell
        let note: Note = notes[indexPath.row]
        cell.configureCell(note: note)
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func getData() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try self.managedOjetContext!.fetch(request)
            tableView.reloadData()
        }
        catch {
            print("Could not fetch notes from CoreData")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = UIApplication.appDelegate.persistentContainer.viewContext
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            context.delete(note)
            UIApplication.appDelegate.saveContext()
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            do {
                notes = try self.managedOjetContext!.fetch(request)
                tableView.reloadData()
            }
            catch {
                print("Could not fetch notes from CoreData")
            }
            tableView.reloadData()
        }
    }
}
