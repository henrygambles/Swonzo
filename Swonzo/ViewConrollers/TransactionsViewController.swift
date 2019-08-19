

//
//  TransactionsViewController.swift
//  Swonzo
//
//  Created by Henry Gambles on 01/08/2019.
//  Copyright © 2019 Henry Gambles. All rights reserved.
//


import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

// MARK: - Root
struct Root: Codable {
    let transactions: [Transaction]
}



// MARK: - Transaction
struct Transaction: Codable {
    let id, created, transactionDescription: String
    let amount: Int
    let fees: Fees
    let currency: Currency
    let merchant: Merchant? = nil
    
//    let merchant = try? JSONDecoder().decode([Merchant].self, forKey: merchant) {
//        let merchant = Merchant
//    }; else {
//    let merchant = []
//    }
//    var merchant: Merchant.Type {
//        return (Merchant.self ?? JSONNull?)
//    }
    let notes: String
    let metadata: [String: String]
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
    
//    func encode(to decode: Decoder) throws {
//        var container = try decode.container(keyedBy: CodingKeys.self)
//        try container.decode(merchant, forKey: merchant)
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
    let accountNumber: String?
    let name: Name?
    let sortCode, userID: String?
    let accountID: CounterpartyAccountID?
    let preferredName: Name?
    
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
struct Merchant: Codable {
    let id: [String]
    let groupID: String
    let created: String
    let name: String
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
    let country: Country
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

// MARK: - Metadata
struct Metadata: Codable {
    let createdForTransaction, enrichedFromSettlement, createdForMerchant: String?
    let provider: Provider?
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




class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var transactions: [String] = []
    var prices: [String] = []
    var categories: [String] = []
    
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    
    
    var allTransactions = [Transaction]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transactionsRequest()
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
        // Do any additional setup after loading the view.
    }
    
    func transactionsRequest() {
        
        Alamofire.request("https://api.monzo.com/transactions",
                          parameters: parameters,
                          encoding:  URLEncoding.default,
                          headers: headers).responseJSON { response in
                            if let error = response.error {
                                //                                self.homeView.text = error.localizedDescription
                            } else if let jsonArray = response.result.value as? [[String: Any]] {
                            } else if let jsonDict = response.result.value as? [String: Any] {
                                
                                
                                do {
                                    print("TRANSACTION TESTING 1")
//                                   print(type(of: Merchant))
            
                                    
                                                                        let root = try JSONDecoder().decode(Root.self, from: response.data!)
                                                                        let trans = try JSONDecoder().decode([Transaction].self, from: response.data!)
                                    
//                                                                        print("wagwan", trans.last?.accountID)
                                                                        print("ay", trans.count)
//                                                                        print(<#T##items: Any...##Any#>)
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                
                                do {
                                    print("TRANSACTION TESTING 2")
                                    
                                    let root = try JSONDecoder().decode(Root.self, from: response.data!)
//                                    let trans = try JSONDecoder().decode(Array<Transaction>.self, from: response.data!)
                                    let trans = try JSONDecoder().decode([Transaction].self, from: response.data!)
                                    
                                    
//                                    let root = try? JSONDecoder().decode(Root.self, from: response.data!)
//                                    let trans = try? JSONDecoder().decode([Transaction].self, from: response.data!)
                                    
//                                    print("wagwan", trans?.last?.accountID)
//                                    print("ay", root?.transactions.count ?? 69)
//                                    print("ay", root?.transactions ?? 69)
                                    print("ay", trans.count)
                                } catch {
                                    print("JSON Parsing error:", error)
                                }
                                
//                                do {
//
//
//                                    print("Transaction TESTING")
//
//                                    let json = try JSON(data: response.data!)
//                                    let data = try Data(response.data!)
//
//                                    //                                    let transactionData = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
//                                    //                                    JSONDecoder().keyDecodingStrategy = .convertFromSnakeCase
//                                    let result = try? JSONDecoder().decode(Transaction.self, from: response.data!)
//                                    let root = try JSONDecoder().decode(Root.self, from: response.data!)
//                                    let trans = try JSONDecoder().decode([Transaction].self, from: data)
//
//                                    //                                    self.allTransactions = trans.last?.merchant?.address?.address
//                                    //                                    print("Bitch", trans.last?.merchant?.address.address as Any)
//                                    print("wagwan", trans.last?.accountID)
//
//                                    var latest = json["transactions"].arrayValue.last?["description"].string
//                                    print(json["transactions"].arrayValue.count)
//                                    print(latest)
//                                    let numberOfTransactions = json["transactions"].arrayValue.count
//                                    var i = numberOfTransactions
//                                    while i >= numberOfTransactions - 20 {
//                                        i = i - 1
//
//                                        var dateCreated = json["transactions"][i]["created"].string
//                                        var amount = json["transactions"][i]["amount"].int
//                                        var descripton = json["transactions"][i]["description"].string
//                                        var notes = json["transactions"][i]["notes"].string
//                                        var address = json["transactions"][i]["merchant"]["address"]["address"].string
//                                        var merchant = json["transactions"][i]["merchant"].string
//                                        var merchantName = json["transactions"][i]["merchant"][3].string
//                                        var latitude = json["transactions"][i]["merchant"]["address"]["latitude"].string
//                                        var longitude = json["transactions"][i]["merchant"][0]["address"][0]["longitude"].string
//
//
//                                        var category = json["transactions"][i]["category"].string
//                                        if category == "transport" {
//                                            category = "🚇"
//                                        } else if category == "groceries" {
//                                            category = "🛒"
//                                        } else if category == "eating_out" {
//                                            category = "🍔"
//                                        } else if category == "entertainment" {
//                                            category = "🎥"
//                                        } else if category == "general" {
//                                            category = "⚙️"
//                                        } else if category == "shopping" {
//                                            category = "🛍️"
//                                        } else if category == "cash" {
//                                            category = "🍁"
//                                        } else if category == "personal_care" {
//                                            category = "❤️"
//                                        }
//
//                                        descripton?.prefix(25)
//
//                                        let pounds = Double(amount ?? 0) / 100
//                                        print("\n")
//                                        print(i)
//                                        print("\n")
//                                        print(dateCreated ?? "Loop isn't")
//                                        print(descripton?.prefix(25) ?? "Loop isn't")
//                                        print(category ?? "Loop isn't")
//                                        print("ADDRESS:", address ?? "Loop isn't")
//                                        print("MERCHANT:", merchant ?? "Loop isn't")
//                                        print("NAME:", merchantName ?? "Loop isn't")
//                                        print("LAT:", latitude ?? "Loop isn't")
//                                        print("LONG: ", longitude ?? "No long")
//                                        if pounds < 0 {
//                                            let money = "-£" + String(format:"%.2f",abs(pounds))
//                                            print(money)
//                                            self.prices.append(money as! String)
//                                        }
//                                        else {
//                                            let money = "+£" + String(format:".%.2f",pounds)
//                                            print(money)
//                                            self.prices.append(money as! String)
//                                        }
//                                        print(notes != "" ? notes: "No Notes for this transaction.")
//                                        self.transactions.append(descripton as! String ?? "error")
//                                        self.categories.append(category as! String ?? "error")
//                                        print(self.tableView.dataSource)
//                                        self.tableView.reloadData()
//
//
//                                    }
//
//                                } catch {
//                                    print("JSON Parsing error:", error)
//                                }
                                
                                
                                
                                
                                
                            }
        }
    }
    
    
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        let count = self.transactions.count
        //        return shouldShowLoadingCell ? count + 1 : count
        return self.transactions.count
    }
    
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // set the text from the data model
        cell.textLabel?.text = self.transactions[indexPath.row]
        
        
        let price = prices[indexPath.row]
        let category = categories[indexPath.row]
        cell.detailTextLabel?.text = price
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        label.text = category + " " + price
        cell.accessoryView = label
        
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
