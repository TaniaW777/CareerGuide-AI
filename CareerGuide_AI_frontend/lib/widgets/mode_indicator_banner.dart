import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/connectivity_provider.dart';

/// Widget affichant l'indicateur de mode online/offline
class ModeIndicatorBanner extends StatelessWidget {
  const ModeIndicatorBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        final color = (connectivity.isBackendOnline && connectivity.isGemmaReady)
            ? Colors.green[700]!
            : connectivity.isBackendOnline
                ? Colors.amber[700]!
                : Colors.red[700]!;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                connectivity.modeLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (connectivity.isBackendOnline && !connectivity.isGemmaReady)
                const SizedBox(
                  width: 60,
                  height: 16,
                  child: LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.amber,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
