import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_address_auto_complete.dart';
import 'package:spa_mobile/features/user/presentation/bloc/address/address_bloc.dart';

class AutofillAddress extends StatefulWidget {
  const AutofillAddress({super.key, required this.addressController});

  final TextEditingController addressController;

  @override
  State<AutofillAddress> createState() => _AutofillAddressState();
}

class _AutofillAddressState extends State<AutofillAddress> {
  Timer? _debounce;

  @override
  void dispose() {
    // widget.addressController.dispose();
    // _debounce?.cancel();
    super.dispose();
  }

  void _onAddressChanged(String address) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<AddressBloc>().add(GetListAddressEvent(GetAddressAutoCompleteParams(address)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      child: Column(
        children: [
          TextField(
            controller: widget.addressController,
            decoration: InputDecoration(
              hintText: 'Address',
              contentPadding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              prefixIcon: const TRoundedIcon(icon: Iconsax.home_2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onChanged: _onAddressChanged,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
            if (state is AddressLoaded) {
              final suggestions = state.address.take(4).toList();
              return ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final address = suggestions[index];
                  return ListTile(
                    title: Text(address.fullAddress),
                    onTap: () {
                      widget.addressController.text = address.fullAddress;
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            }
            return const SizedBox();
          })
        ],
      ),
    );
  }
}
