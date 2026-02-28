import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../models/news_model.dart';

class NewsWebViewInAppScreen extends StatefulWidget {
  final NewsArticle article;

  const NewsWebViewInAppScreen({
    super.key,
    required this.article,
  });

  @override
  State<NewsWebViewInAppScreen> createState() => _NewsWebViewInAppScreenState();
}

class _NewsWebViewInAppScreenState extends State<NewsWebViewInAppScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        title: Text(
          widget.article.source,
          style: const TextStyle(
            color: Color(0xFF1A2340),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF1A2340),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Color(0xFF1A2340),
            ),
            onPressed: () => _webViewController?.reload(),
          ),
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Color(0xFF1A2340),
            ),
            onPressed: _shareArticle,
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.article.link)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              supportZoom: false,
              builtInZoomControls: false,
              displayZoomControls: false,
              userAgent: "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36",
              // Performance optimizations
              cacheEnabled: true,
              clearCache: false,
              domStorageEnabled: true,
              databaseEnabled: true,
              // Security
              allowsInlineMediaPlayback: true,
              mediaPlaybackRequiresUserGesture: false,
              mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
                _errorMessage = '';
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
            },
            onReceivedError: (controller, request, error) {
              setState(() {
                _isLoading = false;
                _errorMessage = error.description;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              // Allow all URLs to load
              return NavigationActionPolicy.ALLOW;
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Đang tải bài viết...',
                      style: TextStyle(
                        color: Color(0xFF8A94A6),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_errorMessage.isNotEmpty)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Lỗi tải bài viết',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A2340),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8A94A6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _webViewController?.reload(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _shareArticle() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng chia sẻ sẽ được cập nhật'),
        backgroundColor: Color(0xFF2196F3),
      ),
    );
  }
}
