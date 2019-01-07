const functions = require('firebase-functions');
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

var msgData;

exports.offerTrigger = functions.firestore.document(
    "events/{eventsId}"
).onCreate((snapshot, context)=>{
    msgData = snapshot.data();

    admin.firestore().collection("users").get().then((snapshots)=>{
        var tokens = [];
        if(snapshots.empty){
            console.log("No users");
        }else{
            for ( var user of snapshots.docs){
                // firebaseToken is in users collections
                tokens.push(user.data().firebaseToken);
            }
            
            var payload = {
                "notification": {
                    "title": msgData.title,
                    "body": msgData.info,
                    "sound": "default"
                },
                "data": {
                    "sendername": "NSS Tezpur University",
                    "message": msgData.info
                }
            }

            return admin.messaging().sendToDevice(tokens, payload).then((res)=>{
                console.log("Pushed all notifications");
            }).catch((err)=>{
                console.log(err);
            });
        }
    }); 
});
