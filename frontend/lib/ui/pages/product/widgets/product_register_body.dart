import 'dart:io';
import 'package:applus_market/data/gvm/geo/location_gvm.dart';
import 'package:applus_market/data/gvm/product/product_gvm.dart';
import 'package:applus_market/data/model_view/product/image_item_view_model.dart';
import 'package:applus_market/data/model_view/product/product_search_notifier.dart';
import 'package:applus_market/ui/pages/product/widgets/custom_label_input_field.dart';
import 'package:applus_market/ui/pages/product/widgets/image_select_container.dart';
import 'package:applus_market/ui/pages/product/widgets/product_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../_core/components/size.dart';
import '../../../../_core/utils/apiUrl.dart';
import '../../../../data/gvm/session_gvm.dart';
import '../../../../data/model/auth/login_state.dart';
import '../selection_page.dart';
import '../../../../_core/components/theme.dart';

final isNegotiableProvider = StateProvider<bool>((ref) => false);
final isPossibleMeetYouProvider = StateProvider<bool>((ref) => false);
final selectedCategoryProvider = StateProvider<String>((ref) => "카테고리");
final selectedBrandProvider = StateProvider<String>((ref) => "브랜드");
final selectedCategoryIdProvider = StateProvider<int>((ref) => 0);

class ProductRegisterBody extends ConsumerStatefulWidget {
  const ProductRegisterBody({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductRegisterBody> createState() =>
      _ProductRegisterBodyState();
}

class _ProductRegisterBodyState extends ConsumerState<ProductRegisterBody> {
  // 컨트롤러들을 상태로 선언 (상품을 등록한 뒤에 초기화 하기 위함)
  late final TextEditingController titleController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final TextEditingController tradeLocationController;
  late final TextEditingController productNameController;
  late final TextEditingController productFindController;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();
    tradeLocationController = TextEditingController();
    productNameController = TextEditingController();
    productFindController = TextEditingController();
  }

  void clear() {
    titleController.clear();
    priceController.clear();
    descriptionController.clear();
    tradeLocationController.clear();
    productNameController.clear();
    productFindController.clear();
  }

  @override
  void dispose() {
    clear();
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    tradeLocationController.dispose();
    productNameController.dispose();
    productFindController.dispose();
    super.dispose();
  }

  // 카테고리 선택 함수
  Future<void> _selectCategory() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage(
          items: ["카테고리", "휴대폰", "노트북", "컴퓨터", "테블릿", "웨어러블"],
          title: "카테고리",
        ),
      ),
    );
    if (selected != null) {
      ref.read(selectedCategoryProvider.notifier).state = selected;
    }
  }

  // 브랜드 선택 함수
  Future<void> _selectBrand() async {
    final selected = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectionPage(
          items: ["브랜드", "삼성", "애플", "LG", "기타"],
          title: "브랜드",
        ),
      ),
    );
    if (selected != null) {
      ref.read(selectedBrandProvider.notifier).state = selected;
    }
  }

  // 기본 박스 데코레이션
  BoxDecoration _defaultBoxDecoration() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productSearchNotifier = ref.read(productSearchProvider.notifier);
    final imagePaths = ref.watch(imageStateProvider);
    final isNegotiable = ref.watch(isNegotiableProvider);
    final isPossibleMeetYou = ref.watch(isPossibleMeetYouProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedBrand = ref.watch(selectedBrandProvider);
    final SizedBox height16Box = const SizedBox(height: commonPadding);
    final SizedBox height8Box = const SizedBox(height: halfPadding);
    SessionUser sessionUser = ref.watch(LoginProvider);
    int userid = sessionUser.id!;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('내 물건 팔기'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              ref.read(imageStateProvider.notifier).reset();
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 추가 및 출력 영역
                  ImageSelectContainer(),
                  height16Box,
                  // 제목 입력
                  CustomLabelInputField(
                      title: '제목',
                      controller: titleController,
                      inputLabel: '글 제목'),
                  height16Box,
                  // 제품 입력
                  CustomLabelInputField(
                      title: '제품',
                      controller: productNameController,
                      inputLabel: '제품명'),
                  height16Box,
                  // 카테고리 및 브랜드 선택
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('브랜드'),
                            height8Box,
                            GestureDetector(
                              onTap: _selectBrand,
                              child: Container(
                                height: 47,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: _defaultBoxDecoration(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedBrand,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: selectedBrand == '브랜드'
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle('카테고리'),
                            height8Box,
                            GestureDetector(
                              onTap: _selectCategory,
                              child: Container(
                                height: 47,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: _defaultBoxDecoration(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedCategory,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: selectedCategory == '카테고리'
                                            ? Colors.grey
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Visibility(
                    visible: selectedBrand == '삼성',
                    child:
                        ProductSearchField(controller: productFindController),

                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     height16Box,
                    //     CustomLabelInputField(
                    //         title: '제품 검색하기',
                    //         controller: productFindController,
                    //         inputLabel: '제품명, 제품 코드'),
                    //   ],
                    // ),
                  ),

                  height16Box,
                  // 가격 입력
                  CustomLabelInputField(
                      title: '가격',
                      type: 'number',
                      controller: priceController,
                      inputLabel: '가격'),
                  const SizedBox(height: APlusTheme.spacingS),
                  // 가격 제안 받기
                  Row(
                    children: [
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Checkbox(
                          value: isNegotiable,
                          onChanged: (value) {
                            ref.read(isNegotiableProvider.notifier).state =
                                value ?? false;
                          },
                          activeColor: Colors.red,
                          checkColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text('가격 제안 받기'),
                    ],
                  ),
                  height16Box,
                  height8Box,
                  // 자세한 설명 입력
                  _buildTitle('자세한 설명'),
                  height8Box,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: '상품에 대하여 자세히 설명해주세요.',
                        hintStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 13),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '설명을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  height16Box,
                  _buildTitle('택배 가능 여부'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Radio<bool>(
                          value: false,
                          groupValue: isPossibleMeetYou,
                          onChanged: (value) {
                            ref.read(isPossibleMeetYouProvider.notifier).state =
                                value!;
                          },
                        ),
                      ),
                      const Text('가능', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 5),
                      Radio<bool>(
                        value: true,
                        groupValue: isPossibleMeetYou,
                        onChanged: (value) {
                          ref.read(isPossibleMeetYouProvider.notifier).state =
                              value!;
                        },
                      ),
                      const Text('불가능', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  height16Box,
                  height16Box,
                  // 제출 버튼
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        // Provider에 저장된 ImageItem 리스트를 File 객체 리스트로 변환
                        final List<File> imageFiles =
                            imagePaths.map((img) => File(img.path)).toList();
                        // 현재 "서울" 위치기반 API 를 활용해서 상세 주소로 변경 해야합니다.
                        await ref.read(productProvider.notifier).insertproduct(
                              titleController.text, // 제목
                              productNameController.text, // 제품명
                              descriptionController.text, // 내용 (설명)
                              ref
                                  .read(locationProvider.notifier)
                                  .getMyDistrict(),
                              env!, // registerIp
                              int.parse(priceController.text), // 가격
                              isNegotiable, // 가격 제안 받기 여부
                              isPossibleMeetYou, // 직거래 가능 여부
                              selectedCategory, // 카테고리
                              userid,
                              imageFiles, // 이미지 파일 리스트
                              productSearchNotifier.getCurrentSelected(),
                              selectedBrand,
                            );
                        // 등록 성공 후 입력 데이터 초기화
                        titleController.clear();
                        productNameController.clear();
                        priceController.clear();
                        descriptionController.clear();
                        tradeLocationController.clear();
                        productFindController.clear();

                        productSearchNotifier.reset();

                        // 이미지 목록 초기화
                        ref.read(imageStateProvider.notifier).state = [];

                        // 선택된 카테고리, 브랜드도 초기값으로 설정 (필요한 경우)
                        ref.read(selectedCategoryProvider.notifier).state =
                            "카테고리";
                        ref.read(selectedBrandProvider.notifier).state = "브랜드";
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('작성 완료'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }
}
