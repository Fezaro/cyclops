/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.setCustomClaims = functions.firestore
    .document("users/{userId}")
    .onCreate(async (snapshot, context) => {
      const userData = snapshot.data();

      // Get user's role from the userData
      const userRole = userData.role;

      // Set custom claim based on user's role
      const customClaims = {};
      if (userRole === "admin") {
        customClaims.admin = true;
      } else if (userRole === "guard") {
        customClaims.guard = true;
      }

      try {
      // Set custom claims for the user
        await admin.auth().setCustomUserClaims(userData.userId, customClaims);
        console.log("Custom claims set successfully.");
      } catch (error) {
        console.error("Error setting custom claims:", error);
      }
    });
