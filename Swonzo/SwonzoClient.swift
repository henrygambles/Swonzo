//
//  SwonzoClient.swift
//  Swonzo
//
//  Created by Henry Gambles on 11/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class SwonzoClient {
    
    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    

    
//    @IBAction func balanceViewButton(_ sender: Any) {
//        
//        guard let urlToExecute = URL(string: "https://api.monzo.com/balance") else {
//            return
//        }
//        
//        
//        execute(urlToExecute) { (json, error) in
//            if let error = error {
////                self.textView.text = error.localizedDescription
//                print(error.localizedDescription)
//            } else if let json = json {
////                self.textView.text = json.description
//                print(json.description)
//            }
//        }
//        
//    }
    
    
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        
        let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJlYiI6Ii9HS3Jyc0JOWnlObk0xRXFPeFhkIiwianRpIjoiYWNjdG9rXzAwMDA5a3VFZ0Rqeld4dzY0OGpoYzkiLCJ0eXAiOiJhdCIsInYiOiI1In0.lvwwdppjYX7Wyhkv1f2vpoEcNYUm25VId9bd_pJ28Ca73REdnzV3TDHCMwz285MVQN81dQEVkz9gpX5ey4mlMg"
        
        let accountId = "acc_00009WBQ0ZTI9bSOC4i9pZ"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token
        ]
        
        let parameters: Parameters = [
            "account_id": accountId
        ]
        
        Alamofire.request(url,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                completion(nil, error)
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                                completion(jsonArray, nil)
                                print("jsonArray is:\(jsonArray)")
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                completion([jsonDict], nil)
                            
                            
                            
                                
                                
                                
                            //                print("TESTING")
                            //                print("dataResponse.request is: \(dataResponse.request)")
                            //                print("dataResponse.response is: \(dataResponse.response)")
                            //                print("dataResponse.error is: \(dataResponse.error)")
                            //                print("dataResponse.value is: \(dataResponse.value)")
//
//                            let swonzo = try? self.newJSONDecoder().decode(Swonzo.self, from: dataResponse.data!)
//                            let owner = try? self.newJSONDecoder().decode(Owner.self, from: dataResponse.data!)
//                            let account = try? self.newJSONDecoder().decode(Account.self, from: dataResponse.data!)
//
                            
                            
                            
                            print("TESTIE TIME")
                            print(response.value)
                            
//                            print("swonzo?.accounts is: \(swonzo?.accounts)")
//                            print("swonzo?.balance is: \(swonzo?.balance)")
//                            print("owner?.preferredFirstName is: \(owner?.preferredFirstName)")
//                            print("account is: \(account)")
//                            print("account.accountNumber is: \(account?.accountNumber)")
//                            print("swonzo.currency is: \(swonzo?.currency)")
//
                            
                            
        }
    }
//
//    struct Swonzo: Codable {
//        let accounts: [Account]?
//        let balance, totalBalance, balanceIncludingFlexibleSavings: Int?
//        let currency: String?
//        let spendToday: Int?
//        let localCurrency: String?
//        let localExchangeRate: Int?
//        let localSpend: [JSONAny]?
//
//        enum CodingKeys: String, CodingKey {
//            case accounts, balance
//            case totalBalance = "total_balance"
//            case balanceIncludingFlexibleSavings = "balance_including_flexible_savings"
//            case currency
//            case spendToday = "spend_today"
//            case localCurrency = "local_currency"
//            case localExchangeRate = "local_exchange_rate"
//            case localSpend = "local_spend"
//        }
//    }
//
//    //
//    // To parse values from Alamofire responses:
//    //
//    //   Alamofire.request(url).responseAccount { response in
//    //     if let account = response.result.value {
//    //       ...
//    //     }
//    //   }
//
//    // MARK: - Account
//    struct Account: Codable {
//        let id: String
//        let closed: Bool
//        let created, accountDescription, type, currency: String
//        let countryCode: String
//        let owners: [Owner]
//        let accountNumber, sortCode: String
//        let paymentDetails: PaymentDetails
//
//        enum CodingKeys: String, CodingKey {
//            case id, closed, created
//            case accountDescription = "description"
//            case type, currency
//            case countryCode = "country_code"
//            case owners
//            case accountNumber = "account_number"
//            case sortCode = "sort_code"
//            case paymentDetails = "payment_details"
//        }
//    }
//
//    //
//    // To parse values from Alamofire responses:
//    //
//    //   Alamofire.request(url).responseOwner { response in
//    //     if let owner = response.result.value {
//    //       ...
//    //     }
//    //   }
//
//    // MARK: - Owner
//    struct Owner: Codable {
//        let userID, preferredName, preferredFirstName: String
//
//        enum CodingKeys: String, CodingKey {
//            case userID = "user_id"
//            case preferredName = "preferred_name"
//            case preferredFirstName = "preferred_first_name"
//        }
//    }
//
//    //
//    // To parse values from Alamofire responses:
//    //
//    //   Alamofire.request(url).responsePaymentDetails { response in
//    //     if let paymentDetails = response.result.value {
//    //       ...
//    //     }
//    //   }
//
//    // MARK: - PaymentDetails
//    struct PaymentDetails: Codable {
//        let localeUk: LocaleUk
//
//        enum CodingKeys: String, CodingKey {
//            case localeUk = "locale_uk"
//        }
//    }
//
//    //
//    // To parse values from Alamofire responses:
//    //
//    //   Alamofire.request(url).responseLocaleUk { response in
//    //     if let localeUk = response.result.value {
//    //       ...
//    //     }
//    //   }
//
//    // MARK: - LocaleUk
//    struct LocaleUk: Codable {
//        let accountNumber, sortCode: String
//
//        enum CodingKeys: String, CodingKey {
//            case accountNumber = "account_number"
//            case sortCode = "sort_code"
//        }
//    }
//
//
//    // MARK: - Encode/decode helpers
//
//    class JSONNull: Codable, Hashable {
//
//        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//            return true
//        }
//
//        public var hashValue: Int {
//            return 0
//        }
//
//        public init() {}
//
//        public required init(from decoder: Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            if !container.decodeNil() {
//                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//            }
//        }
//
//        public func encode(to encoder: Encoder) throws {
//            var container = encoder.singleValueContainer()
//            try container.encodeNil()
//        }
//    }
//
//    class JSONCodingKey: CodingKey {
//        let key: String
//
//        required init?(intValue: Int) {
//            return nil
//        }
//
//        required init?(stringValue: String) {
//            key = stringValue
//        }
//
//        var intValue: Int? {
//            return nil
//        }
//
//        var stringValue: String {
//            return key
//        }
//    }
//
//    class JSONAny: Codable {
//
//        let value: Any
//
//        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//            return DecodingError.typeMismatch(JSONAny.self, context)
//        }
//
//        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//            return EncodingError.invalidValue(value, context)
//        }
//
//        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//            if let value = try? container.decode(Bool.self) {
//                return value
//            }
//            if let value = try? container.decode(Int64.self) {
//                return value
//            }
//            if let value = try? container.decode(Double.self) {
//                return value
//            }
//            if let value = try? container.decode(String.self) {
//                return value
//            }
//            if container.decodeNil() {
//                return JSONNull()
//            }
//            throw decodingError(forCodingPath: container.codingPath)
//        }
//
//        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//            if let value = try? container.decode(Bool.self) {
//                return value
//            }
//            if let value = try? container.decode(Int64.self) {
//                return value
//            }
//            if let value = try? container.decode(Double.self) {
//                return value
//            }
//            if let value = try? container.decode(String.self) {
//                return value
//            }
//            if let value = try? container.decodeNil() {
//                if value {
//                    return JSONNull()
//                }
//            }
//            if var container = try? container.nestedUnkeyedContainer() {
//                return try decodeArray(from: &container)
//            }
//            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//                return try decodeDictionary(from: &container)
//            }
//            throw decodingError(forCodingPath: container.codingPath)
//        }
//
//        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//            if let value = try? container.decode(Bool.self, forKey: key) {
//                return value
//            }
//            if let value = try? container.decode(Int64.self, forKey: key) {
//                return value
//            }
//            if let value = try? container.decode(Double.self, forKey: key) {
//                return value
//            }
//            if let value = try? container.decode(String.self, forKey: key) {
//                return value
//            }
//            if let value = try? container.decodeNil(forKey: key) {
//                if value {
//                    return JSONNull()
//                }
//            }
//            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//                return try decodeArray(from: &container)
//            }
//            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//                return try decodeDictionary(from: &container)
//            }
//            throw decodingError(forCodingPath: container.codingPath)
//        }
//
//        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//            var arr: [Any] = []
//            while !container.isAtEnd {
//                let value = try decode(from: &container)
//                arr.append(value)
//            }
//            return arr
//        }
//
//        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//            var dict = [String: Any]()
//            for key in container.allKeys {
//                let value = try decode(from: &container, forKey: key)
//                dict[key.stringValue] = value
//            }
//            return dict
//        }
//
//        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//            for value in array {
//                if let value = value as? Bool {
//                    try container.encode(value)
//                } else if let value = value as? Int64 {
//                    try container.encode(value)
//                } else if let value = value as? Double {
//                    try container.encode(value)
//                } else if let value = value as? String {
//                    try container.encode(value)
//                } else if value is JSONNull {
//                    try container.encodeNil()
//                } else if let value = value as? [Any] {
//                    var container = container.nestedUnkeyedContainer()
//                    try encode(to: &container, array: value)
//                } else if let value = value as? [String: Any] {
//                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                    try encode(to: &container, dictionary: value)
//                } else {
//                    throw encodingError(forValue: value, codingPath: container.codingPath)
//                }
//            }
//        }
//
//        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//            for (key, value) in dictionary {
//                let key = JSONCodingKey(stringValue: key)!
//                if let value = value as? Bool {
//                    try container.encode(value, forKey: key)
//                } else if let value = value as? Int64 {
//                    try container.encode(value, forKey: key)
//                } else if let value = value as? Double {
//                    try container.encode(value, forKey: key)
//                } else if let value = value as? String {
//                    try container.encode(value, forKey: key)
//                } else if value is JSONNull {
//                    try container.encodeNil(forKey: key)
//                } else if let value = value as? [Any] {
//                    var container = container.nestedUnkeyedContainer(forKey: key)
//                    try encode(to: &container, array: value)
//                } else if let value = value as? [String: Any] {
//                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                    try encode(to: &container, dictionary: value)
//                } else {
//                    throw encodingError(forValue: value, codingPath: container.codingPath)
//                }
//            }
//        }
//
//        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//
//        public required init(from decoder: Decoder) throws {
//            if var arrayContainer = try? decoder.unkeyedContainer() {
//                self.value = try JSONAny.decodeArray(from: &arrayContainer)
//            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//                self.value = try JSONAny.decodeDictionary(from: &container)
//            } else {
//                let container = try decoder.singleValueContainer()
//                self.value = try JSONAny.decode(from: container)
//            }
//        }
//
//        public func encode(to encoder: Encoder) throws {
//            if let arr = self.value as? [Any] {
//                var container = encoder.unkeyedContainer()
//                try JSONAny.encode(to: &container, array: arr)
//            } else if let dict = self.value as? [String: Any] {
//                var container = encoder.container(keyedBy: JSONCodingKey.self)
//                try JSONAny.encode(to: &container, dictionary: dict)
//            } else {
//                var container = encoder.singleValueContainer()
//                try JSONAny.encode(to: &container, value: self.value)
//            }
//        }
//    }
//
//
//
//
//
//
//
//        // MARK: - Helper functions for creating encoders and decoders
//
//        func newJSONDecoder() -> JSONDecoder {
//            let decoder = JSONDecoder()
//            if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//                decoder.dateDecodingStrategy = .iso8601
//            }
//            return decoder
//        }
//
//        func newJSONEncoder() -> JSONEncoder {
//            let encoder = JSONEncoder()
//            if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//                encoder.dateEncodingStrategy = .iso8601
//            }
//            return encoder
//        }
    
}
}
