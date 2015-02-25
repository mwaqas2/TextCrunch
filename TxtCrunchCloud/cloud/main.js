// Percent service fee applied to all transactions
var txPercent = "0.05";

var paypalId = "AT_zVdLhRy_IwuNqTMBFPVImboNVwfR6CJXhIp62uSMHcsZhKD3X6y9d-Snn3i679gA8M8yP5Qk32ZEa";

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
var formatResponse = function (msg, data, success) {
    return {
        msg: msg,
        data: data,
        success: success
    };
}

/**
 * TRIGGERS
 */

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
Parse.Cloud.define("transfer", function (request, response) {

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

/**
 * Handles converting 
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
Parse.Cloud.define("transfer", function (request, response) {

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
