# Swonzo

[What's This?](#whats-this) | [Learning Documentation](#learning-documentation) | [Testing](#Testing)  | [Credit](#Credit) 

## What's This?

Swonzo is an iOS client for the Monzo API writen in Swift!

Built in Xcode using Alamofire, Charts, Disk, Google Maps & Lottie.

<img src="../master/Swonzo/Mockups/login.png" alt="login"/>

**🚧 Please note: As Monzo is currently making its API compliant with FCA Strong Customer Authentication - the protcols around third-party applications are currently in flux. Swonzo will be releasing an update once these changes have finsihed taking place. Thank you! 🚧**

*From Monzo's API docs:*
<img src="../master/Swonzo/Mockups/SCA.png" alt="monzo-sca"/>

## Analytics
*Interrogate your spending habits with Swonzo Analytics.*
<img align="left" src="../master/Swonzo/Mockups/home.png" alt="home">

## Maps 
*See where you've been with your Monzo card by using the Swonzo Map.*
<img align="left" src="../master/Swonzo/Mockups/map.png" alt="map">

## Transactions Table
*View your transactions chronologically in the same format they appear within the Monzo app.*
<img align="left" src="../master/Swonzo/Mockups/transactions.png" alt="transactions">

## Detailed View
*Tap on an item in the table to see more details about that transaction.*
<img align="left" src="../master/Swonzo/Mockups/detailedTransactions.png" alt="detailed-transactions">

## Learning Documentation

**Login**

When looking at how best to implement login for users - there were some decisions needed to be made.

Data from Monzo's API can be accessed by either:
a) Requesting a token from https://developers.monzo.com, and using this token as parameters to request further information about that account.
b) Implementing the OAuth authorisation process whereby a user opens the app to login, then are redirected to Monzo to sign in to their account 

  to build my own login functionality rather than using OAuth.
<img align="left" src="../readme-refactor/Swonzo/Mockups/oauth-tradeoff.png" alt="oauth">
Presented its own set of challenges - as in order to get a user's balance or transactions - the API first needs to know what the account ID is.
- The moment a token is entered into Swonzo, 3 requests are made in quick succession:
- A user inputs their token
- OAuth

**UX**