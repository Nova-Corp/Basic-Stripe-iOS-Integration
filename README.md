# Basic Integration

<p align="center">
<img src="https://raw.githubusercontent.com/stripe/stripe-ios/a87e2fb12ce1ba6b45a075ee22e0da5072a54279/standard-integration.gif" width="240" alt="Basic Integraion Example App" align="center">
</p>

This example app demonstrates how to build a payment flow using our pre-built UI component integration (`STPPaymentContext`).

For a detailed guide, see https://stripe.com/docs/mobile/ios/basic

## To run the example app:

1. If you haven't already, sign up for a [Stripe account](https://dashboard.stripe.com/register) (it takes seconds).
2. Open `./Stripe.xcworkspace` (not `./Stripe.xcodeproj`) with Xcode
3. Fill in the `stripePublishableKey` constant in `./Example/Basic Integration/CheckoutViewController.swift` with your Stripe [test "Publishable key"](https://dashboard.stripe.com/account/apikeys.). This key should start with `pk_test`.
4. Stripe PHP Script used here. If you need my PHP script please comment here.
5. Fill the `backendBaseURL` constant in `./Example/Basic Integration/CheckoutViewController.swift`. 
6. `backendBaseURL` is your PHP Script.

After this is done, you can make test payments through the app and see them in your [Stripe dashboard](https://dashboard.stripe.com/test/payments).  

Head to https://stripe.com/docs/testing#cards for a list of test card numbers.
