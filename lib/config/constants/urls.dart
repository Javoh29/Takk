class Url {
  static const baseUrl = 'https://api.takk.cafe/api/v2/mobile';

  static var setAuth = Uri.parse('$baseUrl/users/auth/');
  static var getUser = Uri.parse('$baseUrl/users/profile/');
  static var updateToken = Uri.parse('https://api.takk.cafe/api/token/refresh/');

  static getCafes(String? q) => Uri.parse('$baseUrl/cafes/${q ?? ''}');

  static getCafe(int cafeId) => Uri.parse('$baseUrl/cafes/$cafeId/');

  static getCafeProducts(int cafeId) => Uri.parse('$baseUrl/cafes/$cafeId/product-list/');

  static changeFavorite(int cafeId) => Uri.parse('$baseUrl/users/favorite-cafe/$cafeId/');
  static var setItemCart = Uri.parse('$baseUrl/carts/item/');
  static var getCartList = Uri.parse('$baseUrl/carts/');
  static var clearCart = Uri.parse('$baseUrl/carts/empty/');
  static var getFavList = Uri.parse('$baseUrl/favorite-carts/');
  static var setCartFov = Uri.parse('$baseUrl/favorite-carts/');
  static var getUserCards = Uri.parse('$baseUrl/users/cards/');
  static var getClientSecret = Uri.parse('$baseUrl/users/cards/add/');
  static var addTipOrder = Uri.parse('$baseUrl/carts/tip/');
  static var createOrder = Uri.parse('$baseUrl/carts/order/');
  static var getUserOrders = Uri.parse('$baseUrl/orders/list/');
  static var getTariffs = Uri.parse('$baseUrl/takk/tariffs/');
  static var setBalancePayment = Uri.parse('$baseUrl/users/top-up-balance/');
  static var setDeviceInfo = Uri.parse('$baseUrl/users/device/');
  static var getEmployeeCafeList = Uri.parse('$baseUrl/employees/cafes/');
  static var getUserPoints = Uri.parse('$baseUrl/users/points/');
  static var getUserCashBack = Uri.parse('$baseUrl/users/cashback/');
  static var getCompInfo = Uri.parse('$baseUrl/companies/1/');
  static var getUserNotifs = Uri.parse('$baseUrl/users/notifications/');
  static var givePoints = Uri.parse('$baseUrl/employees/give-points/');
  static var setRefundOrder = Uri.parse('$baseUrl/employees/refund/order/');
  static var getUserLastAddresses = Uri.parse('$baseUrl/deliveries/');
  static var addDeliveryAddress = Uri.parse('$baseUrl/deliveries/add/');
  static var sendMessage = Uri.parse('$baseUrl/ws-chat/messages/');
  static var sendMessageOrder = Uri.parse('$baseUrl/ws-chat/messages/order');
  static var getCashbackStatistics = Uri.parse('$baseUrl/users/cashbacks/statistics/');

  static getCompList(int? pageSize) =>
      Uri.parse('$baseUrl/companies/${pageSize != null ? "?page_size=$pageSize" : ""}');

  static getMessages(int? pageSize) => Uri.parse('$baseUrl/ws-chat/${pageSize != null ? "?page_size=$pageSize" : ""}');

  static setChangeStateEmpOrder(bool isKitchen) => Uri.parse('$baseUrl/employees/orders/item/ready/');

  static getEmpOrder(int id) => Uri.parse('$baseUrl/employees/orders/$id/');

  static getOrderInfo(int id) => Uri.parse('$baseUrl/orders/$id/');

  static getMessageInfo(int id, int? pageSize) =>
      Uri.parse('$baseUrl/ws-chat/$id/messages/${pageSize != null ? "?page_size=$pageSize" : ""}');

  static getCompanyInfoForChat(int id) => Uri.parse('$baseUrl/ws-chat/companies/$id/');

  static getCashbackList(int period) =>
      Uri.parse('$baseUrl/users/balance-fill-history/?year=$period&fill_type=cashback');

  static getProductInfo(int id) => Uri.parse('$baseUrl/products/$id/');

  static getUserCashBackOrders(int id) => Uri.parse('$baseUrl/users/cashback/$id/');

  static setEmpAck(int id) => Uri.parse('$baseUrl/employees/orders/$id/acknowledge/');

  static setAcknow(int id) => Uri.parse('$baseUrl/employees/orders/$id/acknowledge/');

  static deleteCartItem(int id) => Uri.parse('$baseUrl/carts/item/$id/');

  static putCartItem(int id) => Uri.parse('$baseUrl/carts/item/$id/');

  static deleteFavoriteItem(int id) => Uri.parse('$baseUrl/favorite-carts/item/$id/');

  static deleteFavorite(int id) => Uri.parse('$baseUrl/favorite-carts/$id/');

  static addOrderToCart(int id) => Uri.parse('$baseUrl/orders/$id/to-cart/');

  static getEmpOrders(String state) => Uri.parse('$baseUrl/employees/orders/?status=$state');
  static var changeStatusProduct = Uri.parse('$baseUrl/employees/cafes/product-available/');

  static changeStatusOrder(int id) => Uri.parse('$baseUrl/employees/orders/$id/status/');

  static addFavToCart(int id) => Uri.parse('$baseUrl/favorite-carts/$id/to-cart/');

  static checkTimestamp(int cafeId, int time) =>
      Uri.parse('$baseUrl/orders/check-order-limit/$cafeId/?timestamp=$time');
}
