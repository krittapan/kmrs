if (typeof firebase === "undefined")
  throw new Error(
    "hosting/init-error: Firebase SDK not detected. You must include it before /__/firebase/init.js"
  );
firebase.initializeApp({
  apiKey: "AIzaSyBF-gjrVMB5w_HXT-mETU-SaIt7aIK-NIY",
  authDomain: "kukmrs.firebaseapp.com",
  projectId: "kukmrs",
  storageBucket: "kukmrs.appspot.com",
  messagingSenderId: "604681301186",
  appId: "1:604681301186:web:15f29e5dc082f15dc95f5b",
  measurementId: "G-FY75TDH4WR"
});
