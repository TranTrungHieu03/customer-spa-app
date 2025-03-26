import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/rounded_icon.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/data/models/address_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_address_auto_complete.dart';
import 'package:spa_mobile/features/user/presentation/bloc/address/address_bloc.dart';

class AutofillAddress extends StatefulWidget {
  const AutofillAddress({super.key, required this.addressSubController, required this.update});

  final Function(AddressModel) update;
  final TextEditingController addressSubController;

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
      try {
        // Thử add event
        context.read<AddressBloc>().add(GetListAddressEvent(GetAddressAutoCompleteParams(address)));
      } catch (e) {
        // Nếu Bloc bị đóng, tạo lại Bloc
        context.read<AddressBloc>().close();
        context.read<AddressBloc>().add(GetListAddressEvent(GetAddressAutoCompleteParams(address)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.sm),
      child: Column(
        children: [
          TextField(
            controller: widget.addressSubController,
            decoration: InputDecoration(
              hintText: 'Address',
              contentPadding: const EdgeInsets.symmetric(horizontal: TSizes.md),
              prefixIcon: const TRoundedIcon(icon: Iconsax.home_2),
              suffixIcon: widget.addressSubController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.addressSubController.clear();
                      },
                    )
                  : null,
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
                  final addressModel = suggestions[index];
                  return ListTile(
                    title: Text(addressModel.fullAddress),
                    onTap: () {
                      // if (widget.addressSubController.text.isNotEmpty) {
                      widget.addressSubController.text = addressModel.fullAddress;
                      widget.update(addressModel);
                      // }
                      context.read<AddressBloc>().add(RefreshAddressEvent());
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
