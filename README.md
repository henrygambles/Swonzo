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

**Overview**

This project was built as an exercise to learn more about creating complex iOS apps, handling data from an API and what makes for a great UX.

Swonzo was never explicitly devleoped for public use (Monzo states at the top of its API documentation that the "Monzo Developer API is not suitable for building public applications") - though I was keen to make Swonzo capable of handling data from any Monzo account.

**Login**

When looking at how best to implement login for users - there were some decisions needed to be made.

Data from Monzo's API can be accessed by either:

a) Requesting a token from https://developers.monzo.com, and using this token as parameters to request further information about that account.
b) Implementing the OAuth authorisation process where a user opens the app to login, are redirected to Monzo to sign in to their account, then redirected back to the app with their API credentials stored. 

Knowing this, I decided to build my own login functionality following the process described in option a) - rather than using the OAuth cycle. This presented its own set of challenges, as in order to any information about a user's transactions or balance - the API first needs more information about the account. To do this, the moment a token is entered into Swonzo, 3 requests are made in the backend in quick succession:
- Swonzo requests info about the account from https://api.monzo.com/accounts, primarily to fetch the account ID needed for further requests.
- Sw

Since the introduction of Strong Customer Authentication however - it is now the case that third-party applications such as Swonzo need to be authorised in the manner outined in option b).

<img src="../readme-refactor/Swonzo/Mockups/oauth-tradeoff.png" alt="oauth">

**UX**

## Testing

Where possible, I wanted to build Swonzo using TDD.

## Credit

Henry Gambles