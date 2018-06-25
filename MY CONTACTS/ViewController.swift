//
//  ViewController.swift
//  MY CONTACTS
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate,UITextFieldDelegate{
 
    //======= Data base variable ======
    
    var contacts: [NSManagedObject] = []
    
    
    //======== Variables For Filter (Search)========
    var arrContactName = NSMutableArray()
    var arrFilteredNames :[String] = []
    var arrMobileNumers = NSMutableArray()
    var arrContactImages = NSMutableArray()
    var SearchBarValue:String!
    var searchActive : Bool = false
    
    //=========== Story Board Outlets===============

    @IBOutlet weak var tblContacts: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search Contact"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //============== Getting Data For Database ===============
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Contacts")
        do {
            contacts = try managedContext.fetch(fetchRequest)
            
            arrContactName.removeAllObjects()
            arrMobileNumers.removeAllObjects()
            arrContactImages.removeAllObjects()
            arrFilteredNames.removeAll()
      
            for contactsData in contacts
            {
                arrContactName.add("\(String(describing:  contactsData.value(forKeyPath: "first_Name") as! String)) \(String(describing: contactsData.value(forKeyPath: "last_Name") as! String))")
                arrMobileNumers.add("\(String(describing:  contactsData.value(forKeyPath: "country_code") as! String)) \(String(describing: contactsData.value(forKeyPath: "mobile_Number") as! String))")
                let image = contactsData.value(forKey: "image") as! NSData
                if image.length > 0{
                var useImage = [UIImage]()
                useImage.append(UIImage(data: image as Data)!)
                arrContactImages.add(useImage[0])
                }
                else{
                    arrContactImages.add(#imageLiteral(resourceName: "user"))

                }
            }

            arrFilteredNames = arrContactName as! [String]
         
            tblContacts.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    //================ Tableview Deligates ====================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return arrFilteredNames.count
        }
        else{
            return arrContactName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell")as! ContactsTableViewCell
        cell.imgContact.image = #imageLiteral(resourceName: "user")
         cell.imgContact.layer.cornerRadius =  cell.imgContact.frame.height/2
        cell.imgContact.layer.masksToBounds = true
        
        if(searchActive){
            cell.lblName.text = arrFilteredNames[indexPath.row]
            let i = arrContactName.index(of: arrFilteredNames[indexPath.row])
            cell.lblPhoneNumber.text = arrMobileNumers[i] as? String
            cell.imgContact.image = arrContactImages[i] as? UIImage
        }
        else{
            cell.lblName.text = arrContactName[indexPath.row] as? String
            cell.lblPhoneNumber.text = arrMobileNumers[indexPath.row] as? String
            cell.imgContact.image = arrContactImages[indexPath.row] as? UIImage
        }
      
        return cell
    }
    
   //=================== Search Controller Deligates =======================
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
        tblContacts.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        tblContacts.reloadData()

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchActive = false

            tblContacts.reloadData()
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("clearerr")
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
             searchActive = false
        }
        else{
        arrFilteredNames = arrContactName.filter({ (text) -> Bool in
            let tmp:NSString = text as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        
        }) as! [String]
     
       searchActive = true
        }
         tblContacts.reloadData()
    
    }

    @IBAction func btn_AddContact_Tapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let addContact = self.storyboard?.instantiateViewController(withIdentifier: "AddContactViewController")as! AddContactViewController
        
        self.navigationController?.pushViewController(addContact, animated: true)
        
    }
}

