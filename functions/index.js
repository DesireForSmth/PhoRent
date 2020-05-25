// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();


//add new item
exports.addItemInBasket = functions.https.onCall((data, context) => {
  let itemID = data.id;
  admin.firestore().collection('categories').doc(data.category)
  .collection('items').doc(itemID).get().then(snapshot => {
    var item = snapshot.data();
    console.log(item);
    let categoryID = data.category;
    let elementCount = data.count;
    let dbElementCount = item.count;
    if (dbElementCount >= elementCount) {
      let newElementCount = dbElementCount - elementCount;
      admin.firestore().collection('categories').doc(categoryID)
      .collection('items').doc(data.id).update({ count: newElementCount}).then(() => {
        let uid = context.auth.uid;
        admin.firestore().collection('users').doc(uid).collection('basket').where('name', '==', item.name)
        .get().then(snapshotQuery => { 
          if (snapshotQuery.empty) {
            item.itemID = itemID;
            item.count = elementCount;
            item.categoryID = categoryID;
            console.log(item);
            admin.firestore().collection('users').doc(uid).collection('basket').doc()
        .set(item).then(() => {
          console.log(item);
          return Promise.resolve();
        }).catch(err => {
          return Promise.reject(err);
        });
          }
          else {
            snapshotQuery.forEach(doc => {
              item = doc.data();
              let docID = doc.id;
              console.log(docID);
              item.count += elementCount;
              console.log(item);
              admin.firestore().collection('users').doc(uid).collection('basket').doc(docID)
        .update({ count: item.count} ).then(() => {
          console.log(item);
          return Promise.resolve();
            }).catch(err => {
              return Promise.reject(err);
            });
          });
        }
        return Promise.resolve();
      }).catch(err => {
        return Promise.reject(err);
      });
      return Promise.resolve();
    }).catch(err => {
      return Promise.reject(err);
    });
  }
    else {
      throw new functions.https.HttpsError('invalid-argument', `Невозможно добавить ${item.name} в заказ. 
    Попробуйте попытку позднее.`);
    }
    return Promise.resolve();
  }).catch(err => {
    return Promise.reject(err);
    });
  });

  //delete item from basket
  exports.deleteItemFromBasket = functions.https.onCall((data, context) => {
    let itemID = data.itemID;
    let uid = context.auth.uid;
    let categoryID = data.categoryID;
    let dbItemID = data.dbItemID;
    admin.firestore().collection('users').doc(uid)
    .collection('basket').doc(itemID).get().then(doc => {
      let item = doc.data()
      let itemCount = item.count;
      admin.firestore().collection('users').doc(uid)
      .collection('basket').doc(itemID).delete().then(() => {
        admin.firestore().collection('categories').doc(categoryID)
        .collection('items').doc(dbItemID).get().then(snapshot => {
          item = snapshot.data();
          console.log(item);
          let newCount = item.count + itemCount;
          admin.firestore().collection('categories').doc(categoryID)
          .collection('items').doc(dbItemID).update({ count: newCount}).then(() => {
            console.log('deletion was succeed!');
            return Promise.resolve();
          }).catch(err => {
            return Promise.reject(err);
            });
            return Promise.resolve();
        }).catch(err => {
          return Promise.reject(err);
          });
          return Promise.resolve();
      }).catch(err => {
        return Promise.reject(err);
        });
        return Promise.resolve();
    }).catch(err => {
      return Promise.reject(err);
  });
});