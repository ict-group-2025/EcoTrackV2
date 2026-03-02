import 'dart:async';
import '../services/sensor_sse_service.dart';
import '../models/sensor_data_model.dart';

class AirQualityController {
  final SensorSSEService _sseService = SensorSSEService();
  final SensorDataModel _model = SensorDataModel();
  
  // Stream controller for UI updates
  final StreamController<SensorDataModel> _dataController = 
      StreamController<SensorDataModel>.broadcast();

  Stream<SensorDataModel> get dataStream => _dataController.stream;
  SensorDataModel get model => _model;
  bool get isConnected => _sseService.isConnected;

  // Connect to SSE and start listening
  Future<void> connect() async {
    try {
      await _sseService.connect();
      
      // Listen to SSE data stream
      _sseService.dataStream.listen((data) {
        _model.updateFromJson(data);
        _dataController.add(_model);
      });
    } catch (e) {
      print('AirQualityController: Connection error - $e');
    }
  }

  // Disconnect from SSE
  void disconnect() {
    _sseService.disconnect();
  }

  // Get current data
  SensorDataModel getCurrentData() {
    return _model;
  }

  // Check if data is available
  bool get hasData => _model.lastUpdate != null;

  // Dispose resources
  void dispose() {
    disconnect();
    _dataController.close();
  }
}
