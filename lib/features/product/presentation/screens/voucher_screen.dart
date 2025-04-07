import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/utils/formatters/formatters.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key, required this.voucherModel});

  final VoucherModel voucherModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: Colors.blue), // Icon for code
              const SizedBox(width: 8),
              Expanded(child: Text('Code: ${voucherModel.code}', style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
          const SizedBox(height: 8),

          // Description
          Row(
            children: [
              Icon(Icons.description, color: Colors.blue), // Icon for description
              const SizedBox(width: 8),
              Expanded(child: Text('Description: ${voucherModel.description}', style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
          const SizedBox(height: 8),

          // Discount Amount
          Row(
            children: [
              Icon(Icons.money_off, color: Colors.green), // Icon for discount amount
              const SizedBox(width: 8),
              Expanded(
                  child: Text('Discount Amount: ${formatMoney(voucherModel.discountAmount.toString())}',
                      style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
          const SizedBox(height: 8),

          // Valid From
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.orange), // Icon for valid from
              const SizedBox(width: 8),
              Expanded(
                  child: Text('Valid From: ${DateFormat('EEEE, dd MMMM yyyy', 'vi').format(voucherModel.validFrom.toLocal())}',
                      style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
          const SizedBox(height: 8),

          // Valid To
          Row(
            children: [
              Icon(Icons.access_alarm, color: Colors.red), // Icon for valid to
              const SizedBox(width: 8),
              Expanded(
                  child: Text('Valid From: ${DateFormat('EEEE, dd MMMM yyyy', 'vi').format(voucherModel.validTo.toLocal())}',
                      style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
        ],
      ),
    );
  }
}
