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

// MARK: - Root
struct Root: Codable {
    var transactions: [Transaction]
    
    
}



// MARK: - Transaction
struct Transaction: Codable {
    var id, created, transactionDescription: String?
    var amount: Int?
    var fees: Fees?
    var currency: Currency?
    var merchant: Merchant?
    var notes: String?
    var metadata: [String: String]?
    var labels: [Label]?
    var accountBalance: Int?
    var attachments: [Attachment]?
    var international: International? = nil
    var category: Category?
    var isLoad: Bool?
    var settled: String?
    var localAmount: Int?
    var localCurrency: Currency?
    var updated: String?
    var accountID: TransactionAccountID?
    var userID: UserID?
    var counterparty: Counterparty?
    var scheme: Scheme?
    var dedupeID: String?
    var originator, includeInSpending, canBeExcludedFromBreakdown, canBeMadeSubscription: Bool?
    var canSplitTheBill, canAddToTab, amountIsPending: Bool?
    var declineReason: DeclineReason?

    
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

    init(from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)


        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.created = try container.decodeIfPresent(String.self, forKey: .created)
        self.transactionDescription = try container.decodeIfPresent(String.self, forKey: .transactionDescription)
        self.amount = try container.decodeIfPresent(Int.self, forKey: .amount)
        self.metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata)
        self.category = try container.decodeIfPresent(Category.self, forKey: .category)


//        if (try? container.decodeIfPresent(String.self, forKey: .merchant)) == nil {
//            self.merchant = try container.decodeIfPresent(Merchant.self, forKey: .merchant)
//        } else {
//            self.merchant == nil
//        }
        print(self.transactionDescription)

        if (try? container.decodeIfPresent(Merchant.self, forKey: .merchant)) == nil {
//            self.merchant = try? container.decodeIfPresent(String.self, forKey: .merchant)
//            self.merchant = try container.decodeIfPresent(Merchant.self, forKey: .merchant)
            print("🛍️\n\n")
        } else {
            print("💸\n\n")
//            self.merchant = try container.decodeIfPresent(Merchant.self, forKey: .merchant)
        }


    }
}

enum TransactionAccountID: String, Codable {
    case acc00009WBQ0ZTI9BSOC4I9PZ = "acc_00009WBQ0ZTI9bSOC4i9pZ"
}

// MARK: - Attachment
struct Attachment: Codable {
    var created, externalID, fileType: String
    var fileURL: String
    var id, type: String
    var url: String
    var userID: UserID
    
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
    var accountNumber: String?
    var name: Name?
    var sortCode, userID: String?
    var accountID: CounterpartyAccountID?
    var preferredName: Name?
    
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

enum Name: String, Codable {
    case batesPM = "BATES P M"
    case bozanovskiM = "BOZANOVSKI M"
    case chloeZanotti = "CHLOE ZANOTTI"
    case clydesdaleBankPLC = "CLYDESDALE BANK PLC"
    case danielKhajenouri = "Daniel Khajenouri"
    case don = "Don"
    case franklinShaw = "Franklin Shaw"
    case hGambles = "H Gambles"
    case henryGambles = "HENRY GAMBLES"
    case jGambles = "J Gambles"
    case johnGambles = "JOHN GAMBLES"
    case kRino = "K Rino"
    case khajenouriDc = "KHAJENOURI DC"
    case kimberleyRino = "Kimberley Rino"
    case maMan = "Ma man"
    case maMainMan = "Ma main man"
    case missTKWong = "Miss T K Wong"
    case mlleLapeyreCandice = "MLLE LAPEYRE CANDICE"
    case mrFJShaw = "Mr F J Shaw"
    case nameDON = "DON"
    case nameJGAMBLES = "J GAMBLES"
    case shawFJ = "SHAW F J"
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
    var withdrawalATMInternational, depositCash: Int?
    
    enum CodingKeys: String, CodingKey {
        case withdrawalATMInternational = "withdrawal.atm.international"
        case depositCash = "deposit.cash"
    }
}

// MARK: - International
struct International: Codable {
    var provider, transferID: String
    var sourceAmount: Int
    var sourceCurrency: Currency
    var targetAmount: Int
    var targetCurrency: Currency
    var feeAmount: Int
    var feeCurrency: Currency
    var rate: Double
    var status, reference: String
    var deliveryEstimate: Date? = nil
    var transferwiseTransferID, transferwisePayInReference: String
    
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

struct Merchant: Codable {
    let id, groupID, created, name: String
    let logo, emoji, category: String
    let online, atm: Bool
    let address: Address
    let updated: String
    let metadata: MerchantMetadata
    let disableFeedback: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID
        case created, name, logo, emoji, category, online, atm, address, updated, metadata
        case disableFeedback
    }
}

// MARK: - Address
struct Address: Codable {
    let shortFormatted, formatted, address, city: String
    let region, country, postcode: String
    let latitude, longitude: Double
    let zoomLevel: Int
    let approximate: Bool
    
    enum CodingKeys: String, CodingKey {
        case shortFormatted
        case formatted, address, city, region, country, postcode, latitude, longitude
        case zoomLevel
        case approximate
    }
}

// MARK: - MerchantMetadata
struct MerchantMetadata: Codable {
    let createdForMerchant: String?
    let createdForTransaction: String
    let foursquareCategory, foursquareID, foursquareWebsite: String?
    let googlePlacesIcon: String
    let googlePlacesID, googlePlacesName, suggestedName: String
    let suggestedTags, twitterID, enrichedFromSettlement: String?
    
    enum CodingKeys: String, CodingKey {
        case createdForMerchant
        case createdForTransaction
        case foursquareCategory
        case foursquareID
        case foursquareWebsite
        case googlePlacesIcon
        case googlePlacesID
        case googlePlacesName
        case suggestedName
        case suggestedTags
        case twitterID
        case enrichedFromSettlement
    }
}

// MARK: - TransactionMetadata
struct TransactionMetadata: Codable {
    let ledgerInsertionID, mastercardAuthMessageID, mastercardLifecycleID: String
    
    enum CodingKeys: String, CodingKey {
        case ledgerInsertionID
        case mastercardAuthMessageID
        case mastercardLifecycleID
    }
}







// MARK: - Merchant
//struct Merchant: Codable {
//    var id: [String]
//    var groupID: String
//    var created: String
//    var name: String
//    var logo: String
//    var emoji: String
//    var category: Category
//    var online, atm: Bool
//    var address: Address
//    var updated: String
//    var metadata: Metadata
//    var disableFeedback: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case groupID = "group_id"
//        case created, name, logo, emoji, category, online, atm, address, updated, metadata
//        case disableFeedback = "disable_feedback"
//    }

//    init(from decoder:Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        
//        
//        self.id = try container.decodeIfPresent([String].self, forKey: .id)!
//        self.groupID = try container.decodeIfPresent(String.self, forKey: .groupID)!
//        self.created = try container.decodeIfPresent(String.self, forKey: .created)!
//        self.name = try container.decodeIfPresent(String.self, forKey: .name)!
//        self.logo = try container.decodeIfPresent(String.self, forKey: .logo)!
//        self.emoji = try container.decodeIfPresent(String.self, forKey: .emoji)!
//        self.category = try container.decodeIfPresent(Category.self, forKey: .category)!
////        self.online = try container.decode(Bool.self, forKey: online)!
//        self.online = try container.decode(Bool.BooleanLiteralType, forKey: Merchant.CodingKeys)
////        self.atm = try container.(Bool.self, forKey: atm)!
//        self.address = try container.decodeIfPresent(Address.self, forKey: .address)!
//        self.updated = try container.decodeIfPresent(String.self, forKey: .updated)!
//        self.address = try container.decodeIfPresent(Address.self, forKey: .address)!
//        self.metadata = try container.decodeIfPresent(Metadata.self, forKey: .metadata)!
//        self.disableFeedback = try container.decode(Bool.self, forKey: disableFeedback)!
//        
////        if (try? container.decodeIfPresent(String.self, forKey: .merchant)) == nil {
////            self.merchant = try container.decodeIfPresent(Merchant.self, forKey: .merchant)
////        } else {
////            self.merchant = nil
////        }
//    }
//    
//}
//
//// MARK: - Address
//struct Address: Codable {
//    var shortFormatted, formatted, address, city: String
//    var region: String
//    var country: Country
//    var postcode: String
//    var latitude, longitude: Double
//    var zoomLevel: Int
//    var approximate: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case shortFormatted = "short_formatted"
//        case formatted, address, city, region, country, postcode, latitude, longitude
//        case zoomLevel = "zoom_level"
//        case approximate
//    }
//}
//
//enum Country: String, Codable {
//    case che = "CHE"
//    case deu = "DEU"
//    case empty = ""
//    case est = "EST"
//    case fra = "FRA"
//    case gb = "GB"
//    case gbr = "GBR"
//    case irl = "IRL"
//    case lux = "LUX"
//    case nld = "NLD"
//    case usa = "USA"
//}

// MARK: - Metadata
struct Metadata: Codable {
    var createdForTransaction, enrichedFromSettlement, createdForMerchant: String?
    var provider: Provider?
    var providerID, suggestedTags: String?
    var twitterID: String?
    var website: String?
    var googlePlacesIcon: String?
    var googlePlacesID, googlePlacesName, foursquareCategory: String?
    var foursquareCategoryIcon: String?
    var foursquareID: String?
    var foursquareWebsite: String?
    var suggestedName, paypointAgentName, paypointAgentSiteID: String?

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

//// MARK: - Account
//struct Account: Codable {
//    let id: String
//    let closed: Bool
//    let created, accountDescription, type, currency: String
//    let countryCode: String
//    let owners: [Owner]
//    let accountNumber, sortCode: String
//    let paymentDetails: PaymentDetails
//
//    enum CodingKeys: String, CodingKey {
//        case id, closed, created
//        case accountDescription
//        case type, currency
//        case countryCode
//        case owners
//        case accountNumber
//        case sortCode
//        case paymentDetails
//    }
//}
//
//// MARK: - Owner
//struct Owner: Codable {
//    let userID, preferredName, preferredFirstName: String
//
//    enum CodingKeys: String, CodingKey {
//        case userID
//        case preferredName
//        case preferredFirstName
//    }
//}
//
//// MARK: - PaymentDetails
//struct PaymentDetails: Codable {
//    let localeUk: LocaleUk
//
//    enum CodingKeys: String, CodingKey {
//        case localeUk
//    }
//}
//
//// MARK: - LocaleUk
//struct LocaleUk: Codable {
//    let accountNumber, sortCode: String
//
//    enum CodingKeys: String, CodingKey {
//        case accountNumber
//        case sortCode
//    }
//}
//
//// MARK: - Balance
//struct Balance: Codable {
//    let balance, totalBalance, balanceIncludingFlexibleSavings: Int
//    let currency: String
//    let spendToday: Int
//    let localCurrency: String
//    let localExchangeRate: Int
//    let localSpend: [LocalSpend]
//
//    enum CodingKeys: String, CodingKey {
//        case balance
//        case totalBalance
//        case balanceIncludingFlexibleSavings
//        case currency
//        case spendToday
//        case localCurrency
//        case localExchangeRate
//        case localSpend
//    }
//}
//
//// MARK: - LocalSpend
//struct LocalSpend: Codable {
//    let spendToday: Int
//    let currency: String
//
//    enum CodingKeys: String, CodingKey {
//        case spendToday
//        case currency
//    }
//}
//


