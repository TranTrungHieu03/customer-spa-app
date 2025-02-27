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
    this.answerValue = -1,
    required this.onChanged,
    this.answerValues = const [],
    this.formController,
    this.isFromAI = true
  });

  final PageController pageController;
  final String question;
  final List<FormAnswerModel>? child;
  final Widget children;
  final bool isMultiChoice, isText, isFromAI;
  final int answerValue;
  final List<String> answerValues;
  final TextEditingController? formController;

  final Function(Set<dynamic>) onChanged;

  @override
  State<TFormItemPage> createState() => _TFormItemPageState();
}

class _TFormItemPageState extends State<TFormItemPage> {
  late Set<int> _selectedIntAnswers;
  late Set<String> _selectedStringAnswers;

  @override
  void initState() {
    super.initState();

    if (widget.isMultiChoice) {
      if (widget.answerValues.isEmpty && widget.isFromAI) {
        _selectedStringAnswers = {"none"};
      } else {
        _selectedStringAnswers = {...widget.answerValues};
      }
    } else {
      _selectedIntAnswers = {widget.answerValue};
      _selectedIntAnswers.removeWhere((e) => e < 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedAnswers = widget.isMultiChoice ? _selectedStringAnswers : _selectedIntAnswers;
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
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontWeight: FontWeight.w600),
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
                  isChoose: selectedAnswers.contains(ans.value),
                  value: ans.value,
                  onPressed: () {
                    setState(() {
                      if (widget.isMultiChoice) {
                        if (ans.value == "none" || ans.value == "unknown") {
                          selectedAnswers.clear();
                          selectedAnswers.add(ans.value);
                        } else if (selectedAnswers.contains(ans.value)) {
                          selectedAnswers.remove(ans.value);
                        } else {
                          selectedAnswers.contains("none") || selectedAnswers.contains("unknown")
                              ? selectedAnswers.clear()
                              : () {};
                          selectedAnswers.add(ans.value);
                        }
                      } else {
                        selectedAnswers.clear();
                        selectedAnswers.add(ans.value);
                      }
                    });
                    AppLogger.debug(selectedAnswers);
                    widget.onChanged(selectedAnswers);
                  },
                );
              }).toList(),
            )
                : const SizedBox.shrink(),
            widget.isText ? const Spacer() : const SizedBox(),
            const SizedBox(height: TSizes.lg),
            FormNextBtn(
              pageController: widget.pageController,
              isHasValue: selectedAnswers.isNotEmpty,
            ),
            const SizedBox(height: TSizes.sm),
          ],
        ),
      ),
    );
  }
}
