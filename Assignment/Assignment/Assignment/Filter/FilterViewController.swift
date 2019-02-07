//
//  FilterViewController.swift
//  Assignment
//
//  Created by Amrita Ghosh on 06/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import UIKit
import CoreData

public protocol FilterViewControllerDelegate {
    func applyFilter(_ section: Int16, filter: Int64)
}

class FilterViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    open var delegate: FilterViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    func updateUI() {
        SystemManager.sharedManager.showLoadingIndicatorScreen()
        self.fetchAndPopulateView()
    }

    
    // MARK: - API Call
    
    func fetchAndPopulateView () {
        DownSyncManager.sharedManager.fetchFilterList() { (responseObject, loginError) in

            DispatchQueue.main.async(execute: {
                SystemManager.sharedManager.dismissLoadingIndicatorScreen()
                if (loginError != nil) {
                    let alertController = AlertController.init(title: "", body: AlertMessages.Authentication.badCredentials, dismissHandler:{
                        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    })
                    alertController.show(true, completion: nil)
                    return
                }
                self.displayView()
            })

        }
        
    }
    
    func displayView() {
        if((self.fetchedResultsController.fetchedObjects?.count)! > 0) {
            self.tableView.reloadData()
            return
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            return self.fetchedResultsController.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerView = tableView.dequeueReusableCell(withIdentifier: "kFilterHeaderView") as! FilterHeaderView
        let filterList = self.fetchedResultsController.object(at: IndexPath(item: 0, section: section))
        headerView.title.text = filterList.sectionName
        return headerView.contentView
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kFilterListCell") as! FilterListCell
        cell.separatorInset = UIEdgeInsets.zero
        self.configureCellUsingModel(cell, at: indexPath)
        return cell
    }
    
    
    func configureCellUsingModel(_ cell: FilterListCell, at indexPath: IndexPath) {
        let filterList = self.fetchedResultsController.object(at: indexPath)
        cell.configureCellUsingModel(filterList)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filterList = self.fetchedResultsController.object(at: indexPath)
        self.delegate?.applyFilter(self.fetchedResultsController.object(at: IndexPath(item: 0, section: indexPath.section)).filterNo, filter: filterList.filterId)
        _ = self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Filter> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Filter> = Filter.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 10
        
        // Edit the sort key as appropriate.
        let sortDescriptorSection = NSSortDescriptor(key: "filterNo", ascending: true)
        let sortDescriptorFilterName = NSSortDescriptor(key: "filterName", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptorSection,sortDescriptorFilterName]
        
        fetchRequest.predicate = NSPredicate.init(format: "isFetching = %i", 1)
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStackManager.sharedManager.viewContext, sectionNameKeyPath: "filterNo", cacheName: nil)
        _fetchedResultsController = aFetchedResultsController
        _fetchedResultsController?.delegate = self
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
    
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Filter>? = nil
    
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
                if let cell = self.tableView.cellForRow(at: indexPathOfChange) as? FilterListCell {
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

}
