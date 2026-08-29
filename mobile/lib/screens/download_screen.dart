import 'package:flutter/material.dart';
import '../services/model_service.dart';
import 'question_flow_screen.dart';

enum DownloadDestination { questionnaire }

enum _DownloadState { idle, downloading, error, done }

class DownloadScreen extends StatefulWidget {
  final DownloadDestination destination;

  const DownloadScreen({
    super.key,
    this.destination = DownloadDestination.questionnaire,
  });

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with SingleTickerProviderStateMixin {
  final ModelService _modelService = ModelService();

  _DownloadState _state = _DownloadState.idle;
  int _progress = 0;
  String _statusText = "";
  String _errorMsg = "";

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _startDownload() {
    setState(() {
      _state = _DownloadState.downloading;
      _errorMsg = "";
      _progress = 0;
      _statusText = "Connexion en cours...";
    });

    _modelService.downloadModel(
      onProgress: (progress, speed, eta) {
        if (mounted) setState(() { _progress = progress; _statusText = eta; });
      },
      onComplete: () {
        if (mounted) {
          setState(() {
            _state = _DownloadState.done;
            _progress = 100;
            _statusText = "Installation terminée !";
          });
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const QuestionFlowScreen(),
                ),
              );
            }
          });
        }
      },
      onError: (error) {
        if (mounted) setState(() { _state = _DownloadState.error; _errorMsg = error; });
      },
    );
  }

  void _cancelDownload() {
    _modelService.cancelDownload();
    setState(() { _state = _DownloadState.idle; _progress = 0; _statusText = ""; });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0F52BA),
                Color(0xFF4A90E2),
                Color(0xFFF0F4F8),
                Colors.white,
                Colors.white,
              ],
              stops: [0.0, 0.35, 0.55, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ── Zone illustration ─────────────────────────────
                  SizedBox(
                    height: size.height * 0.32,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.10),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.16),
                          ),
                        ),
                        // Icône centrale
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F52BA).withOpacity(0.22),
                                blurRadius: 28,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: _buildCenterIcon(),
                        ),
                        // Badge IA locale
                        Positioned(
                          top: size.height * 0.035,
                          right: size.width * 0.17,
                          child: _Badge(
                            label: "IA locale",
                            color: const Color(0xFFFF9800),
                          ),
                        ),
                        // Badge Offline
                        Positioned(
                          bottom: size.height * 0.035,
                          left: size.width * 0.17,
                          child: _Badge(
                            label: "Hors-ligne",
                            icon: Icons.wifi_off_rounded,
                            color: const Color(0xFF0F52BA),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Titre ─────────────────────────────────────────
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'CareerGuide ',
                          style: TextStyle(
                            color: Color(0xFF0F52BA),
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                          ),
                        ),
                        TextSpan(
                          text: 'AI',
                          style: TextStyle(
                            color: Color(0xFFFF9800),
                            fontWeight: FontWeight.w800,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Installe le conseiller IA une seule fois.\nL\'app fonctionnera ensuite 100% sans connexion.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Card principale ───────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildModelInfo(),
                          if (_state != _DownloadState.idle) ...[
                            const SizedBox(height: 20),
                            _buildProgressZone(),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Bouton CTA ────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildCTA(),
                  ),

                  const SizedBox(height: 20),

                  // ── Chips info ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _InfoChip(icon: Icons.wifi_off_rounded, label: "Offline"),
                      const SizedBox(width: 10),
                      _InfoChip(icon: Icons.lock_outline_rounded, label: "Privé"),
                      const SizedBox(width: 10),
                      _InfoChip(icon: Icons.bolt_rounded, label: "1x install"),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenterIcon() {
    switch (_state) {
      case _DownloadState.downloading:
        return const Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(
            color: Color(0xFF0F52BA),
            strokeWidth: 3,
          ),
        );
      case _DownloadState.done:
        return const Icon(Icons.check_rounded,
            color: Color(0xFF0F52BA), size: 48);
      case _DownloadState.error:
        return const Icon(Icons.error_outline_rounded,
            color: Color(0xFFE53935), size: 48);
      default:
        return const Icon(Icons.smart_toy_outlined,
            color: Color(0xFF0F52BA), size: 48);
    }
  }

  Widget _buildModelInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F52BA).withOpacity(0.09),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.psychology_outlined,
              color: Color(0xFF0F52BA), size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Gemma 3 — Conseiller IA",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Color(0xFF0F52BA),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "570 MB • téléchargement unique",
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        if (_state == _DownloadState.done)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "✓ Installé",
              style: TextStyle(
                color: Colors.green,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressZone() {
    if (_state == _DownloadState.error) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935).withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFE53935).withOpacity(0.25)),
        ),
        child: Row(
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: Color(0xFFE53935), size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _errorMsg,
                style: const TextStyle(
                    color: Color(0xFFE53935), fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _state == _DownloadState.done
                  ? "Modèle installé ✓"
                  : "Téléchargement...",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF0F52BA),
              ),
            ),
            Text(
              "$_progress%",
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: Color(0xFFFF9800),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: _progress / 100,
            minHeight: 8,
            backgroundColor:
                const Color(0xFF0F52BA).withOpacity(0.10),
            valueColor: AlwaysStoppedAnimation<Color>(
              _state == _DownloadState.done
                  ? Colors.green
                  : const Color(0xFF0F52BA),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _statusText,
          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildCTA() {
    switch (_state) {
      case _DownloadState.idle:
        return ElevatedButton.icon(
          onPressed: _startDownload,
          icon: const Icon(Icons.download_rounded, size: 20),
          label: const Text(
            "Télécharger le conseiller IA",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F52BA),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 4,
            shadowColor:
                const Color(0xFF0F52BA).withOpacity(0.4),
          ),
        );

      case _DownloadState.downloading:
        return OutlinedButton.icon(
          onPressed: _cancelDownload,
          icon: const Icon(Icons.close_rounded, size: 18),
          label: const Text("Annuler",
              style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey[600],
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        );

      case _DownloadState.error:
        return ElevatedButton.icon(
          onPressed: _startDownload,
          icon: const Icon(Icons.refresh_rounded, size: 20),
          label: const Text("Réessayer",
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9800),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 4,
            shadowColor:
                const Color(0xFFFF9800).withOpacity(0.4),
          ),
        );

      case _DownloadState.done:
        return ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.check_rounded, size: 20),
          label: const Text("Installation terminée",
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
        );
    }
  }
}

// ─── Widgets internes ─────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _Badge({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF0F52BA).withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF0F52BA).withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF0F52BA)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF0F52BA),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}