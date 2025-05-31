import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

interface Message {
  content: string;
  senderId: string;
  receiverId: string;
  type: string;
}

interface UserData {
  displayName?: string;
  token?: string;
}

interface GroupData {
  name?: string;
}

// Sohbet mesajları için bildirim gönderme
export const sendChatMessageNotification = functions.firestore
  .document("chat_rooms/{chatId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    try {
      console.log("=== Yeni Mesaj Bildirimi Başladı ===");
      const message = snap.data() as Message;
      const chatId = context.params.chatId;

      if (!message || !message.senderId || !message.receiverId) {
        console.error("Geçersiz mesaj verisi:", message);
        return null;
      }

      // Mesajı gönderen kullanıcının bilgilerini al
      const senderDoc = await admin.firestore()
        .collection("Users")
        .doc(message.senderId)
        .get();

      if (!senderDoc.exists) {
        console.error("Gönderen kullanıcı bulunamadı:", message.senderId);
        return null;
      }

      const senderData = senderDoc.data() as UserData;
      console.log("Gönderen kullanıcı bilgileri:", JSON.stringify(senderData));

      // Alıcı kullanıcının token'ını al
      const receiverDoc = await admin.firestore()
        .collection("Users")
        .doc(message.receiverId)
        .get();

      if (!receiverDoc.exists) {
        console.error("Alıcı kullanıcı bulunamadı:", message.receiverId);
        return null;
      }

      const receiverData = receiverDoc.data() as UserData;
      const receiverToken = receiverData?.token;

      if (!receiverToken) {
        console.error("Alıcı token'ı bulunamadı");
        return null;
      }

      // Bildirim mesajını oluştur
      const notification = {
        title: senderData?.displayName || "Yeni Mesaj",
        body: message.content,
      };

      const data = {
        chatId: chatId,
        messageId: snap.id,
        type: "chat",
        senderId: message.senderId,
      };

      // Doğrudan cihaza bildirim gönder
      const messagePayload = {
        token: receiverToken,
        notification: notification,
        data: data,
        android: {
          priority: "high" as const,
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
            },
          },
        },
      };

      console.log("Bildirim gönderiliyor:", JSON.stringify(messagePayload));
      const response = await admin.messaging().send(messagePayload);
      console.log("Bildirim gönderme yanıtı:", JSON.stringify(response));
      console.log("=== Yeni Mesaj Bildirimi Tamamlandı ===");
      return response;
    } catch (error) {
      console.error("Bildirim gönderme hatası:", error);
      throw error;
    }
  });

// Grup mesajları için bildirim gönderme
export const sendGroupMessageNotification = functions.firestore
  .document("groups/{groupId}/messages/{messageId}")
  .onCreate(async (snap, context) => {
    try {
      console.log("=== Yeni Grup Mesajı Bildirimi Başladı ===");
      const message = snap.data() as Message;
      const groupId = context.params.groupId;

      if (!message || !message.senderId) {
        console.error("Geçersiz mesaj verisi:", message);
        return null;
      }

      // Mesajı gönderen kullanıcının bilgilerini al
      const senderDoc = await admin.firestore()
        .collection("Users")
        .doc(message.senderId)
        .get();

      if (!senderDoc.exists) {
        console.error("Gönderen kullanıcı bulunamadı:", message.senderId);
        return null;
      }

      const senderData = senderDoc.data() as UserData;

      // Grup bilgilerini al
      const groupDoc = await admin.firestore()
        .collection("groups")
        .doc(groupId)
        .get();

      if (!groupDoc.exists) {
        console.error("Grup bulunamadı:", groupId);
        return null;
      }

      const groupData = groupDoc.data() as GroupData;

      // Bildirim mesajını oluştur
      const notification = {
        title: `${senderData?.displayName || "Birisi"} - ${groupData?.name || "Grup"}`,
        body: message.content,
      };

      const data = {
        groupId: groupId,
        messageId: snap.id,
        type: "group",
        senderId: message.senderId,
      };

      const messagePayload = {
        topic: `group_${groupId}`,
        notification: notification,
        data: data,
        android: {
          priority: "high" as const,
        },
        apns: {
          payload: {
            aps: {
              contentAvailable: true,
            },
          },
        },
      };

      console.log("Grup bildirimi gönderiliyor:", JSON.stringify(messagePayload));
      const response = await admin.messaging().send(messagePayload);
      console.log("Grup bildirimi gönderme yanıtı:", JSON.stringify(response));
      console.log("=== Yeni Grup Mesajı Bildirimi Tamamlandı ===");
      return response;
    } catch (error) {
      console.error("Grup bildirimi gönderme hatası:", error);
      throw error;
    }
  });
