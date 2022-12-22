// Executed by MongoDB

db = db.getSiblingDB('data_v1');

// Fill in the push notification keys
db.App.insert({
  "name": "Crownstone.consumer",
  "pushSettings": {
    "apns":{
      "keyToken":"-----BEGIN PRIVATE KEY-----\nABCDEFG\n-----END PRIVATE KEY-----",
      "keyId" : "1234",
      "teamId" : "AB12"
    },
    "gcm": {
      "serverApiKey": "ABCD"
    }
  }
});
