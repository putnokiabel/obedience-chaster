// Initialize functions, admin, and firestore database.
const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

try {
  admin.initializeApp(process.env.firebase);
} catch (e) {
  // This is expected to happen if the app is already initialized.
}

const db = admin.firestore();
const chasterApiKey = process.env.CHASTER_API_KEY;

(exports) = module.exports = onRequest(async (request, response) => {
  console.log(request.body);
  const {type, extensionId, secret, before, after} = request.body;

  if (type != "reward" && type != "punishment") {
    console.log(`Type not applicable: ${type}`);
    return response.status(200).send("Type not applicable");
  }

  const amountBefore = before.amount;
  const amountAfter = after.amount;
  if (amountBefore == null || amountAfter == null) {
    console.warn("Amount not found");
    return response.status(200).send("Amount not found");
  }

  const amountDifference = amountAfter - amountBefore;
  if (amountDifference <= 0) {
    console.log(`Amount difference is not positive: ${amountDifference}`);
    return response.status(200).send("Amount difference is not positive");
  }

  const extension = await db.collection("config").doc(extensionId).get();
  const extensionData = extension.data();
  if (!extension.exists || extensionData.extensionSecret != secret) {
    console.error(`Unauthorized: ${extensionId}`);
    return response.status(200).send("Unauthorized");
  }

  const {
    rewardId,
    rewardMinutes,
    punishmentId,
    punishmentMinutes,
    sessionId,
  } = extensionData;

  if (!sessionId) {
    console.warn(`Session not found: ${extensionId}`);
    return response.status(200).send("Session not found");
  }

  if (type == "reward" &&
    rewardId == after.id &&
    rewardMinutes > 0) {
    // Subtract minutes from the session using Chaster API.
    const res = await fetch(`https://api.chaster.app/api/extensions/sessions/${sessionId}/action`, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${chasterApiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        action: {
          "name": "remove_time",
          "params": rewardMinutes * amountDifference * 60,
        },
      }),
    });
    console.log(await res.text());

    console.log(
        `Removed ${rewardMinutes * amountDifference} ` +
        `minutes from session ${sessionId}`,
    );
    return response.status(200).send("Success");
  }

  if (type == "punishment" &&
    punishmentId == after.id &&
    punishmentMinutes > 0) {
    // Add minutes to the session using Chaster API.
    const res = await fetch(`https://api.chaster.app/api/extensions/sessions/${sessionId}/action`, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${chasterApiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        action: {
          "name": "add_time",
          "params": punishmentMinutes * amountDifference * 60,
        },
      }),
    });

    console.log(await res.text());

    console.log(
        `Added ${punishmentMinutes * amountDifference} ` +
        `minutes to session ${sessionId}`,
    );
    return response.status(200).send("Success");
  }

  console.log(`No action applicable`);
  return response.status(200).send("Action not applicable");
});
