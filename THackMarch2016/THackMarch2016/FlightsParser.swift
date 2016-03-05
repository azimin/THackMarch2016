//
//  FlightsParser.swift
//  THackMarch2016
//
//  Created by Vadim Drobinin on 5/3/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import Foundation
import Alamofire

let skyscannerApiKey = "ah186425269888220249096555707872"

struct Flight {
  var origin: String
  var destination: String
  var price: Float
}

class FlightsParser {
  
}

class SkyScannerAuth {
  static let sharedInstance = SkyScannerAuth()
  var sessionKey: String?
  var pollingUrl: String?
  
  func getSessionKey(completion: (()->())? = nil) {
    
    let requestLink = "http://partners.api.skyscanner.net/apiservices/pricing/v1.0"
    var fields = [String: AnyObject]()
    fields["apiKey"] = skyscannerApiKey
    fields["country"] = "RU"
    fields["currency"] = "RUB"
    fields["locale"] = "ru-RU"
    fields["originplace"] = "BERL-sky"
    fields["destinationplace"] = "MOSC-sky"
    fields["outbounddate"] = "2016-05-07"
    fields["adults"] = 2
    fields["locationschema"] = "Iata" // Just don't ask, huh
    fields["cabinclass"] = "Business"
    
    var headers = [String: String]()
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept"] = "application/json"
    Alamofire.request(.POST, requestLink, parameters: fields, encoding: ParameterEncoding.URL, headers: headers).responseJSON { (response) -> Void in
      switch response.result {
      case .Failure(let error):
        print(error.localizedDescription)
        completion?()
        break
      case .Success:
        self.pollingUrl = response.response?.allHeaderFields["Location"] as? String
        completion?()
        break
      }
    }
  }
  
  func getLivePrices(completion: (()->())? = nil) {
    guard var pollingUrl = pollingUrl else {
      completion?()
      return
    }
    pollingUrl += "?apiKey=\(skyscannerApiKey)"
    Alamofire.request(.GET, pollingUrl).responseJSON { (response) -> Void in
      switch response.result {
      case .Failure(let error):
        print(error.localizedDescription)
        completion?()
        break
      case .Success(let data):
        print(data)
        completion?()
        break
      }
    }
  }
}