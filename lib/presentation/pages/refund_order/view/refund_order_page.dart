import '../../../../commons.dart';
import '../../../../config/constants/constants.dart';
import '../../../../data/models/emp_order_model.dart';
import '../viewmodel/refund_order_viewmodel.dart';

// ignore: must_be_immutable
class RefundOrderPage extends ViewModelBuilderWidget<RefundOrderViewModel> {
  RefundOrderPage({super.key, required this.id, required this.tatalSum, required this.items});

  final int id;
  final List<Items> items;
  final String tatalSum;
  @override
  void onViewModelReady(RefundOrderViewModel viewModel) {
    viewModel.initState();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, RefundOrderViewModel viewModel, Widget? child) {
    viewModel.sumOfTotalPrice();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Refund order',
            style: AppTextStyles.body16w5.copyWith(color: AppColors.textColor.shade1, letterSpacing: 0.5)),
        backgroundColor: AppColors.scaffoldColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Ionicons.chevron_back_outline, size: 20, color: AppColors.textColor.shade1)),
        centerTitle: true,
        leadingWidth: 40,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                child: Text('Refund total', style: AppTextStyles.body14w4.copyWith(color: AppColors.textColor.shade2)),
              ),
              CheckboxListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Total amount',
                          style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text('\$$tatalSum', style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1))
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  tileColor: AppColors.baseLight.shade100,
                  activeColor: AppColors.primaryLight.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  onChanged: (value) {
                    viewModel.isTotalAmount = value ?? true;
                    if (value ?? true) {
                      viewModel.amount = tatalSum;
                    }
                    viewModel.notifyListeners();
                  },
                  value: viewModel.isTotalAmount),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child:
                    Text('Refund products', style: AppTextStyles.body14w4.copyWith(color: AppColors.textColor.shade2)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                color: AppColors.baseLight.shade100,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => CheckboxListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                viewModel.items[index].productName ?? '',
                                style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text('\$${viewModel.items[index].totalPrice}',
                                style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1))
                          ],
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        dense: true,
                        activeColor: viewModel.isAmount || viewModel.isTotalAmount
                            ? AppColors.getPrimaryColor(50)
                            : AppColors.primaryLight.shade100,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) {
                          viewModel.checkTotalAmount(value, index);
                          viewModel.notifyListeners();
                        },
                        value: viewModel.selectId.contains(items[index].id)),
                    separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: AppColors.textColor.shade2,
                        ),
                    itemCount: viewModel.items.length),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 15),
                child: Text('Refund amount', style: AppTextStyles.body14w4.copyWith(color: AppColors.textColor.shade2)),
              ),
              // TODO: fixings
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                tileColor: AppColors.baseLight.shade100,
                title: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    viewModel.textfieldSetState(value);
                    viewModel.notifyListeners();
                  },
                  style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                  decoration: InputDecoration(
                    hoverColor: AppColors.baseLight.shade100,
                    fillColor: AppColors.baseLight.shade100,
                    focusColor: AppColors.baseLight.shade100,
                    border: InputBorder.none,
                    hintText: 'custom amount',
                    hintStyle: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                dense: true,
                value: viewModel.isAmount,
                activeColor: viewModel.isAmount && viewModel.isTotalAmount
                    ? AppColors.primaryLight.shade100
                    : AppColors.primaryLight,
                onChanged: (value) {
                  viewModel.isAmount = value!;
                  viewModel.notifyListeners();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 15),
                child: Text(
                  'Comments*',
                  style: AppTextStyles.body14w4.copyWith(color: AppColors.textColor.shade2),
                ),
              ),
              Container(
                color: AppColors.baseLight.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  autofocus: false,
                  style: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade1),
                  minLines: 8,
                  maxLines: 10,
                  onChanged: (value) {
                    viewModel.comm = value;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write the reason for refund',
                    hintStyle: AppTextStyles.body14w5.copyWith(color: AppColors.textColor.shade2),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total amount:', style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1)),
                    Text('\$${viewModel.isAmount ? viewModel.amount : numFormat.format(viewModel.sum)}',
                        style: AppTextStyles.body16w6.copyWith(color: AppColors.textColor.shade1))
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      viewModel.refundOrderFunc(id);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(AppColors.primaryLight.shade100),
                        shape:
                            MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                    child: viewModel.isSuccess(tag: viewModel.tag)
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.baseLight.shade100),
                            ),
                          )
                        : Text(
                            'Refund',
                            style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
                          ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  RefundOrderViewModel viewModelBuilder(BuildContext context) {
    return RefundOrderViewModel(context: context, items: items);
  }
}
