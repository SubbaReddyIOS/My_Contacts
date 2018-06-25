//
//  CountryPopupViewController.swift
//  MY CONTACTS
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import CoreData

class CountryPopupViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var Countrys: [NSManagedObject] = []
    var arrCountryNames = NSMutableArray()
    var arrCountryCodes = NSMutableArray()
   
    @IBOutlet weak var tblCountrys: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountrys()
        
    }

    func getCountrys() {
       
        let url = URL(string: "https://restcountries.eu/rest/v1/all")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let unwrappedData = data else { return }
            do {
                let str = try JSONSerialization.jsonObject(with: unwrappedData, options: [])as! [AnyObject]
                print(str)
                
                for value in str{
                    
                    var codes =  [String]()
                    codes = value["callingCodes"]as! [String]
                    print(codes)
                    
                    self.arrCountryNames.add(value["name"]as! String)
                    if codes.count == 0
                    {
                        self.arrCountryCodes.add("")
                    }
                    else{
                        self.arrCountryCodes.add(codes[0])
                    }
                    
                    DispatchQueue.main.async {
                        self.tblCountrys.reloadData()
                    }
                }
                //
            } catch {
                print("json error: \(error)")
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCountryNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell")as! ContactsTableViewCell
        cell.lblCountryName.text = arrCountryNames[indexPath.row] as? String
        cell.lblCountryCode.text = "+ \(arrCountryCodes[indexPath.row] as! String)"
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Shared.shared.strCountryCode = "+ \(arrCountryCodes[indexPath.row] as! String)"
        print(  Shared.shared.strCountryCode)
        
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btncancel_Tapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
}
