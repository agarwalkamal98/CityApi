//
//  ViewController.swift
//  AlamofireDemo
//
//  Created by kamal agarwal on 25/04/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var tableV: UITableView!
    var responseArr = NSDictionary()
    var citynameArr = [String]()
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        alamofireExample()
    }
    
    func alamofireExample(){
        
        let param = ["request":"city_listing","device_type":"ios","country":"india"]
        
        AF.request("https://www.kalyanmobile.com/apiv1_staging/city_listing.php",method: .post,parameters: param).responseJSON { (resp) in
            //  print("RESPONSE here")
            if let dict = resp.value as? NSDictionary{
                if let respCode = dict.value(forKey: "responseCode") as? String,let respMsg = dict.value(forKey: "responseMessage") as? String{
                    if respCode == "success" {
                        
                        if let cityArr = dict.value(forKey: "city_array") as? NSDictionary{
                            self.responseArr = cityArr
                            print(cityArr.allKeys)
                            print("SUCCESS")
                            self.tableV.reloadData()
                            self.actInd.startAnimating()
                            self.actInd.stopAnimating()
                        }
                        else{
                            print("ERR \(respMsg)")
                        }
                    }
                    
                }
                
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = responseArr.allKeys as! [String]
        let arr1 = arr[section]
        citynameArr = responseArr.value(forKey: "\(arr1)") as! [String]
        return citynameArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return responseArr.allKeys.count  //
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTVC") as! customTVC
        let arr = responseArr.allKeys as! [String]
        let arr1 = arr[indexPath.section]
        citynameArr = responseArr.value(forKey: "\(arr1)") as! [String]
        cell.Lbl.text = "\(citynameArr[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "customheader") as! customheader
        header.headerLbl.text = "\(responseArr.allKeys[section])"
        return header
    }
    
}

class customTVC: UITableViewCell{
    
    @IBOutlet weak var Lbl: UILabel!
}


class customheader: UITableViewCell{
    
    @IBOutlet weak var headerLbl: UILabel!
}
