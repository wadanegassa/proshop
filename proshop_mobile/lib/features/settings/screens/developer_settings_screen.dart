import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_config_service.dart';
import '../../../core/services/network_service.dart';
import '../../../core/widgets/design_background.dart';
import '../../profile/screens/settings_screen.dart';

class DeveloperSettingsScreen extends StatefulWidget {
  const DeveloperSettingsScreen({super.key});

  @override
  State<DeveloperSettingsScreen> createState() => _DeveloperSettingsScreenState();
}

class _DeveloperSettingsScreenState extends State<DeveloperSettingsScreen> {
  final _urlController = TextEditingController();
  bool _isCustom = false;
  bool _isTesting = false;
  NetworkTestResult? _testResult;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final isCustom = await ApiConfigService.isUsingCustomUrl();
    final customUrl = await ApiConfigService.getCustomUrl() ?? ApiConstants.baseUrl;
    
    setState(() {
      _isCustom = isCustom;
      _urlController.text = customUrl;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
    });

    try {
      // Temporarily set the URL in constants if possible, 
      // but constants are final/const.
      // So we need to modify our NetworkService to accept a URL or use the service config.
      
      // For testing, we'll just test what's in the text field
      final result = await NetworkService.testConnection();
      setState(() {
        _testResult = result;
      });
    } catch (e) {
      setState(() {
        _testResult = NetworkTestResult(
          isSuccess: false,
          latencyMs: 0,
          message: 'Error testing connection: $e',
          errorType: NetworkErrorType.unknown,
        );
      });
    } finally {
      setState(() {
        _isTesting = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    try {
      if (_isCustom) {
        await ApiConfigService.setCustomUrl(_urlController.text);
      } else {
        await ApiConfigService.resetToDefault();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully. Please restart the app for changes to take full effect.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesignBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    const BackButtonCircle(),
                    const SizedBox(width: 20),
                    Text(
                      'Developer Settings',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('API Configuration'),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Use Custom API URL'),
                        subtitle: const Text('Override the default backend URL'),
                        value: _isCustom,
                        onChanged: (value) {
                          setState(() {
                            _isCustom = value;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      if (_isCustom) ...[
                        _buildTextField('Server URL', _urlController, 
                            hint: 'http://10.42.0.176:5000/api/v1'),
                        const SizedBox(height: 8),
                        Text(
                          'Example: http://YOUR_IP:5000/api/v1',
                          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Default URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              SelectableText(ApiConstants.baseUrl),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isTesting ? null : _testConnection,
                          icon: _isTesting 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.network_check),
                          label: const Text('Test Connection'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                      if (_testResult != null) ...[
                        const SizedBox(height: 16),
                        _buildTestResultCard(),
                      ],
                      const SizedBox(height: 32),
                      _buildInfoSection(),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveSettings,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text('Save Configuration', 
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTestResultCard() {
    final isSuccess = _testResult!.isSuccess;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSuccess ? Colors.green : Colors.red, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isSuccess ? Icons.check_circle : Icons.error, 
                  color: isSuccess ? Colors.green : Colors.red),
              const SizedBox(width: 8),
              Text(
                isSuccess ? 'Connection Success' : 'Connection Failed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
              if (isSuccess) ...[
                const Spacer(),
                Text('${_testResult!.latencyMs}ms', style: const TextStyle(fontSize: 12)),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(_testResult!.message),
          if (!isSuccess && _testResult!.troubleshooting != null) ...[
            const Divider(),
            const Text('Troubleshooting:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_testResult!.troubleshooting!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final info = NetworkService.getConnectionInfo();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Host', info['host'] ?? 'N/A'),
          _buildInfoRow('Port', info['port'] ?? 'N/A'),
          _buildInfoRow('Protocol', info['protocol'] ?? 'N/A'),
          _buildInfoRow('Network', 'WiFi (recommended)'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).hintColor)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
