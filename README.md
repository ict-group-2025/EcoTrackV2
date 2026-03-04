# EcoTrack V2 

## What is EcoTrack?
EcoTrack is a smart IoT (Internet of Things) system for monitoring the environment. It helps you collect, save, and check environmental data easily and quickly. 

## Project Structure
This project has 5 main parts. Each part is in its own folder:

* **Hardware**: Uses ESP32 sensors (C++) to collect data from the environment.
* **Backend**: Built with Java (Spring Boot) and MySQL to receive and save data safely.
* **Frontend**: A web dashboard made with ReactJS to see the data on your computer screen.
* **Mobile_App**: A mobile app made with Flutter (Dart) so you can check data on your phone anywhere.
* **AI**: Uses Python (Machine Learning) to analyze the data and make smart predictions.

## Main Folders
* `/AI` - Python code for data analysis.
* `/Backend` - Java server code.
* `/Frontend/FrontEnd_Demo2` - Website code.
* `/Hardware` - C++ code for the ESP32 device.
* `/Mobile_App` - Flutter code for the mobile application.

## How It Works
1.  The **Hardware** (ESP32) reads information from the environment (like temp,humidity, pm2.5).
2.  It sends this information to a **Node.js** server andsaves the data into a Mongo Alats database .
3.  Then, the main **Java Spring** backend saves the data into a MySQL database and handles the web and mobile app.
4.  You can open the **Frontend** website or the **Mobile App** to view the data in real-time.

## Getting Started
To run this project, you need to open each folder and follow the specific instructions inside them.
1. Flash the code to your ESP32.
2. Start the Spring Boot server in the Backend folder.
3. Run the Frontend website using `npm start`.
4. Run the Mobile App using `flutter run`.


