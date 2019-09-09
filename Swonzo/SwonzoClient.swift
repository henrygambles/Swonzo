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

var token : String = UserDefaults.standard.string(forKey: "Token") ?? "No Token"
var accountId : String = UserDefaults.standard.string(forKey: "AccountID") ?? "No ID"


var headers: HTTPHeaders = [
    "Authorization": "Bearer " + token
]

var parameters: Parameters = [
    "account_id": accountId
]

class SwonzoClient {

    typealias WebServiceResponse = ([[String: Any]]?, Error?) -> Void
 
    
    func tryToken() {
        getAccountInfo() { response in
            if response.hasPrefix("acc") {
                print("\nTOKEN ✅\n")
                print("TESTING MAY BEGIN\n")
                 UserDefaults.standard.set("GOOD", forKey: "TokenStatus")
            }
            else {
                print("\nTOKEN ❌\n")
                print("\nPLEASE GET NEW TOKEN/n")
                UserDefaults.standard.set("BAD", forKey: "TokenStatus")            }
        }
    }
    
    
    func getAccountInfo(completion: @escaping (String) -> Void) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "Token")!
        ]
        
        Alamofire.request("https://api.monzo.com/accounts",
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
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

// MARK: - Root
struct Root: Codable {
    let transactions: [Transaction]
}

// MARK: - Transaction
struct Transaction: Codable {
    let id, created, transactionDescription: String
    let amount: Int
    let fees: Fees
    let currency: String
    let merchant: Merchant?
    let notes: String
    let metadata: [String: String]
    let labels: [String]?
    let accountBalance: Int
    let attachments: [Attachment]
    let international: International?
    let category: Category
    let isLoad: Bool
    let settled: String
    let localAmount: Int
    let localCurrency: String
    let updated: String
    let accountID: String
    let userID: String
    let counterparty: Counterparty
    let scheme: String
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
}


// MARK: - Attachment
struct Attachment: Codable {
    let created, externalID, fileType: String
    let fileURL: String
    let id, type: String
    let url: String
    let userID: String
    
    enum CodingKeys: String, CodingKey {
        case created
        case externalID = "external_id"
        case fileType = "file_type"
        case fileURL = "file_url"
        case id, type, url
        case userID = "user_id"
    }
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
    case mondo = "mondo"
    case personalCare = "personal_care"
    case shopping = "shopping"
    case transport = "transport"
}

// MARK: - Counterparty
struct Counterparty: Codable {
    let accountNumber, name, sortCode, userID: String?
    let accountID: String?
    let preferredName: String?
    
    enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case name
        case sortCode = "sort_code"
        case userID = "user_id"
        case accountID = "account_id"
        case preferredName = "preferred_name"
    }
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
    let sourceCurrency: String
    let targetAmount: Int
    let targetCurrency: String
    let feeAmount: Int
    let feeCurrency: String
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

// MARK: - Merchant
struct Merchant: Codable {
    let id, groupID, created, name: String
    let logo: String
    let emoji: String
    let category: Category
    let online, atm: Bool
    let address: Address
    let updated: String
    let metadata: Metadata
    let disableFeedback: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case created, name, logo, emoji, category, online, atm, address, updated, metadata
        case disableFeedback = "disable_feedback"
    }
}

// MARK: - Address
struct Address: Codable {
    let shortFormatted, formatted, address, city: String
    let region: String
    let country: String
    let postcode: String
    let latitude, longitude: Double
    let zoomLevel: Int
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
    let createdForTransaction, enrichedFromSettlement, createdForMerchant: String?
    let provider: String?
    let providerID, suggestedTags: String?
    let twitterID: String?
    let website: String?
    let googlePlacesIcon: String?
    let googlePlacesID, googlePlacesName, foursquareCategory: String?
    let foursquareCategoryIcon: String?
    let foursquareID: String?
    let foursquareWebsite: String?
    let suggestedName, paypointAgentName, paypointAgentSiteID: String?
    
    enum CodingKeys: String, CodingKey {
        case createdForTransaction = "created_for_transaction"
        case enrichedFromSettlement = "enriched_from_settlement"
        case createdForMerchant = "created_for_merchant"
        case provider
        case providerID = "provider_id"
        case suggestedTags = "suggested_tags"
        case twitterID = "twitter_id"
        case website
        case googlePlacesIcon = "google_places_icon"
        case googlePlacesID = "google_places_id"
        case googlePlacesName = "google_places_name"
        case foursquareCategory = "foursquare_category"
        case foursquareCategoryIcon = "foursquare_category_icon"
        case foursquareID = "foursquare_id"
        case foursquareWebsite = "foursquare_website"
        case suggestedName = "suggested_name"
        case paypointAgentName = "paypoint_agent_name"
        case paypointAgentSiteID = "paypoint_agent_site_id"
    }
}


