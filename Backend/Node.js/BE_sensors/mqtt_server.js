import dotenv from "dotenv";
dotenv.config();

import mqtt from "mqtt";
import mongoose from "mongoose";

/* evn */
const { MQTT_BROKER, MQTT_TOPIC, MONGO_URI } = process.env;

/* monggodb*/
await mongoose.connect(MONGO_URI);
console.log("✅ MongoDB connected");

/*model */
const SensorSchema = new mongoose.Schema({
    location: { type: String, default: "Home_Hanoi" },
    temp: Number,
    hum: Number,
    pres: Number,
    aqi: Number,
    pm25: Number,
    altitude: Number,
    eco2: Number,
    tvoc: Number,
    timestamp: { type: Date, default: Date.now }
});

const SensorData = mongoose.model(
    "SensorData",
    SensorSchema,
    "sensordatas"
);

const client = mqtt.connect(MQTT_BROKER);

client.on("connect", () => {
    console.log(" MQTT connected");
    client.subscribe(MQTT_TOPIC);
});

client.on("message", async (topic, message) => {
    try {
        const data = JSON.parse(message.toString());

        if (!data.temp && !data.pm25) return;

        const newData = new SensorData({
            temp: data.temp,
            hum: data.hum,
            pres: data.pres,
            aqi: data.aqi,
            pm25: data.pm25 || data["pm2.5"],
            altitude: data.altitude,
            eco2: data.eco2,
            tvoc: data.tvoc
        });

        await newData.save();
        console.log(" Saved:", newData.temp);

    } catch (err) {
        console.error(" MQTT parse error:", err.message);
    }
});
