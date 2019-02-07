//
//  AuthenticationFieldTableViewCell.swift
//  Assignment
//
//  Created by Amrita Ghosh on 05/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import UIKit

public protocol AuthenticationFieldTableViewCellDelegate {
    func authenticationTextFieldShouldReturn(_ textField: UITextField) -> Bool
    func authenticationTextFieldDidChangeCharacters(_ textField: UITextField)
}


@IBDesignable class AuthenticationFieldTableViewCell: BaseTableViewCell, UITextFieldDelegate {
    open var delegate: AuthenticationFieldTableViewCellDelegate?
    
    @IBOutlet
    open weak var authDelegate: AnyObject? {
        get { return self.delegate as AnyObject? }
        set { self.delegate = newValue as? AuthenticationFieldTableViewCellDelegate }
    }
    @IBOutlet weak var textField: UITextField!
    
    @IBInspectable var rightViewImage: UIImage!
    
    @IBInspectable var activeOutlineColor: UIColor!
    @IBInspectable var inactiveOutlineColor: UIColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
      //  super.prepareForReuse()
        self.setupView()
    }
    
    func setupView() {
        self.textField.rightViewMode = UITextField.ViewMode.always
        self.textField.rightView = UIImageView(image: rightViewImage)
        
        self.textField.superview?.layer.borderColor = #colorLiteral(red: 0.4784313725, green: 0.5607843137, blue: 0.1529411765, alpha: 1)
        self.textField.superview?.layer.borderWidth = 1.0
        self.textField.superview?.layer.cornerRadius = 2.0
        self.textField.superview?.layer.masksToBounds = true
        
        let fontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16.0)]
        if let placeholderText = self.textField.placeholder {
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: fontAttribute)
        }
    }
    
    
    // MARK: TextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) ->
        Bool {
        textField.superview?.layer.borderColor = #colorLiteral(red: 0.4784313725, green: 0.5607843137, blue: 0.1529411765, alpha: 1)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.superview?.layer.borderColor = #colorLiteral(red: 0.4784313725, green: 0.5607843137, blue: 0.1529411765, alpha: 1)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (self.delegate?.authenticationTextFieldShouldReturn(textField))!
    }
    
    @IBAction func textFieldDidChangeCharacters(_ textField: UITextField) {
        self.delegate?.authenticationTextFieldDidChangeCharacters(textField)
    }
}
