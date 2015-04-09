var Base64 = require("cloud/base64.js");

// Percent service fee applied to all transactions
var txPercent = "0.05";

// set this to true to turn on production keys
var paypalProduction = false;

var paypalSandbox = {
    endpoint: "api.sandbox.paypal.com",
    clientId: "AT_zVdLhRy_IwuNqTMBFPVImboNVwfR6CJXhIp62uSMHcsZhKD3X6y9d-Snn3i679gA8M8yP5Qk32ZEa",
    secret: "ELzxVwNIte46YvjvrIQ9Zl9Ltakhyq25qi6YvPfTjYejDjqP6a3QvR6G_KtUM_HieacdQixquBbXXQG8"
};

var paypalProduction = {
    endpoint: "api.paypal.com",
    clientId: "AfCQocl4JaVap0Q97wUWs-OE8-XQ1YNPRG-C9vbDWXpnjnF2LU828418F4uyYRa2YSyU7nwhOp--aa9m",
    secret: "EBKzcHs8_Kd-C7-su2uxb5EJcskW7aBrbKQV94paNr07RcfeAxabp8Dz1HL0EBp_gMdq0GIb1tD5Gkntk"
};


/**
 * HELPERS
 */

/**
 * Creates a standardized cloud code response format.
 *
 * @param object data
 * @param bool error
 * @return object
 */
var formatResponse = function (msg, success, data) {
    return {
        msg: msg,
        success: success,
        data: data
    };
};

var getPayPalConfig = function () {
    return paypalSandbox;
};


var getPayPalAuthHeader = function () {
    var config = getPayPalConfig();
    var auth = config.clientId + ":" + config.secret;
    return auth;
};

var getPayPalEndPoint = function () {
    var config = getPayPalConfig();
    return config.endpoint;
};

/**
 * Gets a parse user by their Id.
 *
 * @param id
 * @return promise
 */
var getUserByEmail = function (response, email, callback) {
    var query = new Parse.Query(Parse.User);
    query.equalTo("email", email);
    return query.first();
};

var getTypeById = function (type, id) {

    var Obj = Parse.Object.extend(type);
    var query = new Parse.Query(Obj);
    query.equalTo("id", id);
    return query.first();

};

var getNegotiation = function(id) {
    var Negotiation = Parse.Object.extend("Negotiation");
    var query = new Parse.Query(Negotiation).include([
        "buyer", "seller", "listing.seller"
    ]);
    return query.get(id);
};

var getUserById = function (id) {
    var query = new Parse.Query(Parse.User);
    return query.get(id);
};

/**
 * CLOUD CODE FUNCTIONS
 *
 * These functions are defined outside of direct cloud code calls so we can
 * call them more easily here or in the app if we really want.
 *
 * Most of this is an adaptation of:
 * https://github.com/paypal/PayPal-iOS-SDK/blob/master/docs/future_payments_server.md#refresh-an-access-token
 */

/**
 * Handles converting in app PayPal OAuth response to a refresh token.
 *
 * @params request.params[
 *  - userId: parse user id of the user who authed this
 *  - code:  payPalResponse code from App OAuth
 *  - type: 'buyer' or 'seller'
 *  ]
 */
Parse.Cloud.define("paypalCodeToToken", function (request, response) {

    var userPromise = getUserByEmail(response, request.params.userEmail);

    userPromise.then(function (user) {

        Parse.Cloud.httpRequest({
            method: 'POST',
            url: 'https://' + getPayPalEndPoint() +'/v1/oauth2/token',
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                "Authorization": "Basic " + Base64.encode(getPayPalAuthHeader())
            },
            params: {
                grant_type: "authorization_code",
                response_type: "token",
                redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
                code: request.params.code
            },
            success: function(res) {

                // still have a chance to error, so just return everything if
                // we can't find a refresh token
                if (res.status === 200) {

                    user.save({

                        "buyerRefreshToken": res.data.refresh_token

                    }).then(function (user) {

                        response.success(formatResponse("Code converted successfully", true));

                    }, function (error) {

                        response.success(formatResponse("Error saving buyerRefreshToken", false, error));

                    });

                    // persist changes and send back a success

                } else {
                    response.success(
                        formatResponse('Failed to convert PayPal Code to Token.', false, res.text)
                    );
                }
            },
            error: function(error) {
                response.success(
                    formatResponse('Failed to convert PayPal Code to Token.', false, error.text)
                );
            }
        });
    });
});

var refreshAccessToken = function (refreshToken) {

    var promise = new Parse.Promise();

    Parse.Cloud.httpRequest({
        method: "POST",
        url: 'https://' + getPayPalEndPoint() +'/v1/oauth2/token',
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "Basic " + Base64.encode(getPayPalAuthHeader())
        },
        params: {
            grant_type: "refresh_token",
            refresh_token: refreshToken
        },
        success: function(res) {
            // still have a chance to error, so just return everything if
            // we can't find a refresh token
            if (res.status === 200) {
                promise.resolve(res.data.access_token);
            } else {
                promise.reject("Failed to refresh access token", res.text);
            }
        },
        error: function(error) {
            promise.reject("Error refreshing access token", error);
        }
    });

    return promise;
};


/**
 * Handles charging a textbook buyer.
 *
 * @params request.params [
 *  - paymentAmount: value in cents to charge the buyer
 *  - metadataId: paypal metadataid of the buyer
 *  - description: to be included in the buyer's receipt
 *  - sellerParseId: the sellers Parse User Id
 * ]
 */
Parse.Cloud.define("prepareCharge", function (request, response) {

    var metadataId = request.params.metadataId;
    var negotiationId = request.params.negotiationId;
    var negotiation, amount, description;

    getNegotiation(negotiationId).then(function (object) {

        negotiation = object;
        amount = negotiation.get("listing").get("price").toFixed(2).toString();
        var bookTitle = negotiation.get("listing").get("book").get("title");
        description = "Purchase for " + bookTitle;


        return refreshAccessToken(
            negotiation.get("buyer").get("buyerRefreshToken")
        );

    }).then(function (accessToken) {

        var promise = new Parse.Promise();

        Parse.Cloud.httpRequest({
            method: "POST",
            url: "https://" + getPayPalEndPoint() + "/v1/payments/payment",
            headers: {
                "Content-Type": "application/json;charset=utf-8",
                "Authorization": "Bearer " + accessToken,
                "PayPal-Client-Metadata-Id": metadataId
            },
            body: {
                intent: "authorize",
                payer:{
                    payment_method: "paypal"
                },
                transactions:[
                    {
                        amount:{
                            currency: "CAD",
                            total: amount
                        },
                        description: description
                    }
                ]
            },
            success: function(res) {

                if (res.status === 201) {
                    // wow PayPal, cool json response bro
                    var captureUrl = res.data
                        .transactions[0].related_resources[0]
                        .authorization.links[1].href;

                    negotiation.save({
                        "paymentCaptureUrl": captureUrl
                    }).then(function (updated) {
                        promise.resolve("Payment prepared successfully.");
                    }, function (error) {
                        promise.reject("Failed to save capture url", res.data);
                    });

                } else {
                    promise.reject("Failed to authorize user charge", res.data);
                }
            },
            error: function(error) {
                promise.reject("Failed to prepare buyer payment.", error.data);
            }
        });

        return promise;

    // Success! Respond to app.
    }.bind(negotiation)).then(function (msg) {
        response.success(formatResponse(msg, true));

    // error handler catches eeverything
    }, function(msg, result) {
        response.success(
            formatResponse(msg, false, result)
        );
    });
});

/**
 * Once a payment has been authorized, it can be captured from it's payment
 * capture url. The "access token" that is set here is different from that
 * specified in "charge" in that that access token is on behalf of a user who
 * has authorized, and this is our own access token from our api credentials.
 */
Parse.Cloud.define("capturePayment", function (request, response) {

    var negotiationId = request.params.negotiationId;
    var amount = request.params.amount;
    var description = request.params.description;
    var captureUrl, sellerEmail, negotiation, listing, accessToken;

    getNegotiation(negotiationId).then(function (object) {

        negotiation = object;
        listing = negotiation.get('listing');
        captureUrl = negotiation.get('paymentCaptureUrl');
        sellerEmail = negotiation.get('seller').get('email');

        return getOwnAccessToken();

    }).then(function (token) {

        accessToken = token;

        return capture(
            captureUrl,
            amount,
            accessToken
        );

    }).then(function () {

        return pay(
            sellerEmail,
            amount,
            accessToken,
            description,
            negotiationId
        );

    // Payment flow completed successfully, save updated states
    }).then(function (msg) {

        var promises = [];

        // update corresponding parse objects
        negotiation.set('completed', true);
        listing.set('isActive', false);

        promises.push(negotiation.save(), listing.save());

        return Parse.Promise.when(promises);

    }).then(function () {
        // finally return response to the app
        response.success(formatResponse("Payment completed successfully", true));

    // Catch all error handler
    }, function(msg, data) {
        response.success(formatResponse(msg, false, data));
    });
});


/**
 * @param request.params [
 *  - sellerParseId
 * ]
 */
var pay = function (sellerEmail, amount, accessToken, description, negotiationId)
{
    var promise = new Parse.Promise();

    Parse.Cloud.httpRequest({
        method: "POST",
        url: "https://" + getPayPalEndPoint() + "/v1/payments/payouts?sync_mode=true",
        headers: {
            "Content-Type": "application/json;charset=utf-8",
            "Authorization": "Bearer " + accessToken
        },
        body: {
            sender_batch_header: {
                email_subject: "TxtCrunch Payment"
            },
            items: [
                {
                    recipient_type: "EMAIL",
                    amount: {
                        value: amount,
                        currency: "CAD"
                    },
                    receiver: sellerEmail,
                    note: description,
                    sender_item_id: negotiationId
                }
            ]
        },
        success: function(res) {
            if (res.data.batch_header.batch_status == "SUCCESS") {
                promise.resolve();
            } else {
                promise.reject("Failed to payout seller.", res.data);
            }
        },
        error: function(error) {
            promise.reject("Failed to payout seller.", error);
        }
    });

    return promise;
};

/**
 * Used to capture a pending buyer charge via url.
 */
var capture = function (captureUrl, amount, accessToken)
{
    var promise = new Parse.Promise();

    Parse.Cloud.httpRequest({
            method: "POST",
            url: captureUrl,
            headers: {
                "Content-Type": "application/json;charset=utf-8",
                "Authorization": "Bearer " + accessToken,
            },
            body: {
                amount: {
                    currency: "CAD",
                    total: amount.toString()
                },
                is_final_capture: true
            },
            success: function(res) {
                if (res.data.state === 'completed') {
                    promise.resolve();
                } else {
                    promise.reject("Failed to capture payment", res.data);
                }
            },
            error: function(error) {
                promise.reject('Error capturing payment', error);
            }
        });

    return promise;
};

/**
 * Used to grant ourselves an access token from our api credentials.
 */
var getOwnAccessToken = function () {

    var promise = new Parse.Promise();

    Parse.Cloud.httpRequest({
        method: "POST",
        url: 'https://' + getPayPalEndPoint() +'/v1/oauth2/token',
        headers: {
            "Accept": "application/json",
            "Accept-Language": "en_US",
            "Authorization": "Basic " + Base64.encode(getPayPalAuthHeader())
        },
        params: {
            grant_type: "client_credentials"
        },
        success: function(res) {
            // still have a chance to error, so just return everything if
            // we can't find a refresh token
            if (res.status === 200) {
                promise.resolve(res.data.access_token);
            } else {
                promise.reject("Failed to refresh access token", res.text);
            }
        },
        error: function(error) {
            promise.reject("Error refreshing access token", error);
        }
    });

    return promise;
};

