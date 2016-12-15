import * as firebase from "firebase";

class Firebase {
  static initialise() {
    firebase.initializeApp({
      apiKey: "AIzaSyDz1rvxuYDgsqMrGMdZ4iBIOqUBGETAo04",
      authDomain: "swamphacks-confirmed-attendees.firebaseapp.com",
      databaseURL: "https://swamphacks-confirmed-attendees.firebaseio.com",
      storageBucket: "swamphacks-confirmed-attendees.appspot.com",
      messagingSenderId: "1008919618491"
    });
  }
}

module.exports = Firebase;
