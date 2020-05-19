// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


//adding new order function
exports.addItemInBasket = functions.https.onCall((data, context) => {
  const uid = context.auth.uid;
  admin.firestore().collection('categories').doc(data.category)
  .collection('items').doc(data.id).get().then(snapshot => {
    let item = snapshot.data();
    admin.firestore().collection('users').doc(uid).collection('basket')
    .add(item).then(() => {
        console.log('ok');
        return Promise.resolve();
    }).catch(err => {
        console.error(`Fatal error ${err}`);
    return Promise.reject(err);
    });
    return item
  }).catch((err) => {

      console.error(`Fatal error ${err}`);
  return Promise.reject(err);
  });
});


// reduce count of items 
exports.reduceCountofItem = functions.https.onCall(async (data, context) => {
  let snapshot = await admin.firestore().collection('categories').doc(data.category)
    .collection('items').doc(data.id)
    .get();
  let item = snapshot.data();
  let dbElementCount = item.count;
  let elementCount = data.count;
  if (dbElementCount <= 0) {
    throw new functions.https.HttpsError('invalid-argument', `Невозможно добавить ${data.name} в заказ. 
   Попробуйте попытку позднее.`);
  }
  else {
    let newElementCount = dbElementCount - elementCount;
    await admin.firestore().collection('categories')
      .doc(data.category).collection('items')
      .doc(data.id).update({ count: newElementCount });
    console.log('Change succeeded!');
  }
});
