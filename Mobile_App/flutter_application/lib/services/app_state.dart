import 'package:flutter/foundation.dart';
import '../models/data_models.dart';

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  // Mock data - in production, this would come from API
  WeatherData getWeatherData() {
    return WeatherData(
      temperature: 72,
      condition: 'Mostly Clear',
      highTemp: 78,
      lowTemp: 64,
      humidity: 42,
      windSpeed: 12,
      uvIndex: 'Low',
    );
  }

  AQIData getAQIData() {
    return AQIData(
      aqi: 42,
      quality: 'Good',
      description:
          'Air quality is acceptable. However, sensitive groups may experience minor health effects.',
    );
  }

  List<ForecastData> getForecastData() {
    return [
      ForecastData(time: 'Now', icon: 'sunny', temperature: 72, status: 'good'),
      ForecastData(
        time: '2 PM',
        icon: 'sunny',
        temperature: 75,
        status: 'good',
      ),
      ForecastData(
        time: '4 PM',
        icon: 'cloudy',
        temperature: 73,
        status: 'moderate',
      ),
      ForecastData(
        time: '6 PM',
        icon: 'cloudy',
        temperature: 68,
        status: 'moderate',
      ),
      ForecastData(
        time: '8 PM',
        icon: 'rainy',
        temperature: 64,
        status: 'good',
      ),
    ];
  }

  List<PollutantData> getPollutants() {
    return [
      PollutantData(
        symbol: 'PM',
        name: 'PM2.5',
        value: 12.4,
        unit: 'μg/m³',
        status: 'good',
      ),
      PollutantData(
        symbol: 'CO₂',
        name: 'CO2',
        value: 415,
        unit: 'ppm',
        status: 'moderate',
      ),
      PollutantData(
        symbol: 'O₃',
        name: 'OZONE',
        value: 0.02,
        unit: 'ppm',
        status: 'good',
      ),
      PollutantData(
        symbol: 'NO₂',
        name: 'NITROGEN',
        value: 8.1,
        unit: 'ppb',
        status: 'good',
      ),
    ];
  }

  List<NewsArticle> getNewsArticles() {
    return [
      NewsArticle(
        category: 'ENVIRONMENT',
        title: 'New urban green space initiatives reduce heat island...',
        timeAgo: '2 hours ago',
        readTime: '4 min read',
        imageUrl: 'https://picsum.photos/200/200',
      ),
      NewsArticle(
        category: 'HEALTH',
        title: 'How Clean Air Impacts Mental Clarity & Focus',
        timeAgo: 'Today',
        readTime: '5 min read',
        imageUrl: 'https://picsum.photos/201/201',
      ),
      NewsArticle(
        category: 'GLOBAL NEWS',
        title: 'New Regulations on Industrial Emissions...',
        timeAgo: 'Yesterday',
        readTime: '12 min read',
        imageUrl: 'https://picsum.photos/202/202',
      ),
    ];
  }

  List<CommunityMessage> getCommunityMessages() {
    return [
      CommunityMessage(
        userName: 'Alex Rivera',
        message:
            'The AQI in the downtown area is looking much better today! 🌿 Just walked to work!',
        timeAgo: '2m ago',
      ),
      CommunityMessage(
        userName: 'Sarah Jenkins',
        message:
            'Has anyone noticed the new sensors near the park? They look sleek!',
        timeAgo: '15m ago',
      ),
    ];
  }

  // List<SmartDevice> getSmartDevices() {
  //   return [
  //     SmartDevice(
  //       name: 'Purifier Max',
  //       location: 'Living Room',
  //       status: 'active',
  //       type: 'purifier',
  //     ),
  //     SmartDevice(
  //       name: 'Sensor Hub',
  //       location: 'Master Bedroom',
  //       status: 'standby',
  //       type: 'sensor',
  //     ),
  //   ];
  // }

  List<UserData> getUsers() {
    return [
      UserData(
        name: 'J. Miller',
        id: '#4952',
        lastActive: '2m ago',
        reports: 12,
      ),
      UserData(name: 'S. Kim', id: '#3102', lastActive: '1h ago', reports: 0),
      UserData(
        name: 'L. Turner',
        id: '#8021',
        lastActive: '3h ago',
        reports: 4,
      ),
    ];
  }

  List<ModerationItem> getModerationQueue() {
    return [
      ModerationItem(
        username: '@brandon_k',
        content:
            '"This air quality data seems completely wrong for my neighborhood. Don\'t trust it!"',
        timeAgo: '12m ago',
        type: 'Spam',
      ),
      ModerationItem(
        username: '@lisa_m',
        content: '[Content Hidden by Auto-filter]',
        timeAgo: '1h ago',
        type: 'Harassment',
      ),
    ];
  }
 
}
