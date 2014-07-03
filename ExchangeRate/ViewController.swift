//
//  ViewController.swift
//  ExchangeRate
//
//  Created by Dennis  Suratna on 6/30/14.
//  Copyright (c) 2014 dennissuratna. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var availableCurrencies : Currency[] = Currency[]()
    
    @IBOutlet var fromAmount: UITextField
    @IBOutlet var toAmount: UITextField

    @IBOutlet var fromCurrency: UIButton
    @IBOutlet var toCurrency: UIButton

    @IBOutlet var fromCurrencyPickerView: UIPickerView
    @IBOutlet var toCurrencyPickerView: UIPickerView

    @IBOutlet var tapGestureRecognizer: UIGestureRecognizer
    
    var fromCurrencyIndex: Int = 0
    var toCurrencyIndex: Int = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCurrencies()
        
        fromCurrency.setTitle(availableCurrencies[fromCurrencyIndex].abbreviation, forState: UIControlState.Normal)
        toCurrency.setTitle(availableCurrencies[toCurrencyIndex].abbreviation, forState: UIControlState.Normal)
        
        toCurrencyPickerView.hidden = true
        fromCurrencyPickerView.hidden = true
        
        fromAmount.backgroundColor = UIColor.clearColor()
        fromAmount.borderStyle = UITextBorderStyle.None
        fromAmount.layer.cornerRadius = 8.0
        fromAmount.layer.borderWidth = 1.5
        fromAmount.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).CGColor
        
        toAmount.backgroundColor = UIColor.clearColor()
        toAmount.borderStyle = UITextBorderStyle.None
        toAmount.layer.cornerRadius = 8.0
        toAmount.layer.borderWidth = 1.5
        toAmount.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).CGColor
        
        fromCurrency.layer.cornerRadius = 8.0
        fromCurrency.layer.borderWidth = 1.5
        fromCurrency.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).CGColor
        fromCurrency.addTarget(self, action: Selector("showFromCurrencyPicker:"), forControlEvents: UIControlEvents.TouchDown)
        
        toCurrency.layer.cornerRadius = 8.0
        toCurrency.layer.borderWidth = 1.5
        toCurrency.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).CGColor
        toCurrency.addTarget(self, action: Selector("showToCurrencyPicker:"), forControlEvents: UIControlEvents.TouchDown)
        
        fromAmount.text = "1"
        
        updateValue()
        
        tapGestureRecognizer.addTarget(self, action: Selector("dismissKeyboard:"))
    }
    
    func showFromCurrencyPicker(obj: AnyObject){           
        fromAmount.resignFirstResponder()
        toCurrencyPickerView.hidden = true
        fromCurrencyPickerView.hidden = !fromCurrencyPickerView.hidden
    }
    
    func showToCurrencyPicker(obj: AnyObject){
        toAmount.resignFirstResponder()
        fromCurrencyPickerView.hidden = true
        toCurrencyPickerView.hidden = !toCurrencyPickerView.hidden
    }
    
    func dismissKeyboard(obj: AnyObject){
        fromAmount.resignFirstResponder()
        fromCurrencyPickerView.hidden = true
        toCurrencyPickerView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return availableCurrencies.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!{
        return availableCurrencies[row].name
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int){
        NSLog(availableCurrencies[row].abbreviation)
        
        if(pickerView === fromCurrencyPickerView){
            fromCurrencyIndex = row
            fromCurrency.setTitle(availableCurrencies[row].abbreviation, forState: UIControlState.Normal)
        }else if(pickerView === toCurrencyPickerView){
            toCurrencyIndex = row
            toCurrency.setTitle(availableCurrencies[row].abbreviation, forState: UIControlState.Normal)
        }
        
        updateValue()
    }
    
    func updateValue(){
        if(!fromAmount.text.isEmpty){
            
            if(fromCurrencyIndex == toCurrencyIndex){
                //Same currency
                toAmount.text = fromAmount.text
            }else{
                let fromCurrencyString: String = availableCurrencies[fromCurrencyIndex].abbreviation
                let toCurrencyString: String = availableCurrencies[toCurrencyIndex].abbreviation
                let fromString: NSString = NSString.stringWithString(fromAmount.text)
                let fromValue: Float = fromString.floatValue
                
                let toVal: Float? = Currency.convertCurrency(fromValue, baseCurrency: fromCurrencyString, otherCurrency: toCurrencyString)
                
                toAmount.text = toVal!.description
            }
        }
        
    }
    
    func loadCurrencies(){
        availableCurrencies += Currency(abbreviation: "USD", name: "United States Dollar")
        availableCurrencies += Currency(abbreviation: "EUR", name: "Euro")
        availableCurrencies += Currency(abbreviation: "CAD", name: "Canadian Dollar")
        availableCurrencies += Currency(abbreviation: "CNY", name: "Chinese Renminbi")
        availableCurrencies += Currency(abbreviation: "GBP", name: "British Poundsterling")
        availableCurrencies += Currency(abbreviation: "JPY", name: "Japanese Yen")
        availableCurrencies += Currency(abbreviation: "THB", name: "Thai Baht")
        availableCurrencies += Currency(abbreviation: "IDR", name: "Indonesian Rupiah")
        availableCurrencies += Currency(abbreviation: "HKD", name: "Hon Kong Dollar")
        
        Currency.getExchangeRates()
    }
}

