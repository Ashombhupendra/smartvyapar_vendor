importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.20.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyB3mzX26wHMalPoYpruw1X73XAf-kP4mCY",
  authDomain: "smartvyapaar2025.firebaseapp.com",
  projectId: "smartvyapaar2025",
  storageBucket: "smartvyapaar2025.firebasestorage.app",
  messagingSenderId: "996442516867",
  appId: "1:1000163153346:web:4f702a4b5adbd5c906b25b",
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});