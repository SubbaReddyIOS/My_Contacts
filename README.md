# My_Contacts
This app is used to store the Contacts in your local.

<p align="center">
  <img src="https://user-images.githubusercontent.com/20789816/41829446-6c0618c4-7858-11e8-9a45-0bcba4fefad6.png" width="250"/>
  <img src="https://user-images.githubusercontent.com/20789816/41829450-741b8d14-7858-11e8-9b28-cd83640e97dd.png" width="250"/>
</p>



1. Create DB With entity in your Xcode Project.
2. Configure DB in AppDeligates

 var contacts: [NSManagedObject] = []
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Numbers")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
     
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

3. Add Contacts in DB in AddContactViewController.swift


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
        
       
4. Retrive Data From DB in ViewController

 
    //======= Data base variable ======
    
    var contacts: [NSManagedObject] = []
    
    
    //======== Variables For Filter (Search)========
    
    var arrContactName = NSMutableArray()
    var arrMobileNumers = NSMutableArray()
    var arrContactImages = NSMutableArray()

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
        
    
