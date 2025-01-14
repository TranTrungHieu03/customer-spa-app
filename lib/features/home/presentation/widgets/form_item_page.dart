import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/form_data_model.dart';
import 'package:spa_mobile/features/analysis_skin/presentation/screens/form_collect_data_screen.dart';
import 'package:spa_mobile/features/home/presentation/widgets/option_item.dart';

class TFormItemPage extends StatefulWidget {
  const TFormItemPage({
    super.key,
    required this.pageController,
    required this.question,
    this.child,
    this.isText = false,
    this.isMultiChoice = false,
    this.children = const SizedBox(),
    required this.answerValue,
    required this.onChanged,
  });

  final PageController pageController;
  final String question;
  final List<FormAnswerModel>? child;
  final Widget children;
  final bool isMultiChoice, isText;
  final int answerValue;

  final Function(int) onChanged;

  @override
  State<TFormItemPage> createState() => _TFormItemPageState();
}

class _TFormItemPageState extends State<TFormItemPage> {
  late Set<int> _selectedAnswers;

  @override
  void initState() {
    super.initState();
    _selectedAnswers = {widget.answerValue};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppbar(
        leadingIcon: Iconsax.arrow_left,
        leadingOnPressed: () {
          widget.pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInQuad,
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
        child: Column(
          children: [
            Text(
              widget.question,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            widget.isText
                ? widget.children
                : (widget.child != null)
                    ? Column(
                        children: widget.child!.map((ans) {
                          return TOptionItem(
                            icon: Iconsax.gallery,
                            title: ans.title,
                            isChoose: _selectedAnswers.contains(ans.value),
                            value: ans.value,
                            onPressed: () {
                              setState(() {
                                if (widget.isMultiChoice) {
                                  if (_selectedAnswers.contains(ans.value)) {
                                    _selectedAnswers.remove(ans.value);
                                  } else {
                                    _selectedAnswers.add(ans.value);
                                  }
                                } else {
                                  _selectedAnswers.clear();
                                  _selectedAnswers.add(ans.value);
                                }
                              });
                              AppLogger.info(_selectedAnswers);
                              widget.onChanged(ans.value);
                            },
                          );
                        }).toList(),
                      )
                    : const SizedBox.shrink(),
            widget.isText ? const Spacer() : const SizedBox(),
            const SizedBox(height: TSizes.lg),
            FormNextBtn(pageController: widget.pageController),
            const SizedBox(height: TSizes.sm),
          ],
        ),
      ),
    );
  }
}
