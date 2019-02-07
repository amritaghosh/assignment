//
//  PlayerListViewController.swift
//  Assignment
//
//  Created by Amrita Ghosh on 06/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import UIKit
import CoreData

class PlayerListViewController: UITableViewController, NSFetchedResultsControllerDelegate, FilterViewControllerDelegate {
    
    var categoryValue: String = ""
    var skillValue: String = ""
    var buildingValue: String = ""
    var team_statusValue: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadList), name: Notification.Name(rawValue: ImageObserverKey.imageRecieved), object: nil)
        self.setupUI()
  }
    
    func setupUI() {
        SystemManager.sharedManager.showLoadingIndicatorScreen()
        self.fetchAndPopulateView(categoryValue, skill: skillValue,building: buildingValue, status: team_statusValue, isRefresh: false)
    }
    
    @objc func reloadList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
  
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func fetchAndPopulateView(_ category: String, skill: String, building: String, status: String, isRefresh: Bool) {
        DownSyncManager.sharedManager.fetchPlayerList(category, skill: skill, building: building, team_status: status, isRefresh: isRefresh) { (responseObject, loginError) in
            DispatchQueue.main.async(execute: {
                SystemManager.sharedManager.dismissLoadingIndicatorScreen()
                if (loginError != nil) {
                    return
                }
                self.displayView()
            })
            
        }
    }
    
    
    // MARK: - Display View
    
    func displayView()
    {
        if((self.fetchedResultsController.fetchedObjects?.count)! > 0) {
            self.tableView.reloadData()
            return
        }
    }
    
    @IBAction func filterButtonAction(_ sender: UIBarButtonItem) {
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let sectionInfo = self.fetchedResultsController.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kPlayerListTableViewCell") as! PlayerListTableViewCell
        cell.separatorInset = UIEdgeInsets.zero
        self.configureCellUsingModel(cell, at: indexPath)
        return cell
    }
    
    
    func configureCellUsingModel(_ cell: PlayerListTableViewCell, at indexPath: IndexPath) {
        let playerList = self.fetchedResultsController.object(at: indexPath)
        cell.configureCellUsingModel(playerList)
    }

   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<PlayerList> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<PlayerList> = PlayerList.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 10
        
        // Edit the sort key as appropriate.
        let sortDescriptorName = NSSortDescriptor(key: "name", ascending: true,  selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        fetchRequest.sortDescriptors = [sortDescriptorName]
        
        fetchRequest.predicate = NSPredicate.init(format: "isFetching = %i", 1)
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStackManager.sharedManager.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        _fetchedResultsController = aFetchedResultsController
        _fetchedResultsController?.delegate = self
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //            let nserror = error as NSError
            //            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<PlayerList>? = nil
    
    // MARK: - Fetched results controller
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            self.tableView.deleteSections([sectionIndex], with: .fade)
        default:
            break;
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPathForInsert = newIndexPath {
                self.tableView.insertRows(at: [newIndexPathForInsert], with: .fade)
            }
        case .delete:
            if let indexPathOfChange = indexPath {
                self.tableView.deleteRows(at:[indexPathOfChange], with: .fade)
            }
        case .update:
            if let indexPathOfChange = indexPath {
                if let cell = self.tableView.cellForRow(at: indexPathOfChange) as? PlayerListTableViewCell {
                    self.configureCellUsingModel(cell, at: indexPathOfChange)
                }
                
            }
            
        case .move:
            if let newIndexPathForInsert = newIndexPath,
                let indexPathOfChange = indexPath {
                self.tableView.insertRows(at: [newIndexPathForInsert], with: .fade)
                self.tableView.deleteRows(at: [indexPathOfChange], with: .fade)
            }
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        
        if controller.fetchedObjects?.count == 0 {
        }
    }
    
    func applyFilter(_ section: Int16, filter: Int64) {
        SystemManager.sharedManager.showLoadingIndicatorScreen()
        if section == 1 {
            self.fetchAndPopulateView(String(filter), skill: "", building: "", status: "", isRefresh: true)
        }
        if section == 3 {
            self.fetchAndPopulateView("", skill: String(filter), building: "", status: "", isRefresh: true)
        }
        if section == 2 {
            self.fetchAndPopulateView("", skill: "", building: String(filter), status: "", isRefresh: true)
        }
        if section == 4 {
            self.fetchAndPopulateView("", skill: "", building: "", status: String(filter), isRefresh: true)
        }

    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "kFilterList" {
            let filterViewController = segue.destination as! FilterViewController
            filterViewController.delegate = self
        }
 
    }

}
