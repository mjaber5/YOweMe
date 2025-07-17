// lib/widgets/push_notification_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/utils/constants/colors.dart';

class PushNotificationWidget extends StatefulWidget {
  final String title;
  final String message;
  final String? avatar;
  final Color? avatarColor;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final Duration duration;

  const PushNotificationWidget({
    super.key,
    required this.title,
    required this.message,
    this.avatar,
    this.avatarColor,
    this.icon,
    this.iconColor,
    this.onTap,
    this.onDismiss,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<PushNotificationWidget> createState() => _PushNotificationWidgetState();
}

class _PushNotificationWidgetState extends State<PushNotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideController.forward();
    _fadeController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _slideController.reverse();
    await _fadeController.reverse();
    if (widget.onDismiss != null) {
      widget.onDismiss!();
    }
    if (mounted) {
      Navigator.of(context).pop(); // Remove widget from the tree
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            shadowColor: Colors.black.withOpacity(0.3),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.white.withOpacity(0.95)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryTeal.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      if (widget.onTap != null) {
                        widget.onTap!();
                      }
                      _dismiss();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Avatar or Icon
                          widget.avatar != null ? _buildAvatar() : _buildIcon(),
                          const SizedBox(width: 12),

                          // Notification Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryText,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondaryText,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Dismiss Button
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryTeal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                LucideIcons.x,
                                size: 18,
                                color: AppColors.primaryTeal,
                              ),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                _dismiss();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.avatarColor ?? AppColors.primaryTeal,
            (widget.avatarColor ?? AppColors.primaryTeal).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          widget.avatar!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: (widget.iconColor ?? AppColors.primaryTeal).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        widget.icon ?? LucideIcons.bell,
        size: 20,
        color: widget.iconColor ?? AppColors.primaryTeal,
      ),
    );
  }
}
