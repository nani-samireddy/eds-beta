import * as functions from "firebase-functions";

export const createOrderId = functions.https.onRequest((request, response) => {
  const orderId = `EDS-${Date.now()}`;
  response.send(orderId);
});

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
