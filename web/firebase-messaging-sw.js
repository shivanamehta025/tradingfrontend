importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"
);

importScripts(
  "https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js"
);

firebase.initializeApp({

  apiKey: "AIzaSyAWBceq-JXxrWuILWk0rhy6CjpC7o3jS1A",

  authDomain:
      "myautoshop-394f2.firebaseapp.com",

  projectId:
      "myautoshop-394f2",

  storageBucket:
      "myautoshop-394f2.firebasestorage.app",

  messagingSenderId:
      "754396208118",

  appId:
      "1:754396208118:web:6859824d9b00b2694545d7",
});

const messaging =
    firebase.messaging();