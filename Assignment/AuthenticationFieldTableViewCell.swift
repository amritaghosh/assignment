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


@IBDesignable class AuthenticationFieldTableViewCell: ETWBaseTableViewCell, UITextFieldDelegate {
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
    
    @IBInspectable var outlineBorderWidth: CGFloat! = 1.0
    @IBInspectable var outlineCornerRadius: CGFloat! = 2.0
    
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
        super.prepareForReuse()
        self.setupView()
    }
    
    func setupView() {
        self.textField.rightViewMode = UITextFieldViewMode.always
        self.textField.rightView = UIImageView(image: rightViewImage)
        
        self.textField.superview?.layer.borderColor = CustomColors.authenticationFieldInactive.cgColor
        self.textField.superview?.layer.borderWidth = self.outlineBorderWidth
        self.textField.superview?.layer.cornerRadius = self.outlineCornerRadius
        self.textField.superview?.layer.masksToBounds = true
        
        let fontAttribute = [NSFontAttributeName: UIFont.boldSystemFontOfSize(16.0)]
        if let placeholderText = self.textField.placeholder {
            self.textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: fontAttribute)
        }
    }
    
    
    // MARK: TextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.superview?.layer.borderColor = CustomColors.authenticationFieldActive.cgColor
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.superview?.layer.borderColor = CustomColors.authenticationFieldInactive.cgColor
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return (self.delegate?.authenticationTextFieldShouldReturn(textField))!
    }
    
    @IBAction func textFieldDidChangeCharacters(_ textField: UITextField) {
        self.delegate?.authenticationTextFieldDidChangeCharacters(textField)
    }
}
