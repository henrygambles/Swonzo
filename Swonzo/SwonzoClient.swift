//
//  SwonzoClient.swift
//  Swonzo
//
//  Created by Henry Gambles on 23/07/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

var token : String = UserDefaults.standard.string(forKey: "Token") ?? "default token"
var accountId : String = UserDefaults.standard.string(forKey: "AccountID") ?? "default ID"

var headers: HTTPHeaders = [
    "Authorization": "Bearer " + token
]

var parameters: Parameters = [
    "account_id": accountId
]

class SwonzoClient {

    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
    
    func execute(_ url: URL, completion: @escaping WebServiceResponse) {
        
        let parameters: Parameters = [
            "account_id": UserDefaults.standard.string(forKey: "AccountID")!
        ]

        Alamofire.request(url,
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                completion(nil, error)
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                                completion(jsonArray, nil)
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                completion([jsonDict], nil)
                                
                                
                                
                                do {
                                    
                                    let json = try JSON(data: response.data!)
                                    let account_number = json["accounts"][0]["account_number"].string
                                    let account_description = json["accounts"][0]["description"].string
                                    let acc_id = json["accounts"][0]["id"].string
                                    let sort_code = json["accounts"][0]["sort_code"].string
                                    let first_name = json["accounts"][0]["owners"][0]["preferred_first_name"].string
                                    let full_name = json["accounts"][0]["owners"][0]["preferred_name"].string
                                    let user_id = json["accounts"][0]["owners"][0]["user_id"].string
                                    
                                    
                                    
                                    print("Parsed JSON test")
                                    print(full_name ?? "Json not parsed")
                                    print(acc_id ?? "Json not parsed")
                                    print(user_id ?? "Json not parsed")
                                    print(account_number ?? "Json not parsed")
                                    print(sort_code ?? "Json not parsed")
                                    print(first_name ?? "Json not parsed")
                                    print(account_description ?? "Json not parsed")
                                    
                                    
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                
                                
                                
                                
                                
                            }
        }

    }
    
    func getAccountInfo(completion: @escaping (String) -> Void) {
        
        Alamofire.request("https://api.monzo.com/accounts",
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
//                                HomeViewController().homeView.text = error.localizedDescription
                                
                                print("ERROR")
                                print(error.localizedDescription)
                                completion(error.localizedDescription)
                            }; do {
                                let json = try JSON(data: response.data!)
                                if json.description.contains("message") {
                                    let errorMessage = json["message"].string!
                                    print("Whoops... ", errorMessage)
                                    completion(errorMessage)
                                } else {
                                    let accountId = json["accounts"][0]["id"].string!
                                    let first_name = json["accounts"][0]["owners"][0]["preferred_first_name"].string
                                    UserDefaults.standard.set(first_name, forKey: "FirstName")
                                    print("Getting account ID...", accountId)
                                    completion(accountId)
                                }
                            } catch {
                                print("JSON Parsing error:", error)
                            }
                }
    }

}
struct Root: Codable {
    let transactions: [Transaction]
}

// MARK: - Transaction
struct Transaction: Codable {
    let id, created, transactionDescription: String
    let amount: Int
    let fees: Fees
    let currency: Currency
    let merchant: Merchant?
    let notes: String
    let metadata: [String: String]?
    let labels: [Label]?
    let accountBalance: Int
    let attachments: [Attachment]
    let international: International?
    let category: Category
    let isLoad: Bool
    let settled: String
    let localAmount: Int
    let localCurrency: Currency
    let updated: String
    let accountID: TransactionAccountID
    let userID: UserID
    let counterparty: Counterparty
    let scheme: Scheme
    let dedupeID: String
    let originator, includeInSpending, canBeExcludedFromBreakdown, canBeMadeSubscription: Bool
    let canSplitTheBill, canAddToTab, amountIsPending: Bool
    let declineReason: DeclineReason?
    
    enum CodingKeys: String, CodingKey {
        case id, created
        case transactionDescription = "description"
        case amount, fees, currency, merchant, notes, metadata, labels
        case accountBalance = "account_balance"
        case attachments, international, category
        case isLoad = "is_load"
        case settled
        case localAmount = "local_amount"
        case localCurrency = "local_currency"
        case updated
        case accountID = "account_id"
        case userID = "user_id"
        case counterparty, scheme
        case dedupeID = "dedupe_id"
        case originator
        case includeInSpending = "include_in_spending"
        case canBeExcludedFromBreakdown = "can_be_excluded_from_breakdown"
        case canBeMadeSubscription = "can_be_made_subscription"
        case canSplitTheBill = "can_split_the_bill"
        case canAddToTab = "can_add_to_tab"
        case amountIsPending = "amount_is_pending"
        case declineReason = "decline_reason"
    }
    
//    init(from decoder:Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//
//        self.id = try container.decodeIfPresent(String.self, forKey: .id)! as! String
//        self.created = try container.decodeIfPresent(String.self, forKey: .created)!
//        self.transactionDescription = try container.decodeIfPresent(String.self, forKey: .transactionDescription)!
//        self.amount = try container.decodeIfPresent(Int.self, forKey: .amount)!
//        self.fees = try container.decodeIfPresent(Fees.self, forKey: .fees)!
//        self.currency = try container.decodeIfPresent(Currency.self, forKey: .currency)!
//
////        self.merchant = try! container!.decodeIfPresent(Merchant.self, forKey: .merchant)!
//
//        self.notes = try container.decodeIfPresent(String.self, forKey: .notes)!
//        self.metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata)
//        self.labels = try container.decodeIfPresent([Label].self, forKey: .labels)
//        self.accountBalance = try container.decodeIfPresent(Int.self, forKey: .accountBalance)!
//        self.attachments = try container.decodeIfPresent([Attachment].self, forKey: .attachments)!
//        self.international = try! container.decodeIfPresent(International.self, forKey: .international)
//        self.category = try container.decodeIfPresent(Category.self, forKey: .category)!
//        self.isLoad = try container.decodeIfPresent(Bool.self, forKey: .isLoad)!
//        self.settled = try container.decodeIfPresent(String.self, forKey: .settled)!
//        self.localAmount = try container.decodeIfPresent(Int.self, forKey: .localAmount)!
//        self.localCurrency = try container.decodeIfPresent(Currency.self, forKey: .currency)!
//        self.updated = try container.decodeIfPresent(String.self, forKey: .updated)!
//        self.accountID = try container.decodeIfPresent(TransactionAccountID.self, forKey: .accountID)!
//        self.userID = try container.decodeIfPresent(UserID.self, forKey: .userID)!
//        self.counterparty = try container.decodeIfPresent(Counterparty.self, forKey: .counterparty)!
//        self.scheme = try container.decodeIfPresent(Scheme.self, forKey: .scheme)!
//        self.dedupeID = try container.decodeIfPresent(String.self, forKey: .dedupeID)!
//        self.originator = try container.decodeIfPresent(Bool.self, forKey: .originator)!
//        self.includeInSpending = try container.decodeIfPresent(Bool.self, forKey: .includeInSpending)!
//        self.canBeExcludedFromBreakdown = try container.decodeIfPresent(Bool.self, forKey: .canBeExcludedFromBreakdown)!
//        self.canBeMadeSubscription = try container.decodeIfPresent(Bool.self, forKey: .canBeMadeSubscription)!
//        self.canSplitTheBill = try container.decodeIfPresent(Bool.self, forKey: .canSplitTheBill)!
//        self.canAddToTab = try container.decodeIfPresent(Bool.self, forKey: .canAddToTab)!
//        self.amountIsPending = try container.decodeIfPresent(Bool.self, forKey: .amountIsPending)!
//        self.declineReason = try container.decodeIfPresent(DeclineReason.self, forKey: .declineReason)
//
//
////        self.merchant = try! container.nestedUnkeyedContainer(forKey: .merchant) as? Merchant
//
//        //        if (try? container.decodeIfPresent(String.self, forKey: .merchant)) == nil {
//        //            self.merchant = try container.decodeIfPresent(Merchant.self, forKey: .merchant)
//        //        } else {
//        //            self.merchant == nil
//        //        }
//        print(self.transactionDescription)
//
//
//
//        if (try? container.decodeIfPresent(Merchant.self, forKey: .merchant)) == nil {
//                                self.merchant = try? container.decode(Merchant.self, forKey: .merchant)
////            let test = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: Transaction.CodingKeys.merchant)
//            //            print(container.decode(Codable.Protocol, forKey: <#T##Transaction.CodingKeys#>.merchant))
//
//            //            print(container.de)
//            //            print(test)
//            //                        print(try container.decodeIfPresent(Merchant.self, forKey: .merchant))
//            //            print
////            print(try? container?.decode(Merchant.self, forKey: .merchant))
////
////            self.merchant = try! container?.decodeIfPresent(Merchant.self, forKey: .merchant)
////            self.merchant = try! container.nestedUnkeyedContainer(forKey: .merchant) as? Merchant
//
////            self.merchant = try container.decodeIfPresent(String.self, forKey: .merchant)
//
//            print("🛍️\n\n")
//
//        } else {
//            print("💸\n\n")
//            //            print(try container.decodeIfPresent(Merchant.self, forKey: .merchant))
//                        self.merchant = nil
//        }
//
//
//    }
    
}

enum TransactionAccountID: String, Codable {
    case acc00009WBQ0ZTI9BSOC4I9PZ = "acc_00009WBQ0ZTI9bSOC4i9pZ"
}

// MARK: - Attachment
struct Attachment: Codable {
    let created, externalID, fileType: String
    let fileURL: String
    let id, type: String
    let url: String
    let userID: UserID
    
    enum CodingKeys: String, CodingKey {
        case created
        case externalID = "external_id"
        case fileType = "file_type"
        case fileURL = "file_url"
        case id, type, url
        case userID = "user_id"
    }
}

enum UserID: String, Codable {
    case empty = ""
    case user00009WADrdGJIXCyAbX8Bl = "user_00009WADrdGJIXCyAbX8Bl"
}

enum Category: String, Codable {
    case bills = "bills"
    case cash = "cash"
    case eatingOut = "eating_out"
    case entertainment = "entertainment"
    case family = "family"
    case general = "general"
    case groceries = "groceries"
    case holidays = "holidays"
    case personalCare = "personal_care"
    case shopping = "shopping"
    case transport = "transport"
}

// MARK: - Counterparty
struct Counterparty: Codable {
    let accountNumber, name, sortCode, userID: String?
    let accountID: CounterpartyAccountID?
    let preferredName: PreferredName?
    
    enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case name
        case sortCode = "sort_code"
        case userID = "user_id"
        case accountID = "account_id"
        case preferredName = "preferred_name"
    }
}

enum CounterpartyAccountID: String, Codable {
    case acc00009CER6NoigtYOpkAKMj = "acc_00009cER6noigtYOpkAKMj"
    case acc00009Vd8JLvyJ0JAHn5FWz = "acc_00009Vd8JLvyJ0JAHn5FWz"
}

enum PreferredName: String, Codable {
    case franklinShaw = "Franklin Shaw"
    case kimberleyRino = "Kimberley Rino"
}

enum Currency: String, Codable {
    case eur = "EUR"
    case gbp = "GBP"
    case usd = "USD"
}

enum DeclineReason: String, Codable {
    case cardInactive = "CARD_INACTIVE"
    case exceedsWithdrawalAmountLimit = "EXCEEDS_WITHDRAWAL_AMOUNT_LIMIT"
    case insufficientFunds = "INSUFFICIENT_FUNDS"
    case invalidExpiryDate = "INVALID_EXPIRY_DATE"
    case magneticStripATM = "MAGNETIC_STRIP_ATM"
    case other = "OTHER"
}

// MARK: - Fees
struct Fees: Codable {
    let withdrawalATMInternational, depositCash: Int?
    
    enum CodingKeys: String, CodingKey {
        case withdrawalATMInternational = "withdrawal.atm.international"
        case depositCash = "deposit.cash"
    }
}

// MARK: - International
struct International: Codable {
    let provider, transferID: String
    let sourceAmount: Int
    let sourceCurrency: Currency
    let targetAmount: Int
    let targetCurrency: Currency
    let feeAmount: Int
    let feeCurrency: Currency
    let rate: Double
    let status, reference: String
    let deliveryEstimate: Date
    let transferwiseTransferID, transferwisePayInReference: String
    
    enum CodingKeys: String, CodingKey {
        case provider
        case transferID = "transfer_id"
        case sourceAmount = "source_amount"
        case sourceCurrency = "source_currency"
        case targetAmount = "target_amount"
        case targetCurrency = "target_currency"
        case feeAmount = "fee_amount"
        case feeCurrency = "fee_currency"
        case rate, status, reference
        case deliveryEstimate = "delivery_estimate"
        case transferwiseTransferID = "transferwise_transfer_id"
        case transferwisePayInReference = "transferwise_pay_in_reference"
    }
}

enum Label: String, Codable {
    case withdrawalATMInternational = "withdrawal.atm.international"
}

// MARK: - Merchant
// MARK: - Merchant
struct Merchant: Codable {
    let id, groupID, created, name: String?
    let logo, emoji, category: String?
    let online, atm: Bool
    let address: Address?
    let updated: String?
    let metadata: Metadata?
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case created, name, logo, emoji, category, online, atm, address, updated, metadata
    }
}

// MARK: - Address
struct Address: Codable {
    let shortFormatted, formatted, address, city: String?
    let region, country, postcode: String?
    let latitude, longitude: Double?
    let zoomLevel: Int?
    let approximate: Bool
    
    enum CodingKeys: String, CodingKey {
        case shortFormatted = "short_formatted"
        case formatted, address, city, region, country, postcode, latitude, longitude
        case zoomLevel = "zoom_level"
        case approximate
    }
}

// MARK: - Metadata
struct Metadata: Codable {
    let createdForMerchant, createdForTransaction, foursquareCategory, foursquareID: String?
    let foursquareWebsite: String?
    let googlePlacesIcon: String?
    let googlePlacesID, googlePlacesName, suggestedName, suggestedTags: String?
    let twitterID: String?
    
    enum CodingKeys: String, CodingKey {
        case createdForMerchant = "created_for_merchant"
        case createdForTransaction = "created_for_transaction"
        case foursquareCategory = "foursquare_category"
        case foursquareID = "foursquare_id"
        case foursquareWebsite = "foursquare_website"
        case googlePlacesIcon = "google_places_icon"
        case googlePlacesID = "google_places_id"
        case googlePlacesName = "google_places_name"
        case suggestedName = "suggested_name"
        case suggestedTags = "suggested_tags"
        case twitterID = "twitter_id"
    }
}

enum Country: String, Codable {
    case che = "CHE"
    case deu = "DEU"
    case empty = ""
    case est = "EST"
    case fra = "FRA"
    case gb = "GB"
    case gbr = "GBR"
    case irl = "IRL"
    case lux = "LUX"
    case nld = "NLD"
    case usa = "USA"
}


enum Provider: String, Codable {
    case google = "google"
    case user = "user"
}

enum Scheme: String, Codable {
    case accountInterest = "account_interest"
    case ledgerAdjustment = "ledger_adjustment"
    case mastercard = "mastercard"
    case overdraft = "overdraft"
    case p2PPayment = "p2p_payment"
    case payportFasterPayments = "payport_faster_payments"
    case premiumSubscription = "premium_subscription"
    case ukCashDepositsPaypoint = "uk_cash_deposits_paypoint"
    case ukRetailPot = "uk_retail_pot"
}
