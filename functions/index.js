const functions = require("firebase-functions");

const admin = require("firebase-admin");

admin.initializeApp(functions.config().functions);

const db = admin.firestore();

const credentials = {
    apiKey: 'a6876ff77180173b752be5a4f008d8a45558d50b264affc5c09c9c360c291e68',         // use your sandbox app API key for development in the test environment
    username: 'sandbox',      // use 'sandbox' for development in the test environment
};

const Africastalking = require('africastalking')(credentials);

// Initialize a service e.g. SMS
const sms = Africastalking.SMS


exports.newUser = functions.firestore.document('users/{userID}').onCreate(async (snap, context) => {

    const user = snap.data();

    // Use the service
    const options = {
        to: [user.phone],
        message: "Hi, welcome to e-KODI! Manage your properties with ease! For more information contact us on +2547xxxxxxxx"
    }

    // Send message and capture the response or error
    sms.send(options)
        .then( response => {
            console.log(response);
        })
        .catch( error => {
            console.log(error);
        });

});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
