// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


//adding new order function
// exports.addItemInBasket = functions.https.onCall((data, context) => {
//   const uid = context.auth.uid;
//   admin.firestore().collection('categories').doc(data.category)
//   .collection('items').doc(data.id).get().then(snapshot => {
//     let item = snapshot.data();
//     admin.firestore().collection('users').doc(uid).collection('basket')
//     .add(item).then(() => {
//         console.log('Item has been added');
//         return Promise.resolve();
//     }).catch(err => {
//         console.error(`Fatal error ${err}`);
//     return Promise.reject(err);
//     });
//     return item;
//   }).catch((err) => {

//       console.error(`Fatal error ${err}`);
//   return Promise.reject(err);
//   });
// });


// reduce count of items 
exports.addItemInBasket = functions.https.onCall((data, context) => {
  admin.firestore().collection('categories').doc(data.category)
    .collection('items').doc(data.id)
    .get().then(snapshot => {
      let item = snapshot.data();
      let dbElementCount = item.count;
      let elementCount = data.count;
      const uid = context.auth.uid;
      if (dbElementCount > elementCount) {
        console.log(dbElementCount, elementCount);
        let newElementCount = dbElementCount - elementCount;
        admin.firestore().collection('categories')
          .doc(data.category).collection('items')
          .doc(data.id).update({ count: newElementCount }).then(() => {
            console.log('Change succeeded!');
            admin.firestore().collection('users').doc(uid).collection('basket')
    .add(item).then(() => {
        console.log('Item has been added');
        return Promise.resolve();
    }).catch(err => {
        console.error(`Fatal error ${err}`);
    return Promise.reject(err);
    });
            return Promise.resolve();
          }).catch((err) => {
            console.error(`Fatal error ${err}`);
            return Promise.reject(err);
        });
      }
      else {
        throw new functions.https.HttpsError('invalid-argument', `Невозможно добавить ${data.id} в заказ. 
        Попробуйте попытку позднее.`); 
      }
      return item;
    }).catch((err) => {

      console.error(`Fatal error ${err}`);
      return Promise.reject(err);
  });
});
