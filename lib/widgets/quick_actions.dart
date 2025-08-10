import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../l10n/app_localizations.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          localizations.quickActions,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickAction(
              context,
              icon: Icons.local_offer,
              label: localizations.offers,
              color: AppColors.warning,
              onTap: () {
                Navigator.pushNamed(context, '/coupons');
              },
            ),
            _buildQuickAction(
              context,
              icon: Icons.location_on,
              label: 'الأقرب لك',
              color: AppColors.success,
              onTap: () {
                Navigator.pushNamed(context, '/nearest');
              },
            ),
            _buildQuickAction(
              context,
              icon: Icons.favorite,
              label: localizations.favorites,
              color: AppColors.favorite,
              onTap: () {
                Navigator.pushNamed(context, '/favorites');
              },
            ),
            _buildQuickAction(
              context,
              icon: Icons.history,
              label: localizations.previousOrders,
              color: AppColors.info,
              onTap: () {
                Navigator.pushNamed(context, '/previous_orders');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

