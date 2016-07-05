//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var allXRArray :[Currency] = []
    
    @IBOutlet weak var baseSelector: UISegmentedControl!
    @IBOutlet weak var amountToConvertField: UITextField!
    
    @IBOutlet weak var targetSelector: UISegmentedControl!
    @IBOutlet weak var targetAmountField: UITextField!
    
    @IBOutlet weak var basePickerTextField: UITextField!
    @IBOutlet weak var targetPickerTextField: UITextField!
    
    var pickOption: [String] = []
    
    var basePickerView = UIPickerView()
    var targetPickerView = UIPickerView()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        
        self.basePickerView.delegate = self
        self.targetPickerView.delegate = self

        
        basePickerTextField.inputView = self.basePickerView
        targetPickerTextField.inputView = self.targetPickerView
        
        self.basePickerView.tag = 0
        self.targetPickerView.tag = 1


//        exerciseOne()
//        exerciseTwo()
//        exerciseThree()
        
        let apiToContact = "http://apilayer.net/api/live"
        let parameter = ["access_key": "94217fdb9d33521f768f5803543f7c9b", "currencies": "USD,EUR,JPY,AUD,GBP,CHF,CNY,HKD,SGD,MYR"]
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(.GET, apiToContact, parameters: parameter).validate().responseJSON() { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    let allXR = json["quotes"].dictionaryValue
//                    var allXRDict : [String:Double] = [:]
                    for (key,value) in allXR {
//                        allXRDict[key] = value.doubleValue
                        let curr = Currency(name: key,rate:value.doubleValue)
                        self.allXRArray.append(curr)
                        self.pickOption.append(curr.name)

                    }
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func calculateExchange(sender: AnyObject) {
        guard let amountToConvert = Double(amountToConvertField.text!) else {
            //show error
            targetAmountField.text = ""
            return
        }
        
        var baseCur = basePickerTextField.text ?? ""
        var targetCur = targetPickerTextField.text ?? ""
        
        let baseRateToUSD = 1/(self.findExchange(baseCur))
        let USDTotargetRate = self.findExchange(targetCur)
        let baseToTargetRate = baseRateToUSD * USDTotargetRate
        
        targetAmountField.text = String(format: "%.2f", (amountToConvert * baseToTargetRate))

        
    
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.basePickerView.reloadAllComponents()
        self.targetPickerView.reloadAllComponents()

    }
    
    func findExchange(name: String)->Double{
        for c in self.allXRArray{
            if c.name == name{
                return c.rate
            }
        }
        return 0.0
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            basePickerTextField.text = pickOption[row]
        }else{
            targetPickerTextField.text = pickOption[row]

        }

    }
    
}

