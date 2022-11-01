// import 'package:flutter/material.dart';
// import 'package:jbaza/jbaza.dart';
// import 'package:takk/config/constants/app_colors.dart';
// import 'package:takk/config/constants/app_text_styles.dart';
// import 'package:takk/data/models/emp_order_model.dart';
// import 'package:takk/presentation/pages/order_info/viewmodel/order_info_page_viewmodel.dart';

// import '../routes/routes.dart';
// import 'loading_dialog.dart';

// class OrderInfoBtnsWidget extends ViewModelBuilder<OrderInfoPageViewModel> {

//   OrderInfoBtnsWidget({super.key, required this.empOrderModel, required this.type});


//   EmpOrderModel empOrderModel;
//   int type;


  

//   @override
//   State<OrderInfoBtnsWidget> createState() => _OrderInfoBtnsWidgetState();
// }

// class _OrderInfoBtnsWidgetState extends State<OrderInfoBtnsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.type == 3) {
//       return SizedBox(
//         child: TextButton(
//           onPressed: () {
//             // List<Items> list = [];
//             // list.addAll(widget.empOrderModel.kitchen!);
//             // list.addAll(widget.empOrderModel.main!);
//             // Navigator.pushNamed(context, Routes.refundOrderPage,
//             //     arguments: {'orderId': widget.empOrderModel.id, 'items': list, 'total': widget.empOrderModel.totalPrice});
//           },
//           style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(Colors.redAccent),
//               shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
//           child: Text(
//             'Refund',
//             style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
//           ),
//         ),
//       );
//     } else if (widget.type == 4) {
//       return SizedBox(
//         child: TextButton(
//           onPressed: () {},
//           style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(Colors.blueAccent[700]),
//               shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
//           child: Text(
//             'Acknowledge',
//             style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
//           ),
//         ),
//       );
//     } else {
//       return Row(
//         children: [
//           Expanded(
//             child: SizedBox(
//               height: 45,
//               child: TextButton(
//                 onPressed: () {
//                   // List<Items> list = [];
//                   // list.addAll(widget.empOrderModel.kitchen!);
//                   // list.addAll(widget.empOrderModel.main!);
//                   // Navigator.pushNamed(context, Routes.refundOrderPage,
//                   //     arguments: {'orderId': widget.empOrderModel.id, 'items': list, 'total': widget.empOrderModel.totalPrice});
//                 },
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.redAccent),
//                     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
//                 child: Text(
//                   'Refund',
//                   style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Expanded(
//             child: SizedBox(
//               height: 45,
//               child: TextButton(
//                 onPressed: () {
//                   bool isReady = true;
//                   widget.empOrderModel.kitchen!.forEach((element) {
//                     if (!element.isReady!) {
//                       isReady = false;
//                     }
//                   });
//                   widget.empOrderModel.main!.forEach((element) {
//                     if (!element.isReady!) {
//                       isReady = false;
//                     }
//                   });
//                   if (isReady) {
//                     Future.delayed(
//                       Duration.zero,
//                       () {
//                         showLoadingDialog(context);
//                         // model.changeStatusOrder(tag, orderModel.id ?? 0, 'ready').then((value) {
//                         //   Navigator.pop(context);
//                         //   if (model.getState(tag) == 'success') {
//                         //     Navigator.pop(context);
//                         //   } else {
//                         //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                         //       content: Text(value),
//                         //       backgroundColor: Colors.redAccent,
//                         //     ));
//                         //   }
//                         // });
//                       },
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Please select products that are ready'),
//                         backgroundColor: Colors.orangeAccent,
//                       ),
//                     );
//                   }
//                 },
//                 style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(AppColors.accentColor),
//                     shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
//                 child: Text(
//                   'Ready',
//                   style: AppTextStyles.body16w6.copyWith(color: AppColors.baseLight.shade100),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//   }
// }
