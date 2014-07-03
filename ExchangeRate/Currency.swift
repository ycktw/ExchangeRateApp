//
//  Currency.swift
//  ExchangeRate
//
//  Created by Dennis  Suratna on 6/30/14.
//  Copyright (c) 2014 dennissuratna. All rights reserved.
//

import Foundation

var exchangeRatesCache: NSMutableDictionary = NSMutableDictionary()

class Currency : NSObject, NSURLConnectionDelegate {
    
    let abbreviation : String
    let name : String
    
    var conversionRates: Dictionary<String, Double>
    
    init(abbreviation: String, name: String){
        self.abbreviation = abbreviation
        self.name = name
        self.conversionRates = Dictionary<String, Double>()
    }
    
    class func getExchangeRates(){
        let url:NSURL = NSURL.URLWithString("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDEUR%22%2C%20%22USDCAD%22%2C%20%22USDCNY%22%2C%20%22USDGBP%22%2C%20%22USDJPY%22%2C%20%22USDTHB%22%2C%20%22USDIDR%22%2C%20%22USDHKD%22%2C%20%22EURCAD%22%2C%20%22EURCNY%22%2C%20%22EURGBP%22%2C%20%22EURJPY%22%2C%20%22EURTHB%22%2C%20%22EURIDR%22%2C%20%22EURHKD%22%2C%20%22CADCNY%22%2C%20%22CADGBP%22%2C%20%22CADJPY%22%2C%20%22CADTHB%22%2C%20%22CADIDR%22%2C%20%22CADHKD%22%2C%20%22CNYGBP%22%2C%20%22CNYJPY%22%2C%20%22CNYTHB%22%2C%20%22CNYIDR%22%2C%20%22CNYHKD%22%2C%20%22GBPJPY%22%2C%20%22GBPTHB%22%2C%20%22GBPIDR%22%2C%20%22GBPHKD%22%2C%20%22CADCNY%22%2C%20%22CADGBP%22%2C%20%22CADJPY%22%2C%20%22CADTHB%22%2C%20%22CADIDR%22%2C%20%22CADHKD%22%2C%20%22CNYGBP%22%2C%20%22CNYJPY%22%2C%20%22CNYTHB%22%2C%20%22CNYIDR%22%2C%20%22CNYHKD%22%2C%20%22GBPJPY%22%2C%20%22GBPTHB%22%2C%20%22GBPIDR%22%2C%20%22GBPHKD%22%2C%20%22JPYTHB%22%2C%20%22JPYIDR%22%2C%20%22JPYHKD%22%2C%20%22THBIDR%22%2C%20%22THBHKD%22%2C%20%22IDRHKD%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")
        
        let request: NSURLRequest = NSURLRequest(URL: url)
        let ratesData: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        let data: AnyObject! = NSJSONSerialization.JSONObjectWithData(ratesData, options: nil, error: nil)
        let ratesArr: NSArray = (((data as NSDictionary)["query"] as NSDictionary)["results"] as NSDictionary)["rate"] as NSArray
        
        for(var i = 0; i < ratesArr.count; i++){
            var rateObj: NSDictionary = ratesArr[i] as NSDictionary
            var rateId: NSString = rateObj["id"] as NSString
            var rateValString: NSString = rateObj["Rate"] as NSString
            var rateVal: Float = rateValString.floatValue
            
            exchangeRatesCache.setObject(NSNumber.numberWithFloat(rateVal), forKey: rateId)
        }
    }
    
    class func convertCurrency(num: Float, baseCurrency :NSString, otherCurrency: NSString) -> Float?{
        var rateKey:NSString  = baseCurrency.stringByAppendingString(otherCurrency)
        NSLog("Rate key: %@", rateKey)
        var rate: Float? = exchangeRatesCache[rateKey] as? Float
        
        if(rate?){
            NSLog("Rate: %f", rate!)
            return rate! * num
        }else{
            NSLog("Tyring reciprocal")
            rateKey = otherCurrency.stringByAppendingString(baseCurrency)
            rate = exchangeRatesCache[rateKey] as? Float
            NSLog("Rate key: %@", rateKey)

            if(rate?){
                NSLog("Rate: %f", rate!)
                return (1/rate!) * num
            }else{
                return nil
            }
        }
    }
}
