//
//  AddContactViewController.swift
//  MY CONTACTS
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    //================= Story Board Objects ==============
    
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnAddContact: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    
    //=================  Objects ==============
    
    let imagePicker = UIImagePickerController()
    var contactImage = NSData()

    var people: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //=================  Setting Country Code ==============
 
        print(Shared.shared.strCountryCode)
        
        if !Shared.shared.strCountryCode .isEmpty{
             btnCountryCode.setTitle(Shared.shared.strCountryCode , for: UIControlState.normal)
        }
        else{
            btnCountryCode.setTitle("+91" , for: UIControlState.normal)

        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //=================  Setting Bottom line for Textfields and buttons ==============
      
        txtFirstName.bottomLine(textField: txtFirstName, view: backgroundView)
        txtLastName.bottomLine(textField: txtLastName, view: backgroundView)
        txtEmail.bottomLine(textField: txtEmail, view: backgroundView)
        txtPhoneNumber.bottomLine(textField: txtPhoneNumber, view: backgroundView)
        btnCountryCode.bottomLineButton(button: btnCountryCode)
        
        //============= setting corner Radious ===============
        btnAddContact.layer.cornerRadius = 4
        btnAddContact.layer.masksToBounds = true
        imgContact.layer.cornerRadius = imgContact.frame.width/2
        imgContact.layer.masksToBounds = true
       
        imgContact.isUserInteractionEnabled = true
        self.imagePicker.delegate = self

    }
    @IBAction func back_Tapped(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btn_CountryCode_Tapped(_ sender: Any) {
    }
    
    @IBAction func btn_AddContact_Tapped(_ sender: Any) {
        
        
        if (txtFirstName.text?.isEmpty)! {
            self.showAlert(alertMeassage: "Please Enter First Name")
            txtFirstName.resignFirstResponder()
                return
        }
        
        if (txtLastName.text?.isEmpty)! {
            self.showAlert(alertMeassage: "Please Enter Last Name")
            txtFirstName.resignFirstResponder()
            return
        }
        if (txtEmail.text?.isEmpty)! {
            self.showAlert(alertMeassage: "Please Enter Email")
            txtFirstName.resignFirstResponder()
            return
        }
        if (!(txtEmail.text?.isEmpty)!)
        {
            if (!self.isValidEmail(testStr: txtEmail.text!))
            {
                self.showAlert(alertMeassage:"Please Enter valid Email")
                return;
            }
        }
        if (txtPhoneNumber.text?.isEmpty)! {
            self.showAlert(alertMeassage: "Please Enter Mobile Number")
            txtFirstName.resignFirstResponder()
            return
        }
        if (!(txtPhoneNumber.text?.isEmpty)!)
        {
            if !self.validate(value: txtPhoneNumber.text!)
            {
                self.showAlert(alertMeassage:"Please Enter valid Mobile Number")
                return;
            }
        }
        
        ///================ Adding Contacts to DB===================
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Contacts",
                                                in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(txtFirstName.text, forKey: "first_Name")
        person.setValue(txtLastName.text, forKey: "last_Name")
        person.setValue( btnCountryCode.title(for: UIControlState.normal)!, forKey: "country_code")
        person.setValue( txtPhoneNumber.text , forKey: "mobile_Number")
        person.setValue(txtEmail.text, forKey: "email_id")
           person.setValue(contactImage, forKey: "image")
        
        do {
            try managedContext.save()
            people.append(person)
            
            let alertController = UIAlertController(title: "My Contacts", message: "Contact added Succesefull", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default) { (action:UIAlertAction) in

                self.navigationController?.popToRootViewController(animated: true)
            }

            alertController.addAction(ok)
        
            self.present(alertController, animated: true, completion: nil)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
       
        
        
    }
    
    func bottomBoarder(txtField:[UITextField], button:UIButton) {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor.darkGray.cgColor
        for textField in txtField
        {
        
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        }
        
         border.frame = CGRect(x: 0, y: button.frame.size.height - width, width:  button.frame.size.width, height: button.frame.size.height)
        border.borderWidth = width
        button.layer.addSublayer(border)
        button.layer.masksToBounds = true
        
    
    }
    @IBAction func img_Tapped(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Contact Image", message: "", preferredStyle: .actionSheet)
        let gallary = UIAlertAction(title: "Gallary", style: .default) { (action:UIAlertAction) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = false

            self.present(self.imagePicker, animated: true, completion:nil)
            
        }
        let Camera = UIAlertAction(title: "Camera", style: .default) { (action:UIAlertAction) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
                        self.present(self.imagePicker, animated: true, completion:nil)
        }
        
        alertController.addAction(gallary)
         alertController.addAction(Camera)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgContact.contentMode = .scaleAspectFill
            self.imgContact.image = pickedImage
            contactImage = UIImageJPEGRepresentation(pickedImage, 1)! as NSData
            
        }
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func showAlert(alertMeassage:String){
        let alert = UIAlertController(title: "MY CONTACTS", message: alertMeassage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)

    }
    func validate(value: String) -> Bool {
        
        let PHONE_REGEX = "^[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        print(result)
        return result
    }
  
}
extension UITextField

{
    func bottomLine(textField:UITextField,view:UIView)
    {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width:  view.frame.size.width-60, height: 1)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    
    }
}
extension UIButton
{
    func bottomLineButton(button:UIButton)
    {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        
        border.frame = CGRect(x: 0, y: button.frame.size.height - width, width:  button.frame.size.width, height: button.frame.size.height)
        border.borderWidth = width
        button.layer.addSublayer(border)
        button.layer.masksToBounds = true
        
    }
}
