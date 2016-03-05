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
  var carrier: String
  var formattedNumber: String?
  
  init(data: JSON) {
    origin = data["OriginStation"].stringValue
    destination = data["DestinationStation"].stringValue
    arrivalTime = data["ArrivalDateTime"].stringValue
    departureTime = data["DepartureDateTime"].stringValue
    duration = data["Duration"].intValue
    flightNumber = data["FlightNumber"].stringValue
    carrier = data["Carrier"].stringValue
  }
}

class FlightsParser {
  func flightFromAirport(origin: String, toAirport destination: String, onData date: String, withCabinClass cabinClass: String = "Business", completion: (([Flight])->())? = nil) {
    SkyScannerAuth.sharedInstance.getSessionKey(origin, destination: destination, outboundDate: date, cabinClass: cabinClass) { () -> () in
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
  let market = "RU"
  let currency = "RUB"
  let locale = "ru-RU"
  var pollingUrl: String?
  
  func getLocationName(name: String, completion: (String)->()) {
    let requestUrl = "http://partners.api.skyscanner.net/apiservices/autosuggest/v1.0/\(market)/\(currency)/\(locale)/?query=\(name)&apiKey=\(skyscannerApiKey)"
    Alamofire.request(.GET, requestUrl).responseJSON { (response) -> Void in
      switch response.result {
      case .Failure(let error):
        print(error.localizedDescription)
        completion("")
        break
      case .Success(let data):
        if let places = JSON(data).dictionaryValue["Places"]?.arrayValue where places.count > 0 {
          let place = places[0].dictionaryValue["CityId"]?.stringValue ?? ""
          completion(place)
        } else {
          completion("")
        }
        break
      }
    }
  }
  
  func getSessionKey(origin: String, // "BERL-sky"
    destination: String, // "MOSC-sky"
    outboundDate: String, // "2016-05-07"
    cabinClass: String, // "Business"
    completion: (()->())? = nil) {
    
    let livePricesRequestLink = "http://partners.api.skyscanner.net/apiservices/pricing/v1.0"
    var fields = [String: AnyObject]()
      
    // Custom
    fields["apiKey"] = skyscannerApiKey
    fields["country"] = market
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
    pollingUrl += "?apiKey=\(skyscannerApiKey)" + "&stops=0"
    Alamofire.request(.GET, pollingUrl).responseJSON { (response) -> Void in
      switch response.result {
      case .Failure(let error):
        print(error.localizedDescription)
        completion?([])
        break
      case .Success(let data):
        var flights = [Flight]()
        let json = JSON(data)
        let segments = json.dictionaryValue["Segments"]?.arrayValue ?? []
        let carriers = json.dictionaryValue["Carriers"]?.arrayValue ?? []
        for segment in segments {
          print(segment)
          let flight = Flight(data: segment)
          for carrier in carriers {
            if carrier.dictionaryValue["Id"]?.stringValue == flight.carrier {
              flight.formattedNumber = (carrier.dictionaryValue["Code"]?.stringValue ?? "") + flight.flightNumber
            }
          }
          flights.append(flight)
        }
        completion?(flights)
        break
      }
    }
  }
}