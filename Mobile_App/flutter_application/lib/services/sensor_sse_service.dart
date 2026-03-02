import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SensorSSEService {
  final StreamController<Map<String, dynamic>> _dataController = 
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;

  http.Client? _client;
  bool isConnected = false;

  Future<void> connect() async {
    if (isConnected) return;
    
    const String url = 'https://nonfecund-unvenerative-judi.ngrok-free.dev/api/sensor-realtime/stream';
    
    try {
      print('Attempting SSE connection to: $url');
      
      _client = http.Client();
      
      final request = http.Request('GET', Uri.parse(url));
      request.headers.addAll({
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
        'User-Agent': 'Flutter-SSE-App/1.0',
      });

      final response = await _client!.send(request).timeout(Duration(seconds: 10));
      
      print('SSE response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        isConnected = true;
        print('SSE connection established');
        
        // Process SSE stream
        _processSSEStream(response.stream);
      } else {
        print('SSE connection failed with status: ${response.statusCode}');
        isConnected = false;
      }
    } catch (e) {
      print('SSE connection error: $e');
      print('Error type: ${e.runtimeType}');
      isConnected = false;
    }
  }

  void _processSSEStream(Stream<List<int>> stream) {
    print('Processing SSE stream...');
    
    String? currentData;
    
    stream.transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          final chunk = utf8.decode(data);
          sink.add(chunk);
        },
      ),
    ).transform(
      StreamTransformer.fromHandlers(
        handleData: (chunk, sink) {
          final chunkString = chunk.toString();
          final lines = chunkString.split('\n');
          for (final line in lines) {
            if (line.isNotEmpty && !line.startsWith(':')) {
              sink.add(line);
            }
          }
        },
      ),
    ).listen(
      (line) {
        print('SSE data line: $line');
        
        final lineString = line.toString();
        
        if (lineString.startsWith('data:')) {
          currentData = lineString.substring(5).trim(); // Remove 'data:' prefix
        } else if (lineString.startsWith('event:') && currentData != null) {
          // When we see an event line and have data, process the data
          if (currentData!.isNotEmpty) {
            try {
              final jsonData = jsonDecode(currentData!) as Map<String, dynamic>;
              print('Parsed SSE data: $jsonData');
              _dataController.add(jsonData);
              print('SSE data added to stream');
            } catch (e) {
              print('Error parsing SSE data: $e');
              print('Raw SSE data: $currentData');
            }
          }
          currentData = null; // Reset for next event
        }
      },
      onError: (error) {
        print('SSE stream error: $error');
        isConnected = false;
      },
      onDone: () {
        print('SSE stream completed');
        isConnected = false;
      },
    );
  }

  void disconnect() {
    _client?.close();
    _client = null;
    isConnected = false;
    print('SSE connection closed');
  }

  void dispose() {
    disconnect();
    _dataController.close();
  }
}
