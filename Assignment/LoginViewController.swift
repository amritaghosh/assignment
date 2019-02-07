
//
//  LoginViewController.swift
//  Assignment
//
//  Created by Amrita Ghosh on 05/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import UIKit

let kTableHeaderViewHeight_iPhone5x: CGFloat        =  180.0
let kLogoBottomSpace_iPhone5x: CGFloat              =  35.0


class LoginViewController: UITableViewController, AuthenticationFieldTableViewCellDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    
    var emptyDictionary = [String: Any]()
    var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.displayTouchIDSignIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //  self.unbindFromKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row: AuthenticationCell = AuthenticationCell(rawValue: indexPath.row)!
        
        switch row {
//        case .companyID:
//            return 64.0
        case .username:
            return 64.0
        case .password:
            return 64.0
//        case .touchIDCheckBox:
//            return (TouchIDManager.sharedManager.isTouchIDAvailable && !SystemManager.sharedManager.isTouchIDEnabled() ? 42.0 : 0.0)
        case .signIn:
            return 64.0
//        case .signInUsingTouchID:
//            return (SystemManager.sharedManager.isTouchIDEnabled() ? 42.0 : 0.0)
//        case .useDifferentID:
//            return (KeychainManager.sharedManager.getKeychainItemsCount() && !SystemManager.sharedManager.isTouchIDIntentEnabled() ? 42.0 : 0.0)
//        case .forgotPassword:
//            return 48.0
        }
    }
    
    // MARK: Configure UI Methods
    
    func setupUI() {
        self.tableView.reloadData()
        if isFirstLoad {
            isFirstLoad = false
            self.setupTableHeaderView()
        //    self.prePopulateFields()
        }
       // self.checkEnvironment()
    }
    
    func setupTableHeaderView() {
        if UIScreen.main.bounds.size.height <= kScreenHeight_iPhone5x {
            if let tableHeaderViewFrame = self.tableView.tableHeaderView?.frame {
                var frame = tableHeaderViewFrame
                self.logoBottomConstraint.constant = kLogoBottomSpace_iPhone5x
                frame.size.height = kTableHeaderViewHeight_iPhone5x
                self.tableView.tableHeaderView?.frame = frame
            }
        }
    }
    
//    func prePopulateFields() {
//       // self.companyIDTextField.text = KeychainManager.sharedManager.readCompanyId()
//        self.usernameTextField.text = KeychainManager.sharedManager.readUsername()
//        if SystemManager.sharedManager.isTouchIDIntentEnabled() {
//            // TODO: display Alert Message requesting  user to reauthenticate with password to enable touchID
//        }
//        self.passwordTextField.text = ""
//        self.signInButton.isEnabled = false
//        self.useTouchIDButton.isSelected = SystemManager.sharedManager.isTouchIDIntentEnabled()
//    }
    
    func displayTouchIDSignIn() {
        if SystemManager.sharedManager.isTouchIDEnabled() {
            self.signInAndAuthenticateWithTouchID()
        }
    }
    
    // MARK: AuthenticationFieldTableViewCellDelegate Methods
    
    func authenticationTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField
        {
//        case self.companyIDTextField:
//            self.usernameTextField.becomeFirstResponder()
        case self.usernameTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            if self.signInButton.isEnabled {
                self.signInButtonAction(self.signInButton)
            }
            return self.signInButton.isEnabled
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    func authenticationTextFieldDidChangeCharacters(_ textField: UITextField) {
        self.setSignInButtonEnabled(self.isSignInEnabled())
    }
    
  
    // MARK: Sign In Enable/Disable Methods
    
    func setSignInButtonEnabled(_ enabled: Bool) {
        self.signInButton.isEnabled = enabled
        self.signInButton.backgroundColor = enabled ? CustomColors.authenticationSignEnable : CustomColors.authenticationSignDisable
    }
    
    func isSignInEnabled() -> Bool {
        if SystemManager.sharedManager.isTextFieldEmpty(self.usernameTextField) ||
            SystemManager.sharedManager.isTextFieldEmpty(self.passwordTextField) {
            return false
        }
        if SystemManager.sharedManager.textFieldCharacterCount(self.usernameTextField) >= Validation.AuthenticationMinimumCharacterCount.username &&
            SystemManager.sharedManager.textFieldCharacterCount(self.passwordTextField) >= Validation.AuthenticationMinimumCharacterCount.password {
            return true
        }
        return false
    }
    
    // MARK: Validations - Authentication Fields
    
    func fieldsValidatedForSignIn() -> Bool {
        if SystemManager.sharedManager.isTextFieldTrimmedTextEmpty(self.usernameTextField) ||
            SystemManager.sharedManager.isTextFieldTrimmedTextEmpty(self.passwordTextField) {
            return false
        }
        return true
    }
    
    // MARK: Trim Fields
    
    func trimFields() {
    //    self.companyIDTextField.text = SystemManager.sharedManager.textFieldTrimmedText(self.companyIDTextField)
        self.usernameTextField.text = SystemManager.sharedManager.textFieldTrimmedText(self.usernameTextField)
        self.passwordTextField.text = SystemManager.sharedManager.textFieldTrimmedText(self.passwordTextField)
    }
    
    // MARK: Button Actions
    

    @IBAction func signInButtonAction(_ sender: UIButton) {
        self.tableView.endEditing(true)
        self.trimFields()
        
        self.authenticateLoginwithEmail(SystemManager.sharedManager.textFieldTrimmedText(self.usernameTextField), password: SystemManager.sharedManager.textFieldTrimmedText(self.passwordTextField))
    }
    
    

    
    func authenticateLoginwithEmail(_ email: String, password: String) {
        SystemManager.sharedManager.showLoadingIndicatorScreen()
 
        DownSyncManager.sharedManager.authenticateLogin(email, withPassword: password) { (responseObject, loginError) in
            
            DispatchQueue.main.async(execute: {
                if  if (loginError != nil) {
                    SystemManager.sharedManager.dismissLoadingIndicatorScreen()
                    // Error msg show TODO
                    return
                }
                // Login sucess show TODO
            })
        
    }
    
    
    
    
    
    
//    func authenticateLoginForCompanyID(_ companyId: String, withUsername username: String, withPassword password: String, touchLogin: Bool) {
//        SystemManager.sharedManager.showLoadingIndicatorScreen()
//
//        DownSyncManager.sharedManager.authenticateLoginForCompanyID(companyId, withUsername: username, withPassword: password) { (responseObject, loginError) in
//
//            DispatchQueue.main.async(execute: {
//
//                if (loginError != nil) {
//                    SystemManager.sharedManager.dismissLoadingIndicatorScreen()
//                    AlertsManager.sharedManager.enqueueAlert(ErrorHandlingManager.sharedManager.errorMessage(loginError!))
//                    return
//                }
//                SystemManager.sharedManager.setUserIsLoggedIn(true)
//                SystemManager.sharedManager.loginDictionary(username)
//                SystemManager.sharedManager.fetchSettins()
//                SystemManager.sharedManager.expTimeRefreshToken()
//                SystemManager.sharedManager.setActiveUserAccountName(SystemManager.sharedManager.userAccountName(companyId: companyId, username: username))
//                //log analytics
//                PubNubManager.sharedManager.configurePubNubSetting()
//                if !touchLogin {
//                    do {
//                        if !SystemManager.sharedManager.isTouchIDEnabled() {
//                            try  KeychainManager.sharedManager.saveUserAccountDetails(companyId: companyId, username: username, password: "")
//                        } else {
//                            try  KeychainManager.sharedManager.saveUserAccountDetails(companyId: companyId, username: username, password: password)
//                        }
//                    }
//                    catch {
//                         return
//                    }
//
//                    if SystemManager.sharedManager.isTouchIDEnabled() {
//                        do {
//                            try  KeychainManager.sharedManager.saveUserAccountDetails(companyId: companyId, username: username, password: password)
//                        }
//                        catch {
//                            return
//                        }
//                    }
//                }
//
//                DownSyncManager.sharedManager.userAccountInfo(KeychainManager.sharedManager.readUserID()){
//                    (responseObject, userInfoError) in
//                    DownSyncManager.sharedManager.channelGroups(KeychainManager.sharedManager.readUserID()){
//                        (responseObject, userInfoError) in
//
//                        DispatchQueue.main.async(execute: {
//                            SystemManager.sharedManager.dismissLoadingIndicatorScreen()
//                            SystemManager.sharedManager.actionItemListAPICall()
//                            //log analytics
//                            AnalyticsManager.sharedManager.logEventLogin(clientId:companyId,userId: Int32(KeychainManager.sharedManager.readUserID()),eventName: GoogleAnalytics.Events.Login.login, screenName: GoogleAnalytics.Screens.Login.loginScreen)
//                            if touchLogin {
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
//                                    AppDelegate.shared.gotoHomeScreen()
//                                }
//
//                                return
//                            }
//
//                            if !self.useTouchIDButton.isSelected {
//                                SystemManager.sharedManager.setTouchIDIntentEnabled(false)
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
//                                    AppDelegate.shared.gotoHomeScreen()
//                                }
//
//                                return
//                            }
//                            AlertsManager.sharedManager.resetWindow()
//                            self.performSegue(withIdentifier: SegueIdentifier.showLoginTerms, sender: self)
//                        })
//
//                        // TODO: Handle Error
//                        if(userInfoError != nil) {
//                            // TODO
//                            return
//                        }
//
//                        DispatchQueue.main.async(execute: {
//                            //TODO:Pubnub check if its setup twice
//                            PushNotificationManager.sharedManager.pushNotificationSetting()
//                        })
//                    }
//
//                    if(userInfoError != nil) {
//                        return
//                    }
//                }
//
//            })
//        }
//
//    }
    
    // MARK: Button Actions
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func unwindToLoginViewControllerOnSelection(segue: UIStoryboardSegue) {
        self.isFirstLoad = true
        self.dismiss(animated: true) {
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        if segue.identifier == SegueIdentifier.showLoginTerms {
//            let loginTermsViewController = (segue.destination as! UINavigationController).topViewController as! LoginTermsViewController
//            loginTermsViewController.delegate = self
//        }
//        if segue.identifier == SegueIdentifier.showChooseUserID {
//            //log analytics
//            AnalyticsManager.sharedManager.userLogEventTrack(GoogleAnalytics.Events.Setting.differentIDScreenSelected, screenName: GoogleAnalytics.Screens.Setting.chooseDifferentIDScreen)
//            let chooseUserIDViewController = (segue.destination as! UINavigationController).topViewController as! ChooseIDViewController
//            if self.companyIDTextField.text != nil && self.usernameTextField.text != nil {
//                chooseUserIDViewController.selectedUserName = self.companyIDTextField.text!+"-"+self.usernameTextField.text!
//            }
//        }
        
    }
    
}

