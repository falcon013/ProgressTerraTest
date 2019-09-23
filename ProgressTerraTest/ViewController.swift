//
//  ViewController.swift
//  ProgressTerraTest
//
//  Created by Maria Paderina on 9/21/19.
//  Copyright © 2019 Maria Paderina. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let baseUrl =  "http://iswiftdata.1c-work.net/api/products/searchproductsbycategory"
    let requredHeaders: HTTPHeaders = ["AccessKey":"test_05fc5ed1-0199-4259-92a0-2cd58214b29c", "IDCategory":"", "IDClient":"", "pageNumberIncome":"1", "pageSizeIncome":"12"]
    
    var foundProducts = [ProductsModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
    }
    
    func getData (url: String, parameters: [String:String], headers: HTTPHeaders){
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers ).responseJSON {
            response in
            if response.result.isSuccess {
                print ("Sucess! Got the  data")
                
                let responseJSON: JSON = JSON(response.result.value!)
                self.updateData(json: responseJSON)
            }
            else {
                print ("Error \(String(describing: response.result.error))")
                
            }
        }
    }
    
    func updateData (json: JSON){
        var currentFoundProducts = [ProductsModel]()
        
        if let products = json["data"]["listProducts"].array {
            for p in products {
                var product = ProductsModel()
                product.name = p["name"].stringValue
                product.ulrMainImage = p["ulrMainImage"].stringValue
                product.priceBegin =  p["priceBegin"].intValue
                product.priceCurrent = p["priceCurrent"].intValue
                
                currentFoundProducts.append(product)
                
                print(p["name"].stringValue)
            }
        }
        foundProducts = currentFoundProducts
        print (foundProducts)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundProducts.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else  {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = foundProducts[indexPath.row].name
        cell.nameLabel.numberOfLines = 0
        cell.nameLabel.lineBreakMode = .byWordWrapping
        
        cell.priceCLabel.text = "\(String(describing: foundProducts[indexPath.row].priceCurrent!)) RUB"
        cell.priceBLabel.text = "\(String(describing: foundProducts[indexPath.row].priceBegin!)) RUB"
        
        if let imageURL = URL(string: foundProducts[indexPath.row].ulrMainImage!) {
            DispatchQueue.global().async {
                let data  = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.img.image = image
                    }
                }
            }
        }
       
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        let params : [String:String] = ["SearchString": searchBarText]
        
        getData(url: baseUrl, parameters: params, headers: requredHeaders)
        
    }
}



