import dotenv from "dotenv";
dotenv.config();

import mongoose from "mongoose";
import { WebSocketServer } from "ws";

/* 
   MongoDB Connect
 */
await mongoose.connect(process.env.MONGO_URI);
console.log("MongoDB connected");

/* 
   Schema / Model
 */
const Sensor = mongoose.model(
    "Sensor",
    new mongoose.Schema({}, { strict: false }),
    "sensordatas"
);

/* 
   Test: lấy data mới nhất
 */
const latest = await Sensor.findOne()
    .sort({ timestamp: -1 })
    .lean();

console.log("Latest data:", latest);

/* 
   WebSocket Server
 */
const wss = new WebSocketServer({ port: 8080 });
console.log("WSS running on ws://localhost:8080");

wss.on("connection", async ws => {
    console.log("🔌 Client connected");

    // gửi data mới nhất ngay khi client connect
    const last = await Sensor.findOne()
        .sort({ timestamp: -1 })
        .lean();

    if (last) {
        ws.send(JSON.stringify(last));
    }
});

/* 
   MongoDB Change Stream
*/
const changeStream = Sensor.watch([
    { $match: { operationType: "insert" } }
]);

changeStream.on("change", change => {
    const d = change.fullDocument;

    const payload = {
        location: d.location,
        temp: d.temp,
        hum: d.hum,
        pres: d.pres,
        aqi: d.aqi,
        pm25: d.pm25,
        timestamp: d.timestamp
    };

    wss.clients.forEach(c => {
        if (c.readyState === 1) {
            c.send(JSON.stringify(payload));
        }
    });

    console.log("📡 Sent realtime:", payload);
});

changeStream.on("error", err => {
    console.error("Change stream error:", err);
});
