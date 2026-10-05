class ApiRoutes {
  static const String baseURL =
      'http://64.227.170.206/kayal.com/public/api/user';
  static const String imageBaseURL = 'http://64.227.170.206/kayal.com/public/storage/';
  static const String apiKey = 'sdfghjkcvbnfghjkcvbnmdfghjdfvgbncvbn';

  // Endpoints
  static const String getTerms = '/get_terms';
  static const String getPrivacyPolicy = '/get_privacy_policy';
  static const String getNotifications = '/get_notifications';
  static const String deleteNotification = '/delete_notification';
  static const String markAsRead = '/mark_as_read';
  static const String getProfile = '/get_profile';
  static const String updateProfile = '/update_profile';
  static const String updateProfilePhoto = '/update_profile_photo';
  static const String getOrders = '/get_orders';
  static const String getOrderDetails = '/get_order_details';
  static const String reOrder = '/re_order';
  static const String getOrderSummary = '/get_order_summary';
  static const String addProductToCart = '/add_product_to_cart';
  static const String addToCart = '/add_product_to_cart';
  static const String getProductDetails = '/get_product_details';
  static const String getCategoryProducts = '/get_category_products';
  static const String restaurantProducts = '/restaurant_products';
  static const String getCategories = '/get_categories';
  static const String offers = '/offers';
  static const String popularRestaurants = '/popular_restaurants';
  static const String banner = '/banner';
  static const String search = '/search';
  static const String registerLogin = '/register_login';
  static const String loginOtp = '/register_login';
  static const String verifyLoginOtp = '/verify_login_otp';
  static const String resendLoginOtp = '/resend_login_otp';
  static const String signup = '/signup';
  static const String signupProfile = '/signup_profile';
  static const String verifySignupOtp = '/verify_signup_otp';
  static const String resendSignupOtp = '/resend_signup_otp';
  static const String savedAddress = '/saved_address';
  static const String addAddress = '/add_address';
  static const String updateAddress = '/update_address';
  static const String selectActiveAddress = '/select_active_adress';
  static const String placeOrder = '/place_order';
  static const String initiatePayment = '/initiate_payment';
  static const String getCart = '/get_cart';
  static const String updateQuantity = '/update_quantity';
  static const String removeCartItem = '/remove_cart_item';
  static const String clearCart = '/clear_cart';
  static const String getWishlist = '/get_wishlist';
  static const String toggleWishlist = '/toggle_wishlist';
  static const String addToCartFromWishlist = '/add_to_cart_from_wishlist';
  static const String logout = '/logout';
  static const String submitSupport = '/submit_Support';
  static const String storeFoodReview = '/store_food_review';
  static const String storeUserFeedback = '/store_user_feedback';
}
