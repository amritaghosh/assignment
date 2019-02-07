//
//  SystemManager.swift
//  Assignment
//
//  Created by Amrita Ghosh on 05/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//


import UIKit
import CoreData

class SystemManager: NSObject {
    
    static let sharedManager = SystemManager()
    var loadingView : UIView?
  
    
    static var coreDataOpeartionQueue: OperationQueue = {
        let queue = OperationQueue()
        
        queue.name = "CoreData Opeartion Queue"
        
        return queue
    }()
    
    
    private override init() {
        super.init()
    } //This prevents others from using the default '()' initializer for this class.
    
 
    func deletePlayerList(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PlayerList")
        
        if #available(iOS 11.0, *) {
            let result = try? CoreDataStackManager.sharedManager.managedObjectContext.fetch(request)
            let resultData = result as! [PlayerList]
            
            for object in resultData {
                CoreDataStackManager.sharedManager.managedObjectContext.delete(object)
            }
            do {
                try CoreDataStackManager.sharedManager.managedObjectContext.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        } else {
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request )
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            batchDeleteRequest.affectedStores = CoreDataStackManager.sharedManager.managedObjectContext.persistentStoreCoordinator?.persistentStores
            do {
                let batchDeleteResult = try CoreDataStackManager.sharedManager.managedObjectContext.execute(batchDeleteRequest) as! NSBatchDeleteResult
                if let objectIDArray = batchDeleteResult.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey : objectIDArray]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [CoreDataStackManager.sharedManager.managedObjectContext])
                }
            }
            catch {
                //    print(error)
            }
        }
    }
    func setToken(_ name: String) {
        UserDefaults.standard.set(name, forKey: UserDefaultKeys.loginToken)
    }
    
    func getToken() -> String? {
        guard let token = UserDefaults.standard.value(forKey: UserDefaultKeys.loginToken) as? String else { return nil }
        return token
    }
   
  
    
    // MARK: - Authentication Validations
    
    func isTextFieldEmpty(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        return false
    }
    
    func textFieldCharacterCount(_ textField: UITextField) -> Int {
        guard let text = textField.text, !text.isEmpty else {
            return 0
        }
        return text.count
    }
    
    func isTextFieldTrimmedTextEmpty(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.count == 0
    }
    
    func textFieldTrimmedText(_ textField: UITextField) -> String {
        guard let text = textField.text, !text.isEmpty else {
            return ""
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: Email validation
    func isValidEmail(_ emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    
    func uniqueString() -> String {
        var uuid = NSUUID().uuidString
        uuid = uuid.substring(to: uuid.index(uuid.startIndex, offsetBy: 4))
        return uuid
    }
    
   
    
   
    
    // MARK: Loading Screens
    
    func showLoadingIndicatorScreen() {
        let storyboard: UIStoryboard = UIStoryboard.init(name: StoryboardName.authentication, bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.loadingViewController)
        self.loadingView = loadingViewController.view
        AppDelegate.shared.window?.addSubview(self.loadingView!)
    }
    
    func dismissLoadingIndicatorScreen() {
        if let view = self.loadingView {
            view.removeFromSuperview()
            self.loadingView = nil
        }
    }
    
    // MARK : UITableView Separator Inset
    
    func setupTableViewCell(_ cell: UITableViewCell) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
}

class AlertController: UIAlertController {
    
    private var alertWindow: UIWindow?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.alertWindow?.isHidden = true
        self.alertWindow = nil
    }
    
    func show(_ animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.alertWindow = UIWindow(frame: UIScreen.main.bounds)
        self.alertWindow?.rootViewController = UIViewController()
        self.alertWindow?.tintColor = AppDelegate.shared.window?.tintColor
        
        // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
        if let topWindow =  UIApplication.shared.windows.last {
            self.alertWindow?.windowLevel = topWindow.windowLevel + 1;
        }
        self.alertWindow?.makeKeyAndVisible()
        self.alertWindow?.rootViewController?.present(self, animated: animated, completion: completion)
        
    }
}

extension UIAlertController {
    
    /**
     A simple `UIAlertController` made to show an error message that's passed in.
     
     - parameter body: The body of the alert.
     
     - returns:  A `UIAlertController` with an 'Okay' button.
     */
    convenience init(title: String, body: String, dismissHandler: AlertBarAction?) {
        self.init(title: title, message: body, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: AlertActionButton.ok, style: .default) { action in
            if let handler = dismissHandler {
                handler()
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        self.addAction(okayAction)
    }

    
}



