import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:takk/domain/repositories/orders_repository.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../widgets/loading_dialog.dart';

class OrdersPageViewModel extends BaseViewModel {
  OrdersPageViewModel({required super.context});

  Future? dialog;

  final String tag = 'OrdersPage';
  final String tagSetEmpAckFunc = 'setEmpAckFunc';
  final String tagGetNewOrders = 'getNewOrders';
  final String tagGetReadyOrders = 'getReadyOrders';
  final String tagGetRefundOrders = 'getRefundOrders';
  late TabController _tabController;

  final GlobalKey<RefreshIndicatorState> _refNew = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refReady = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refRefund = GlobalKey<RefreshIndicatorState>();
  late ValueNotifier notifier;

  late OrdersRepository ordersRepository;
  bool isNewOrder = false;
  late var update;

  initState({required TickerProvider tickerProvider}) {
    _tabController = TabController(length: 3, vsync: tickerProvider);
    Future.delayed(const Duration(milliseconds: 400), () => _refNew.currentState!.show());
    _tabController.addListener(() {
      switch (_tabController.index) {
        case 0:
          Future.delayed(const Duration(milliseconds: 200), () => _refNew.currentState!.show());
          break;
        case 2:
          Future.delayed(const Duration(milliseconds: 200), () => _refReady.currentState!.show());
          break;
        case 3:
          Future.delayed(const Duration(milliseconds: 200), () => _refRefund.currentState!.show());
          break;
      }
    });
    update = () {
      Future.delayed(Duration.zero, () => _refNew.currentState!.show());
    };
    notifier.addListener(update);
  }

  Future<void> getNewOrders() async {
    safeBlock(() async {
      await ordersRepository.getEmpOrders('new');
      isNewOrder = true;
      setSuccess(tag: tagGetNewOrders);
    }, callFuncName: 'getNewOrders', tag: tagGetNewOrders);
  }

  Future<void> getReadyOrders() async {
    safeBlock(() async {
      await ordersRepository.getEmpOrders('ready');
      setSuccess(tag: tagGetReadyOrders);
    }, callFuncName: 'getReadyOrders', tag: tagGetReadyOrders);
  }

  Future<void> getRefundOrders() async {
    safeBlock(() async {
      await ordersRepository.getEmpOrders('refund');
      setSuccess(tag: tagGetRefundOrders);
    }, callFuncName: 'getRefundOrders', tag: tagGetRefundOrders);
  }

  setEmpAckFunc(int id) {
    safeBlock(() async {
      await ordersRepository.setEmpAck(id);
      setSuccess(tag: tagSetEmpAckFunc);
    }, callFuncName: 'setEmpAckFunc', tag: tagSetEmpAckFunc);
  }

  @override
  callBackBusy(bool value, String? tag) {
    if (isBusy(tag: tag)) {
      Future.delayed(Duration.zero, () {
        dialog = showLoadingDialog(context!);
      });
    } else {
      if (dialog != null) {
        pop();
        dialog = null;
      }
    }
  }

  @override
  callBackSuccess(value, String? tag) {
    if (dialog != null) {
      pop();
      dialog = null;
    }
  }

  @override
  callBackError(String text) {
    if (dialog != null) pop();
    showTopSnackBar(
      context!,
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabController get tabController => _tabController;
  GlobalKey<RefreshIndicatorState> get refNew => _refNew;
  GlobalKey<RefreshIndicatorState> get refReady => _refReady;
  GlobalKey<RefreshIndicatorState> get refRefund => _refRefund;
}
