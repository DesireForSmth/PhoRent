// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


//adding new order function
exports.addItemInBasket = functions.https.onCall((data, context) => {
  const uid = context.auth.uid;
  console.log("Here data!");
  console.log(data);
  admin.firestore().collection('categories').doc(data.category)
  .collection('items').doc(data.id).get().then(item => {
    console.log("here item");
    console.log(item);
    admin.firestore().collection('users').doc(uid).collection('basket')
    .add(item).then(() => {
      if (item.exists){
        console.log('ok');
        return Promise.resolve();
      }
      else {
        throw new Error("Don't exist");
      }
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
  const dbElementCount = await admin.firestore().collection('categories').doc(data.category)
    .collection('items').doc(data.id)
    .get('count');
  const elementCount = data.count;
  console.log("Here data!");
  console.log(data);
  const newElementCount = dbElementCount - elementCount;
  if (newElementCount < 0) {
    throw new functions.https.HttpsError('invalid-argument', `Невозможно добавить ${data.name} в заказ. 
   Попробуйте попытку позднее.`);
  }
  else {
    await admin.firestore().collection('categories')
      .doc(data.category).collection('items')
      .doc(data.id).update({ crount: newElementCount });
    console.log('Change succeeded!');
  }
});
