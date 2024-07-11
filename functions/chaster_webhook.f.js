// Initialize functions, admin, and firestore database.
const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

try {
  admin.initializeApp(process.env.firebase);
} catch (e) {
  // This is expected to happen if the app is already initialized.
}

const db = admin.firestore();

(exports) = module.exports = onRequest(async (request, response) => {
  const payload = request.body.payload;
  const { event, data } = payload;

  if (event !== "extension_session.created" &&
    event !== "extension_session.deleted") {
    console.log(`Event not applicable: ${event}`);
    return response.status(200).send("Event not applicable");
  }

  const session = data.session;
  const sessionId = session.sessionId;

  if (event === "extension_session.created") {
    const config = data.config;
    const extensionId = config.extensionId;

    await db.collection("config").doc(extensionId).update({sessionId});

    console.log(`Extension session created: ${sessionId}`);
  }

  if (event === "extension_session.deleted") {
    const snapshots = db.collection("config")
        .where("sessionId", "==", sessionId)
        .get();
    if (snapshots.empty) {
      console.warn(`Extension not found: ${sessionId}`);
      return response.status(200).send("Extension not found");
    }

    for (const snapshot of snapshots.docs) {
      // Disable Obedience webhook.
      const extensionData = snapshot.data();
      await fetch(
          `https://app.obedienceapp.com/extensions/webhook?` +
          `extensionId=${snapshot.id}&` +
          `secret=${extensionData.extensionSecret}`,
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({
              url: "",
              habits: false,
              rewards: false,
              punishments: false,
            }),
          },
      );

      // Delete the extension.
      await snapshot.ref.delete();
    }

    console.log(`Extension session deleted: ${sessionId}`);
  }

  return response.status(200).send("OK");
});
