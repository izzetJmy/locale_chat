import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

export const sendNotifications = functions.firestore
  .document("SingleChats/{chatID}/Messages/{messageID}")
  .onCreate(async (snapshot, context) => {
    const {content, senderId} = snapshot.data();
    const {chatID} = context.params;
    const converstaion = await db.collection("SingleChats").doc(chatID)
      .get();
    const members: string[] = converstaion.get("members");

    members.filter((member)=> member !== senderId)
      .forEach(async (value, index) => {
        const profile = await db.collection("Users").doc(value).get();
        const token = profile.get("token");
        if (!token) {
          return;
        }
        await admin.messaging().sendToDevice(token, {
          data: {
            chatID,
          },
          notification: {
            title: "You have a message",
            body: content,
          },

        });
      });
  });
