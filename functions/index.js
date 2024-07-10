// The Firebase Admin SDK.
const admin = require("firebase-admin");
admin.initializeApp(process.env.firebase);

// Set up database.
const db = admin.firestore();
const settings = { timestampsInSnapshots: true };
db.settings(settings);

/* Import all cloud functions from other files */
const glob = require("glob");
const files = glob.sync("./**/*.f.js", { cwd: __dirname });
for (let f = 0, fl = files.length; f < fl; f++) {
  const file = files[f];
  const functionName = file.split("/").pop().slice(0, -5); // Strip off '.f.js'
  if (
    !process.env.FUNCTION_NAME ||
    process.env.FUNCTION_NAME === functionName
  ) {
    exports[functionName] = require(file);
  }
}
