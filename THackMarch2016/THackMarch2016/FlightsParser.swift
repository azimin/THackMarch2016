//
//  FlightsParser.swift
//  THackMarch2016
//
//  Created by Vadim Drobinin on 5/3/16.
//  Copyright © 2016 Alex & Vadim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let skyscannerApiKey = "ah186425269888220249096555707872"

class Flight {
  var origin: String
  var destination: String
  var departureTime: String
  var arrivalTime: String
  var flightNumber: String
  var duration: Int
  
  init(data: JSON) {
    origin = data["OriginStation"].stringValue
    destination = data["DestinationStation"].stringValue
    arrivalTime = data["ArrivalDateTime"].stringValue
    departureTime = data["DepartureDateTime"].stringValue
    duration = data["Duration"].intValue
    flightNumber = data["FlightNumber"].stringValue
  }
}

class FlightsParser {
  func flightFromAirport(origin: String, toAirport destination: String, onData date: String, withCabinClass cabinClass: String = "Business", completion: (([Flight])->())? = nil) {
    SkyScannerAuth.sharedInstance.getSessionKey("RU", currency: "RUB", locale: "ru-RU", origin: origin, destination: destination, outboundDate: date, cabinClass: cabinClass) { () -> () in
      SkyScannerAuth.sharedInstance.getLivePrices() {
        flights in
          print("Success")
          completion?(flights)
      }
    }
  }
}

class SkyScannerAuth {
  static let sharedInstance = SkyScannerAuth()
  var pollingUrl: String?
  
  func getSessionKey(country: String, // "RU"
    currency: String, // "RUB"
    locale: String, // "ru-RU"
    origin: String, // "BERL-sky"
    destination: String, // "MOSC-sky"
    outboundDate: String, // "2016-05-07"
    cabinClass: String, // "Business"
    completion: (()->())? = nil) {
    
    let livePricesRequestLink = "http://partners.api.skyscanner.net/apiservices/pricing/v1.0"
    var fields = [String: AnyObject]()
      
    // Custom
    fields["apiKey"] = skyscannerApiKey
    fields["country"] = country
    fields["currency"] = currency
    fields["locale"] = locale
    fields["originplace"] = origin
    fields["destinationplace"] = destination
    fields["outbounddate"] = outboundDate
    fields["cabinclass"] = cabinClass
    
    // Predefined
    fields["adults"] = 1 // Assume we travel alone — that's why we need the app
    fields["locationschema"] = "Iata" // Just don't ask, huh
    
    var headers = [String: String]()
    headers["Content-Type"] = "application/x-www-form-urlencoded"
    headers["Accept"] = "application/json"
    
    Alamofire.request(.POST, livePricesRequestLink, parameters: fields, encoding: ParameterEncoding.URL, headers: headers).responseJSON { (response) -> Void in
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
  
  func getLivePrices(completion: (([Flight])->())? = nil) {
    guard var pollingUrl = pollingUrl else {
      completion?([])
      return
    }
    pollingUrl += "?apiKey=\(skyscannerApiKey)"
    Alamofire.request(.GET, pollingUrl).responseJSON { (response) -> Void in
      switch response.result {
      case .Failure(let error):
        print(error.localizedDescription)
        completion?([])
        break
      case .Success(let data):
        var flights = [Flight]()
        let segments = JSON(data).dictionaryValue["Segments"]?.arrayValue ?? []
        for segment in segments {
          flights.append(Flight(data: segment))
        }
        completion?(flights)
        break
      }
    }
  }
}