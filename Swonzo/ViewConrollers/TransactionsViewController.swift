

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
    var transactions: [Transaction]
}



// MARK: - Transaction
struct Transaction: Codable {
    var id, created, transactionDescription: String?
    var amount: Int?
    var fees: Fees?
    var currency: Currency?
    let merchant: Merchant? = nil
    
//    let merchant = try? JSONDecoder().decode([Merchant].self, forKey: merchant) {
//        let merchant = Merchant
//    }; else {
//    let merchant = []
//    }
//    var merchant: Merchant.Type {
//        return (Merchant.self ?? JSONNull?)
//    }
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
    
    
//    var deliveryEstimate: Double? = nil

//    var deliveryEstimate: Date? = nil
    
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

// MARK: - Merchant
struct Merchant: Codable {
    var id: [String]
    var groupID: String
    var created: String
    var name: String
    var logo: String
    var emoji: String
    var category: Category
    var online, atm: Bool
    var address: Address
    var updated: String
    var metadata: Metadata
    var disableFeedback: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case created, name, logo, emoji, category, online, atm, address, updated, metadata
        case disableFeedback = "disable_feedback"
    }
}

// MARK: - Address
struct Address: Codable {
    var shortFormatted, formatted, address, city: String
    var region: String
    var country: Country
    var postcode: String
    var latitude, longitude: Double
    var zoomLevel: Int
    var approximate: Bool
    
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
    
    
    
//    var trans = [Transaction]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transactionsRequest()
        tryToken()
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
        // self.tableView.tableFooterView = UIView()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self as? UITableViewDelegate
        tableView.dataSource = self as? UITableViewDataSource
        
        // Do any additional setup after loading the view.
    }
    
    func tryToken() {
        SwonzoClient().getAccountInfo() { response in
            if response.hasPrefix("acc") {
                print("\nTOKEN ✅\n")
                print("TESTING MAY BEGIN\n")
            }
            else {
                print("\nTOKEN ❌\n")
                print("\nPLEASE GET NEW TOKEN/n")
            }
        }
        
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
                                    print("*************************")
                                    print("\n  TRANSACTION TESTING 1\n")
                                    print("*************************\n")
//                                   print(type(of: Merchant))
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.calendar = Calendar(identifier: .iso8601)
                                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                                    
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
                                    
                                                                        let root = try decoder.decode(Root.self, from: response.data!)
                                                                        let trans = try decoder.decode(Transaction.self, from: response.data!)
                                    
                                    print("wagwan", trans.id?.count)
                                    
                                    
//                                                                        print("ay", trans.count)
//                                                                        print(<#T##items: Any...##Any#>)
                                } catch {
                                    print("\nGosh darnnit!", error)
                                    print("\nWell you see...", error.localizedDescription)
                                }
                                
                                do {
                                    print("\n*************************")
                                    print("\n  TRANSACTION TESTING 2\n")
                                    print("*************************\n")
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.calendar = Calendar(identifier: .iso8601)
                                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                                    
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                                    
                                    let root = try decoder.decode(Root.self, from: response.data!)
//                                    let trans = try JSONDecoder().decode(Array<Transaction>.self, from: response.data!)
                                    let trans = try decoder.decode([Transaction].self, from: response.data!)
                                    
                                    
//                                    let root = try? JSONDecoder().decode(Root.self, from: response.data!)
//                                    let trans = try? JSONDecoder().decode([Transaction].self, from: response.data!)
                                    
//                                    print("wagwan", trans?.last?.accountID)
//                                    print("ay", root?.transactions.count ?? 69)
//                                    print("ay", root?.transactions ?? 69)
                                    print("wagwan", trans.count)
                                } catch {
                                    print("\nGosh darnit!", error)
                                    print("\nLOCALIZED ERROR:", error.localizedDescription)
                                }
        
                                
                       
                                
                                do {

                                    print("\n****************")
                                    print("\n  TABLE DATA\n")
                                    print("****************\n")

                                    let json = try JSON(data: response.data!)
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

                                    var latest = json["transactions"].arrayValue.last?["description"].string
                                    print("There are", json["transactions"].arrayValue.count, "items in table.\nFetching data now...\n")
//                                    print(latest)
                                    let numberOfTransactions = json["transactions"].arrayValue.count
                                    var i = numberOfTransactions
                                    while i >= numberOfTransactions - 20 {
                                        i = i - 1

                                        var dateCreated = json["transactions"][i]["created"].string
                                        var amount = json["transactions"][i]["amount"].int
                                        var descripton = json["transactions"][i]["description"].string
                                        var notes = json["transactions"][i]["notes"].string
                                        var address = json["transactions"][i]["merchant"]["address"]["address"].string
                                        var merchant = json["transactions"][i]["merchant"].string
                                        var merchantName = json["transactions"][i]["merchant"][3].string
                                        var latitude = json["transactions"][i]["merchant"]["address"]["latitude"].string
                                        var longitude = json["transactions"][i]["merchant"][0]["address"][0]["longitude"].string


                                        var category = json["transactions"][i]["category"].string
                                        if category == "transport" {
                                            category = "🚇"
                                        } else if category == "groceries" {
                                            category = "🛒"
                                        } else if category == "eating_out" {
                                            category = "🍔"
                                        } else if category == "entertainment" {
                                            category = "🎥"
                                        } else if category == "general" {
                                            category = "⚙️"
                                        } else if category == "shopping" {
                                            category = "🛍️"
                                        } else if category == "cash" {
                                            category = "🍁"
                                        } else if category == "personal_care" {
                                            category = "❤️"
                                        }

                                        descripton?.prefix(25)

                                        let pounds = Double(amount ?? 0) / 100
//                                        print("\n")
                                        print(i+1)
//                                        print("\n")
//                                        print(dateCreated ?? "Loop isn't")
//                                        print(descripton?.prefix(25) ?? "Loop isn't")
//                                        print(category ?? "Loop isn't")
//                                        print("ADDRESS:", address ?? "Loop isn't")
//                                        print("MERCHANT:", merchant ?? "Loop isn't")
//                                        print("NAME:", merchantName ?? "Loop isn't")
//                                        print("LAT:", latitude ?? "Loop isn't")
//                                        print("LONG: ", longitude ?? "No long")
                                        if pounds < 0 {
                                            let money = "-£" + String(format:"%.2f",abs(pounds))
//                                            print(money)
                                            self.prices.append(money as! String)
                                        }
                                        else {
                                            let money = "+£" + String(format:".%.2f",pounds)
//                                            print(money)
                                            self.prices.append(money as! String)
                                        }
//                                        print(notes != "" ? notes: "No Notes for this transaction.")
                                        self.transactions.append(descripton as! String ?? "error")
                                        self.categories.append(category as! String ?? "error")
//                                        print(self.tableView.dataSource)
                                        self.tableView.reloadData()
                                        
                                        


                                    }
                                print("\nTable populated 💰")
                                } catch {
                                    print("\nOh no! Error populating table. Apparently...", error.localizedDescription)
                                }
                                
                                
                                
                                
                                
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


