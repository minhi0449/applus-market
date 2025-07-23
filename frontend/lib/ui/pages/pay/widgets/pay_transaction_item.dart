import 'package:flutter/material.dart';

import '../../../../_core/components/theme.dart';

/**
 * 2025.01.22 - 김민희 : PayMoneyCard 컴포넌트 화
 */

class PayTransactionItem extends StatelessWidget {
  final String title;
  final String date;
  final String type;
  final int amount;
  final String? iconPath;
  final bool showBorder; // 새로운 매개변수 추가

  const PayTransactionItem({
    super.key,
    required this.title,
    required this.date,
    required this.type,
    required this.amount,
    this.iconPath,
    this.showBorder = true, // 기본값은 true (테두리 표시)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: APlusTheme.spacingM,
        horizontal: APlusTheme.spacingM,
      ),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(
                bottom: BorderSide(color: APlusTheme.tertiarySystemBackground),
              )
            : null, // showBorder가 false면 테두리 없음
      ),
      child: Row(
        children: [
          if (iconPath != null) ...[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(APlusTheme.radiusS),
                image: DecorationImage(
                  image: AssetImage(iconPath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: APlusTheme.spacingM),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CustomTextTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: APlusTheme.spacingXS),
                Text(
                  '$date $type',
                  style: CustomTextTheme.bodyMedium?.copyWith(
                    color: APlusTheme.labelSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${amount > 0 ? '+' : ''}${amount}원',
            style: CustomTextTheme.titleMedium?.copyWith(
              color: amount > 0
                  ? APlusTheme.successColor
                  : APlusTheme.labelPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
