import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spa_mobile/core/common/widgets/appbar.dart';
import 'package:spa_mobile/core/helpers/helper_functions.dart';
import 'package:spa_mobile/core/utils/constants/colors.dart';
import 'package:spa_mobile/core/utils/constants/exports_navigators.dart';
import 'package:spa_mobile/core/utils/constants/images.dart';
import 'package:spa_mobile/core/utils/constants/sizes.dart';
import 'package:spa_mobile/features/home/presentation/blocs/form_skin/form_skin_bloc.dart';

class FormCollectDataScreen extends StatefulWidget {
  const FormCollectDataScreen({super.key});

  @override
  State<FormCollectDataScreen> createState() => _FormCollectDataScreenState();
}

class _FormCollectDataScreenState extends State<FormCollectDataScreen> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: const TAppbar(),
      body: Stack(
        children: [
          BlocBuilder<FormSkinBloc, FormSkinState>(
            builder: (context, state) {
              return Form(
                  child: PageView(
                      key: formKey,
                      controller: pageController,
                      onPageChanged: (index) {
                        context
                            .read<FormSkinBloc>()
                            .add(OnPageChangedEvent(pageIndex: index));
                      },
                      children: [
                    const TPageIntroduction(),
                    FormDataPage(
                      children: ListView(children: [
                        _buildTextField(
                            label: "Tuổi", hint: "Nhập tuổi của bạn"),
                        _buildDropdown(
                          label: "Giới tính",
                          items: ["Nam", "Nữ", "Khác"],
                          hint: "Chọn giới tính",
                        ),
                        _buildDropdown(
                          label: "Loại da",
                          items: [
                            "Da dầu",
                            "Da khô",
                            "Da hỗn hợp",
                            "Da nhạy cảm",
                            "Không chắc chắn"
                          ],
                          hint: "Chọn loại da",
                        ),
                        _buildMultiSelectField(
                          label: "Vấn đề da đang gặp phải",
                          items: [
                            "Mụn",
                            "Sạm nám",
                            "Thâm",
                            "Da khô/Thiếu nước",
                            "Lỗ chân lông to",
                            "Nếp nhăn",
                            "Khác"
                          ],
                          selectedItems: [],
                          onChanged: (String item, bool isSelected) {
                            setState(() {
                              if (isSelected) {
                              } else {}
                            });
                          },
                        ),
                      ]),
                    ),
                    FormDataPage(
                      children: ListView(
                        children: [
                          _buildDropdown(
                            label: "Tần suất tiếp xúc ánh nắng mặt trời",
                            items: [
                              "Rất thường xuyên",
                              "Thỉnh thoảng",
                              "Hiếm khi"
                            ],
                            hint: "Chọn tần suất",
                          ),
                          _buildMultiSelectField(
                            label: "Thói quen chăm sóc da",
                            items: [
                              "Tẩy trang: Sử dụng tẩy trang hàng ngày",
                              "Sữa rửa mặt: Rửa mặt 1-2 lần/ngày",
                              "Toner: Cân bằng độ pH và làm sạch sâu",
                              "Serum: Dưỡng chất đặc trị (ví dụ: Vitamin C, Hyaluronic Acid)",
                              "Kem dưỡng ẩm: Dưỡng ẩm hàng ngày",
                              "Kem chống nắng: Sử dụng hàng ngày, SPF 30+"
                            ],
                            selectedItems: [],
                            onChanged: (String item, bool isSelected) {
                              setState(() {
                                if (isSelected) {
                                } else {}
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    FormDataPage(
                      children: ListView(
                        children: [
                          _buildMultiSelectField(
                            label: "Kết quả mong muốn",
                            items: [
                              " Lựa chọn sản phẩm phù hợp",
                              " Giải pháp cải thiện mụn",
                              " Dưỡng ẩm tốt hơn",
                              " Giảm thâm/nám",
                              " Khác"
                            ],
                            selectedItems: [],
                            onChanged: (String item, bool isSelected) {
                              setState(() {
                                if (isSelected) {
                                } else {}
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ]));
            },
          ),
          const OnboardingSkip(),
          const OnBoardingDotNavigation(),
          FormNextBtn(pageController: pageController),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: TSizes.sm),
          TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectField({
    required String label,
    required List<String> items,
    required List<String> selectedItems,
    required Function(String, bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: TSizes.sm),
          Column(
            children: items.map((item) {
              return CheckboxListTile(
                title: Text(item),
                value: selectedItems.contains(item),
                onChanged: (bool? value) {
                  if (value != null) {
                    onChanged(item, value);
                  }
                },
              );
            }).toList(),
          ),
          if (selectedItems.isNotEmpty)
            Wrap(
              spacing: 6.0,
              runSpacing: 6.0,
              children: selectedItems.map((item) {
                return Chip(
                  label: Text(item),
                  onDeleted: () {
                    setState(() {
                      selectedItems.remove(item);
                    });
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: TSizes.sm),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              // Xử lý khi giá trị thay đổi
            },
          ),
        ],
      ),
    );
  }
}

class TPageIntroduction extends StatelessWidget {
  const TPageIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
            width: THelperFunctions.screenWidth(context),
            height: THelperFunctions.screenHeight(context),
            image: const AssetImage(TImages.formSkin)),
        Text(
          "Chào mừng bạn đến với Hành Trình Khám Phá Làn Da Của Bạn",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: TColors.primary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: TSizes.spacebtwItems,
        ),
        Positioned(
          top: THelperFunctions.screenHeight(context) * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(TSizes.sm),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: THelperFunctions.screenWidth(context) * 0.95),
              child: Text(
                "Làn da là tấm gương phản chiếu sức khỏe và lối sống của bạn. Mỗi làn da kể một câu chuyện riêng, và Công cụ Phân Tích Da của chúng tôi sẽ giúp bạn hiểu rõ hơn về câu chuyện đó. Chúng tôi mang đến những hiểu biết sâu sắc về tình trạng da hiện tại và gợi ý giải pháp chăm sóc phù hợp nhất dành riêng cho bạn. 🌟",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormDataPage extends StatefulWidget {
  const FormDataPage({super.key, required this.children});

  final Widget children;

  @override
  State<FormDataPage> createState() => _FormDataPageState();
}

class _FormDataPageState extends State<FormDataPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
        child: widget.children);
  }
}

class FormNextBtn extends StatelessWidget {
  const FormNextBtn({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 10,
      child: ElevatedButton(
        onPressed: () => context.read<FormSkinBloc>().add(NextPageEvent()),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}

class FormSubmitBtn extends StatelessWidget {
  const FormSubmitBtn({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: 10,
      child: ElevatedButton(
        onPressed: () => context.read<FormSkinBloc>().add(NextPageEvent()),
        child: Text(AppLocalizations.of(context)!.submit),
      ),
    );
  }
}

class OnboardingSkip extends StatelessWidget {
  const OnboardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 16,
      child: TextButton(
        onPressed: () {
          goHome();
        },
        child: Text(AppLocalizations.of(context)!.skip),
      ),
    );
  }
}

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: 50,
      left: 16,
      child: BlocBuilder<FormSkinBloc, FormSkinState>(
        builder: (context, state) {
          final currentIndex =
              state is FormSkinPageChanged ? state.pageIndex : 0;

          return SmoothPageIndicator(
            controller: PageController(initialPage: currentIndex),
            count: 3,
            effect: ExpandingDotsEffect(
                activeDotColor: !dark ? TColors.dark : TColors.light,
                dotHeight: 6),
          );
        },
      ),
    );
  }
}
