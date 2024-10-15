import admin from "firebase-admin";
import express from "express";

const app = express();

app.use(express.json());

admin.initializeApp({ credential: admin.credential.cert("admin.json") });

//This endpoint will send silent push notification to the device which will trigger the background task
app.post("/send-silent-push", (req, res) => {
  const deviceToken = req.body.deviceToken;
  const data = req.body.data;

  sendPushNotification(deviceToken, data);
  return res.send({
    message: `Silent notification sent to the device ${deviceToken}`,
  });
});

async function sendPushNotification(token: string, data: Record<string, any>) {
  try {
    const message: admin.messaging.Message = {
      data: data,
      token: token,
    };

    const response = await admin.messaging().send(message);
    console.log("Successfully sent message:", response);
    return response;
  } catch (error) {
    console.error("Error sending message:", error);
    throw error;
  }
}

app.listen(3000, () => {
  console.log("Server started on port 3000");
});
