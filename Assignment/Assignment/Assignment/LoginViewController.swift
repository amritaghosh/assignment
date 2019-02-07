
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

        case .username:
            return 64.0
        case .password:
            return 64.0
        case .signIn:
            return 64.0
        }
    }
    
    // MARK: Configure UI Methods
    
    func setupUI() {
        self.tableView.reloadData()
        if isFirstLoad {
            isFirstLoad = false
            self.setupTableHeaderView()
        }
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
    
    // MARK: AuthenticationFieldTableViewCellDelegate Methods
    
    func authenticationTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField
        {
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
        self.signInButton.backgroundColor = enabled ? #colorLiteral(red: 0.4784313725, green: 0.5607843137, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 0.4784313725, green: 0.5607843137, blue: 0.1529411765, alpha: 0.7066299229)
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
                SystemManager.sharedManager.dismissLoadingIndicatorScreen()
                if let response = responseObject as? Dictionary<String, Any> {
                    if let isLoginSucess =  response["success"] as? Bool {
                        if !isLoginSucess {
                            // if (loginError != nil) {
                            let alertController = AlertController.init(title: "", body: AlertMessages.Authentication.badCredentials, dismissHandler:{
                                self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                            })
                            alertController.show(true, completion: nil)
                            return
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                            AppDelegate.shared.gotoPlayerListScreen()
                        }
                        return
                    }
                }
            })
        }
    }
    
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

        }
        
}

