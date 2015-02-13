var Stripe = require('stripe');
Stripe.initialize('sk_test_A7mHjFsnnqa1yN5w0U9aA61b');

// Percent service fee applied to all transactions
var txPercent = "0.05";

/**
 * HELPERS
 */

/**
 * Used to calculate what value in cents we are charging for a given transaction.
 *
 * @param amountInCents
 * @return our portion rounded down to the near cent in cents
 */
var calculateEarnings = function (amountInCents) {
    var charge = amountInCents * txPercent;
    return Math.floor(charge);
};

/**
 * Creates a standardized cloud code response format.
 *
 * @param object data
 * @param bool error
 */
var formatResponse = function (msg, data, error) {

    var response = {
        msg: msg,
        data: data,
        error: false
    };

    if (typeof error !== 'undefined' && error) {
        response.error = true;
    }

    return response;
}

/**
 * TRIGGERS
 */

// Automatically create a Stripe Customer for any newly saved customers
Parse.Cloud.afterSave(Parse.User, function (request) {

    var stripe_id = request.object.get("stripeId");
    if (!stripe_id) {

        var data = {
            email: token
        };

        Stripe.customers.create(data).then(function (result) {

            stripe_id = result.id;

        }).fail(function (result) {
            console.log(result);
        });

        request.object.set("stripeId", stripe_id);
        request.object.save();
    }
});

/**
 * CLOUD FUNCTIONS
 */

/**
 * Handles purchases from the perspective of the Buyer.
 *
 * @params request.params[
 *  - buyerId
 *  - sellerId
 *  - amountCents
 *  - textName
 *  ]
 *
 *  @return string msg
 */
Parse.Cloud.define("charge", function (request, response) {

    var query = new Parse.Query(Parse.User);
    var buyer, seller;

    // Fetch the buyer
    query.get(request.params.buyerId).then(function (user) {
        buyer = user;
    }, function (error) {
        response.error(error);
    });

    // Same for the seller
    query.get(request.params.sellerId).then(function (user) {
        seller = user;
    }, function (error) {
        response.error(error);
    });

    var fee = calculateEarnings(request.params.amountCents);
    var charge;

    Stripe.charges.create(
        {
            amount: request.params.amountCents,
            currency: "CAD",
            application_fee: fee,
            description: request.params.textName,
            card: buyer.stripeCardToken
        },
        seller.stripeSellerToken,
        function (err, charge) {
            if (err) {
                response.error(formatResponse(err, null, true));
            }
            charge = charge;
        }
    );

    response.success(formatResponse("Purchase successful", charge));
});
