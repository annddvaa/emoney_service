import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool light;
  final bool withText;

  const AppLogo({super.key, this.size = 56, this.light = false, this.withText = false});

  @override
  Widget build(BuildContext context) {
    const fontFamily = 'PlusJakartaSans';

    // Gunakan parameter size agar ukurannya dinamis, tapi kita kalikan
    // faktor skala (misal 1.5) agar logo baru yang mungkin punya padding terlihat lebih besar
    final double displaySize = size * 1.5;

    Widget icon = Image.asset(
      'assets/icons/logoservicepay.png',
      width: displaySize,
      height: displaySize,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: displaySize,
          height: displaySize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.account_balance_wallet_rounded,
            size: size * 0.6,
            color: Colors.white,
          ),
        );
      },
    );

    if (!withText) return icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Pay',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: size * 0.3,
                fontWeight: FontWeight.w800,
                color: light ? Colors.white : AppColors.ink,
                letterSpacing: -0.3,
                height: 1.05,
              ),
            ),
            Text(
              'REPAIR & SERVICE',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: size * 0.16,
                fontWeight: FontWeight.w700,
                color: light ? Colors.white.withValues(alpha: 0.85) : AppColors.primary,
                letterSpacing: 1.2,
                height: 1.05,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
