// Initialize functions, admin, and firestore database.
const { onCall } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const uuid = require("uuid");

try {
  admin.initializeApp(process.env.firebase);
} catch (e) {
  // This is expected to happen if the app is already initialized.
}

// const db = admin.firestore();
const chasterApiKey = process.env.CHASTER_API_KEY;

(exports) = module.exports = onCall(async (request) => {
  const partnerConfigurationToken = request.data.partnerConfigurationToken;

  // Get session data from Chaster API
  const configuration = await (await fetch(`https://api.chaster.app/api/extensions/configurations/${partnerConfigurationToken}`, {
    headers: {
      "Authorization": `Bearer ${chasterApiKey}`,
    },
  })).json();

  console.log("Configuration", configuration);

  if (configuration &&
    configuration.config &&
    configuration.config.extensionId) {
    return configuration.config.extensionId;
  }

  const id = uuid.v4();
  console.log("No configuration found, generating new ID", id);
  // PUT new configuration
  await fetch(`https://api.chaster.app/api/extensions/configurations/${partnerConfigurationToken}`, {
    method: "PUT",
    headers: {
      "Authorization": `Bearer ${chasterApiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      config: {
        extensionId: id,
      },
    }),
  });

  return id;
});
