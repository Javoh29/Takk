import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/config/constants/app_colors.dart';
import 'package:takk/config/constants/app_text_styles.dart';
import 'package:takk/core/di/app_locator.dart';
import 'package:takk/data/models/cart_response.dart';
import 'package:takk/data/models/product_model.dart';
import 'package:takk/data/viewmodel/local_viewmodel.dart';
import 'package:takk/presentation/pages/favorite_edit/viewmodel/favorite_edit_viewmodel.dart';

import '../../../../widgets/cache_image.dart';
import '../../../../widgets/sign_in_dialog.dart';

// ignore: must_be_immutable
class AddGdsSheet extends ViewModelBuilderWidget<FavoriteEditViewModel> {
  AddGdsSheet(this.cafeId, this.productModel, this.cartModel, {super.key});

  final int cafeId;
  final ProductModel? productModel;
  final CartModel? cartModel;

  final Map<int, int> _chossens = {};
  bool isLoad = false;
  late String tag;
  late String tagFav = 'AddGdsSheetOld';
  final GlobalKey<ScaffoldState> _modelScaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _textEditingController = TextEditingController();
  ProductModel? model;

  @override
  Widget builder(BuildContext context, FavoriteEditViewModel viewModel, Widget? child) {
    double sum = 0;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _modelScaffoldKey,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Color(0xFFf3f3f4), blurRadius: 10, offset: Offset(0, 1)),
                ],
              ),
              child: Text(
                'Select options',
                style: AppTextStyles.body15w6,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                children: [
                  if (model!.sizes.length > 1)
                    Text(
                      'Sizes (Required)',
                      style: AppTextStyles.body12w5.copyWith(color: AppColors.textColor.shade2),
                    ),
                  if (model!.sizes.length > 1)
                    ListView.separated(
                        itemBuilder: (context, index) => _itemSize(model!.sizes[index], index, viewModel),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: AppColors.textColor.shade3,
                            ),
                        itemCount: model!.sizes.length),
                  for (int i = 0; i < model!.modifiers.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${model!.modifiers[i].name ?? ''} ${model!.modifiers[i].required ?? false ? '(Required)' : '(Optional)'}',
                          style: AppTextStyles.body12w5.copyWith(color: AppColors.textColor.shade2),
                        ),
                        if (model!.modifiers[i].isSingle)
                          _itemSingleMod(model!.modifiers[i], i, viewModel)
                        else
                          _itemMod(model!.modifiers[i], i, viewModel),
                      ],
                    ),
                  Text(
                    'Special Instructions',
                    style: AppTextStyles.body12w5.copyWith(color: AppColors.textColor.shade2),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    style: AppTextStyles.body14w5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.textColor.shade3)),
                      contentPadding: const EdgeInsets.all(10),
                      hintText: 'Example: No pepper/Sugar/Salt please',
                      hintStyle: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                    ),
                    controller: _textEditingController,
                    minLines: 5,
                    maxLines: 10,
                    onChanged: (value) {
                      model!.comment = value;
                    },
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Color(0xFFf3f3f4),
                  blurRadius: 10,
                  offset: Offset(0, -1),
                ),
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model!.name ?? '',
                    style: AppTextStyles.body15w6,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      CacheImage(model!.imageMedium ?? '',
                          fit: BoxFit.cover,
                          borderRadius: 12,
                          height: 60,
                          width: 60,
                          placeholder: Icon(
                            Ionicons.fast_food_outline,
                            size: 30,
                            color: AppColors.primaryLight.shade100,
                          )),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          model!.description ?? '',
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.justify,
                          style: AppTextStyles.body12w5.copyWith(color: AppColors.textColor.shade2),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColors.textColor.shade3,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (model!.count > 1) {
                                    model!.count--;
                                    viewModel.notifyListeners();
                                  }
                                },
                                icon: Icon(
                                  Ionicons.remove_outline,
                                  size: 20,
                                  color: AppColors.textColor.shade1,
                                ),
                              ),
                              VerticalDivider(
                                width: 1.5,
                                color: AppColors.textColor.shade2,
                                endIndent: 5,
                                indent: 5,
                              ),
                              IconButton(
                                onPressed: () {
                                  model!.count++;
                                  viewModel.notifyListeners();
                                },
                                icon: Icon(
                                  Ionicons.add_outline,
                                  size: 20,
                                  color: AppColors.textColor.shade1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            '${model!.count}  x  \$${sum.toStringAsFixed(2)}',
                            style: AppTextStyles.body15w5.copyWith(color: AppColors.textColor.shade2),
                          ),
                        ),
                        Text(
                          '\$${(model!.count * sum).toStringAsFixed(2)}',
                          style: AppTextStyles.body16w6,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(AppColors.textColor.shade3),
                                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 11)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                            child: Text('Cancel', style: AppTextStyles.body15w5)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            if (locator<LocalViewModel>().isGuest) {
                              showSignInDialog(context);
                            } else if (!isLoad) {
                              isLoad = true;
                              viewModel.notifyListeners();
                              viewModel
                                  .addItemCart(tag, cafeId, model!, cartModel != null ? cartModel!.id : null)
                                  .then((value) {
                                // if (viewModel.getState(tagFav) == 'success') {
                                Navigator.pop(context, true);
                                // } else {
                                //   isLoad = false;
                                //   viewModel.notifyListeners();
                                //   debugPrint('Err: $value');
                                //   // _modelScaffoldKey.currentState!
                                //   //     .showSnackBar(SnackBar(
                                //   //   content: Text(value),
                                //   //   backgroundColor: Colors.redAccent,
                                //   // ));
                                // }
                              });
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(AppColors.primaryLight.shade100),
                              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 11)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                          child: isLoad
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  'Add',
                                  style: AppTextStyles.body15w5,
                                ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
        // : Center(
        //     child: TextButton(
        //         onPressed: () {
        //           viewModel.notifyListeners();
        //           viewModel.favoriteRepository.getProductInfo(cartModel!).then((value) {
        //             if (value != null) model = value;
        //             viewModel.notifyListeners();
        //           });
        //         },
        //         child: Text(
        //           'Reload',
        //           style: AppTextStyles.body16w6,
        //         )),
        //   ),
        );
  }

  Widget _itemMod(Modifiers m, int i, FavoriteEditViewModel viewModel) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            value: m.items[index].mDefault,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) {
              model!.modifiers[i].items[index].mDefault = value ?? false;
              viewModel.notifyListeners();
            },
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    m.items[index].name ?? '',
                    style: AppTextStyles.body14w5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '+\$${m.items[index].price}',
                  style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.textColor.shade3,
            ),
        itemCount: m.items.length);
  }

  Widget _itemSingle(Modifiers m, int i) {
    return DropdownButton<int>(
        isDense: true,
        onChanged: (value) {},
        items: m.items
            .map((e) => DropdownMenuItem<int>(
                value: e.id,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    e.name ?? '',
                    style: AppTextStyles.body14w5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '+\$${e.price}',
                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                  ),
                )))
            .toList());
  }

  Widget _itemSingleMod(Modifiers m, int i, FavoriteEditViewModel viewModel) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (m.items[index].mDefault) {
            _chossens[m.id] = index;
          }
          return RadioListTile(
              value: index,
              groupValue: _chossens[m.id] ?? -1,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      m.items[index].name ?? '',
                      style: AppTextStyles.body14w5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '+\$${m.items[index].price}',
                    style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                  )
                ],
              ),
              onChanged: (value) {
                debugPrint('tap');
                if (_chossens[m.id] != null) model!.modifiers[i].items[_chossens[m.id]!].mDefault = false;
                _chossens[m.id] = index;
                model!.modifiers[i].items[index].mDefault = true;
                viewModel.notifyListeners();
              });
        },
        separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.textColor.shade3,
            ),
        itemCount: m.items.length);
  }

  Widget _itemSize(Sizes s, int index, FavoriteEditViewModel viewModel) {
    if (s.mDefault && _chossens[0] == null) {
      _chossens[0] = index;
    }
    if (_chossens[0] != index) {
      model!.sizes[index].mDefault = false;
    }
    return RadioListTile(
      value: index,
      groupValue: _chossens[0],
      contentPadding: EdgeInsets.zero,
      dense: true,
      onChanged: (value) {
        _chossens[0] = index;
        model!.sizes[index].mDefault = true;
        viewModel.notifyListeners();
      },
      title: Row(
        children: [
          Text(
            s.name ?? '',
            style: AppTextStyles.body14w5,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '\$${s.price}',
            style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
          )
        ],
      ),
    );
  }

  @override
  FavoriteEditViewModel viewModelBuilder(BuildContext context) {
    return FavoriteEditViewModel(context: context, favoriteRepository: locator.get());
  }
}
