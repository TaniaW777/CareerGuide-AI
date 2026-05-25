import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/connectivity_provider.dart';

/// Widget pour afficher le statut de connectivité
class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, child) {
        final isOnline = connectivityProvider.isConnected;
        final connectionLabel = connectivityProvider.connectionLabel;
        final statusLabel = connectivityProvider.modeLabel;
        final backgroundColor = connectivityProvider.isBackendOnline
            ? (connectivityProvider.isGemmaReady ? Color(0xFF2E7D32) : Color(0xFFF9A825))
            : (isOnline ? Color(0xFFE65100) : Color(0xFFC62828));

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connectionLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusLabel,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (connectivityProvider.offlineFirstMode)
                Tooltip(
                  message: 'Mode offline-first activé',
                  child: const Icon(Icons.cloud_off, color: Colors.white, size: 18),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Badge compact pour afficher dans la barre d'app
class ConnectionStatusBadge extends StatelessWidget {
  const ConnectionStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, child) {
        final isOnline = connectivityProvider.isConnected;
        final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isOnline 
              ? (isDarkTheme ? Color(0xFF2E7D32) : Color(0xFF4CAF50))
              : (isDarkTheme ? Color(0xFFC62828) : Color(0xFFF44336)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 8,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 6),
              Text(
                connectivityProvider.connectionLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
