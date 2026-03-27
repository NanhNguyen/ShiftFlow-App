import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/model/notification_model.dart';
import '../../../theme/app_theme.dart';

/// A widget that wraps the main body and shows an in-app banner notification
/// sliding down from the top whenever a new unread notification arrives.
class InAppNotificationOverlay extends StatefulWidget {
  final Widget child;
  final List<NotificationModel> notifications;
  final int unreadCount;

  const InAppNotificationOverlay({
    super.key,
    required this.child,
    required this.notifications,
    required this.unreadCount,
  });

  @override
  State<InAppNotificationOverlay> createState() =>
      _InAppNotificationOverlayState();
}

class _InAppNotificationOverlayState extends State<InAppNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  NotificationModel? _currentNotif;
  Timer? _hideTimer;
  bool _hasShownInitial = false;
  int _lastShownUnreadCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void didUpdateWidget(InAppNotificationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newCount = widget.unreadCount;
    final newNotifs = widget.notifications;

    final shouldShow =
        newNotifs.isNotEmpty &&
        newCount > 0 &&
        (!_hasShownInitial || newCount > _lastShownUnreadCount);

    if (shouldShow) {
      _hasShownInitial = true;
      _lastShownUnreadCount = newCount;
      final unreadList = newNotifs.where((n) => !n.isRead).toList();
      if (unreadList.isNotEmpty) {
        _showBanner(unreadList.first);
      }
    }
  }

  void _showBanner(NotificationModel notif) {
    _hideTimer?.cancel();
    setState(() => _currentNotif = notif);
    _controller.forward(from: 0);
    _hideTimer = Timer(const Duration(seconds: 4), _hideBanner);
  }

  void _hideBanner() {
    if (mounted) {
      _controller.reverse().then((_) {
        if (mounted) setState(() => _currentNotif = null);
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_currentNotif != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _BannerCard(
                  notification: _currentNotif!,
                  onDismiss: _hideBanner,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onDismiss;

  const _BannerCard({required this.notification, required this.onDismiss});

  IconData get _icon {
    switch (notification.type) {
      case 'REQUEST_APPROVED':
        return Icons.check_circle_rounded;
      case 'REQUEST_REJECTED':
        return Icons.cancel_rounded;
      case 'REQUEST_CREATED':
        return Icons.add_circle_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get _iconColor {
    switch (notification.type) {
      case 'REQUEST_APPROVED':
        return InternaCrystal.accentGreen;
      case 'REQUEST_REJECTED':
        return InternaCrystal.accentRed;
      case 'REQUEST_CREATED':
        return InternaCrystal.accentPurple;
      default:
        return InternaCrystal.accentPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: InternaCrystal.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _iconColor.withOpacity(0.3), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _iconColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, color: _iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: InternaCrystal.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.message,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: InternaCrystal.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDismiss,
              child: Icon(Icons.close, color: InternaCrystal.textMuted, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
