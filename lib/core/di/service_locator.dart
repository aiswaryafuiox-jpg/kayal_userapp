import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core Services
import '../service/api_service.dart';
import '../service/local_storage_service.dart';

// Repositories (Separate per feature)
import '../../domain/repository/login_otp_repository.dart';
import '../../data/repository/login_otp_repository_impl.dart';
import '../../domain/repository/verify_login_otp_repository.dart';
import '../../data/repository/verify_login_otp_repository_impl.dart';
import '../../domain/repository/resend_login_otp_repository.dart';
import '../../data/repository/resend_login_otp_repository_impl.dart';
import '../../domain/repository/signup_repository.dart';
import '../../data/repository/signup_repository_impl.dart';
import '../../domain/repository/verify_signup_otp_repository.dart';
import '../../data/repository/verify_signup_otp_repository_impl.dart';
import '../../domain/repository/resend_signup_otp_repository.dart';
import '../../data/repository/resend_signup_otp_repository_impl.dart';
import '../../domain/repository/search_repository.dart';
import '../../data/repository/search_repository_impl.dart';
import '../../domain/repository/banner_repository.dart';
import '../../data/repository/banner_repository_impl.dart';
import '../../domain/repository/popular_restaurants_repository.dart';
import '../../data/repository/popular_restaurants_repository_impl.dart';
import '../../domain/repository/offers_repository.dart';
import '../../data/repository/offers_repository_impl.dart';
import '../../domain/repository/categories_repository.dart';
import '../../data/repository/categories_repository_impl.dart';
import '../../domain/repository/category_products_repository.dart';
import '../../data/repository/category_products_repository_impl.dart';
import '../../domain/repository/product_details_repository.dart';
import '../../data/repository/product_details_repository_impl.dart';
import '../../domain/repository/add_to_cart_repository.dart';
import '../../data/repository/add_to_cart_repository_impl.dart';
import '../../domain/repository/order_summary_repository.dart';
import '../../data/repository/order_summary_repository_impl.dart';
import '../../domain/repository/saved_address_repository.dart';
import '../../data/repository/saved_address_repository_impl.dart';
import '../../domain/repository/add_address_repository.dart';
import '../../data/repository/add_address_repository_impl.dart';
import '../../domain/repository/update_address_repository.dart';
import '../../data/repository/update_address_repository_impl.dart';
import '../../domain/repository/select_active_address_repository.dart';
import '../../data/repository/select_active_address_repository_impl.dart';
import '../../domain/repository/place_order_repository.dart';
import '../../data/repository/place_order_repository_impl.dart';
import '../../domain/repository/initiate_payment_repository.dart';
import '../../data/repository/initiate_payment_repository_impl.dart';
import '../../domain/repository/get_cart_repository.dart';
import '../../data/repository/get_cart_repository_impl.dart';
import '../../domain/repository/update_quantity_repository.dart';
import '../../data/repository/update_quantity_repository_impl.dart';
import '../../domain/repository/remove_cart_item_repository.dart';
import '../../data/repository/remove_cart_item_repository_impl.dart';
import '../../domain/repository/clear_cart_repository.dart';
import '../../data/repository/clear_cart_repository_impl.dart';
import '../../domain/repository/get_wishlist_repository.dart';
import '../../data/repository/get_wishlist_repository_impl.dart';
import '../../domain/repository/toggle_wishlist_repository.dart';
import '../../data/repository/toggle_wishlist_repository_impl.dart';
import '../../domain/repository/add_to_cart_from_wishlist_repository.dart';
import '../../data/repository/add_to_cart_from_wishlist_repository_impl.dart';
import '../../domain/repository/get_orders_repository.dart';
import '../../data/repository/get_orders_repository_impl.dart';
import '../../domain/repository/get_order_details_repository.dart';
import '../../data/repository/get_order_details_repository_impl.dart';
import '../../domain/repository/re_order_repository.dart';
import '../../data/repository/re_order_repository_impl.dart';
import '../../domain/repository/get_profile_repository.dart';
import '../../data/repository/get_profile_repository_impl.dart';
import '../../domain/repository/update_profile_repository.dart';
import '../../data/repository/update_profile_repository_impl.dart';
import '../../domain/repository/update_profile_photo_repository.dart';
import '../../data/repository/update_profile_photo_repository_impl.dart';
import '../../domain/repository/get_notifications_repository.dart';
import '../../data/repository/get_notifications_repository_impl.dart';
import '../../domain/repository/delete_notification_repository.dart';
import '../../data/repository/delete_notification_repository_impl.dart';
import '../../domain/repository/mark_as_read_repository.dart';
import '../../data/repository/mark_as_read_repository_impl.dart';
import '../../domain/repository/get_terms_repository.dart';
import '../../data/repository/get_terms_repository_impl.dart';
import '../../domain/repository/get_privacy_policy_repository.dart';
import '../../data/repository/get_privacy_policy_repository_impl.dart';
import '../../domain/repository/logout_repository.dart';
import '../../data/repository/logout_repository_impl.dart';
import '../../domain/repository/submit_support_repository.dart';
import '../../data/repository/submit_support_repository_impl.dart';
import '../../domain/repository/store_food_review_repository.dart';
import '../../data/repository/store_food_review_repository_impl.dart';
import '../../domain/repository/store_user_feedback_repository.dart';
import '../../data/repository/store_user_feedback_repository_impl.dart';

// Use Cases
import '../../domain/usecase/login_otp_usecase.dart';
import '../../domain/usecase/verify_login_otp_usecase.dart';
import '../../domain/usecase/resend_login_otp_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';
import '../../domain/usecase/verify_signup_otp_usecase.dart';
import '../../domain/usecase/resend_signup_otp_usecase.dart';
import '../../domain/usecase/search_usecase.dart';
import '../../domain/usecase/banner_usecase.dart';
import '../../domain/usecase/popular_restaurants_usecase.dart';
import '../../domain/usecase/offers_usecase.dart';
import '../../domain/usecase/get_categories_usecase.dart';
import '../../domain/usecase/get_category_products_usecase.dart';
import '../../domain/usecase/get_product_details_usecase.dart';
import '../../domain/usecase/add_to_cart_usecase.dart';
import '../../domain/usecase/get_order_summary_usecase.dart';
import '../../domain/usecase/get_saved_address_usecase.dart';
import '../../domain/usecase/add_address_usecase.dart';
import '../../domain/usecase/update_address_usecase.dart';
import '../../domain/usecase/select_active_address_usecase.dart';
import '../../domain/usecase/place_order_usecase.dart';
import '../../domain/usecase/initiate_payment_usecase.dart';
import '../../domain/usecase/get_cart_usecase.dart';
import '../../domain/usecase/update_quantity_usecase.dart';
import '../../domain/usecase/remove_cart_item_usecase.dart';
import '../../domain/usecase/clear_cart_usecase.dart';
import '../../domain/usecase/get_wishlist_usecase.dart';
import '../../domain/usecase/toggle_wishlist_usecase.dart';
import '../../domain/usecase/add_to_cart_from_wishlist_usecase.dart';
import '../../domain/usecase/get_orders_usecase.dart';
import '../../domain/usecase/get_order_details_usecase.dart';
import '../../domain/usecase/re_order_usecase.dart';
import '../../domain/usecase/get_profile_usecase.dart';
import '../../domain/usecase/update_profile_usecase.dart';
import '../../domain/usecase/update_profile_photo_usecase.dart';
import '../../domain/usecase/get_notifications_usecase.dart';
import '../../domain/usecase/delete_notification_usecase.dart';
import '../../domain/usecase/mark_as_read_usecase.dart';
import '../../domain/usecase/get_terms_usecase.dart';
import '../../domain/usecase/get_privacy_policy_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/submit_support_usecase.dart';
import '../../domain/usecase/store_food_review_usecase.dart';
import '../../domain/usecase/store_user_feedback_usecase.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ==================== CORE & STORAGE ====================
  final prefs = await SharedPreferences.getInstance();
  await LocalStorageService().init();

  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerSingleton<SharedPreferences>(prefs);
  }

  if (!sl.isRegistered<LocalStorageService>()) {
    sl.registerLazySingleton<LocalStorageService>(() => LocalStorageService());
  }

  if (!sl.isRegistered<ApiService>()) {
    sl.registerLazySingleton<ApiService>(() => ApiService());
  }

  // ==================== REPOSITORIES ====================
  if (!sl.isRegistered<LoginOtpRepository>()) {
    sl.registerLazySingleton<LoginOtpRepository>(
      () => LoginOtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<VerifyLoginOtpRepository>()) {
    sl.registerLazySingleton<VerifyLoginOtpRepository>(
      () => VerifyLoginOtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ResendLoginOtpRepository>()) {
    sl.registerLazySingleton<ResendLoginOtpRepository>(
      () => ResendLoginOtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SignupRepository>()) {
    sl.registerLazySingleton<SignupRepository>(
      () => SignupRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<VerifySignupOtpRepository>()) {
    sl.registerLazySingleton<VerifySignupOtpRepository>(
      () => VerifySignupOtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ResendSignupOtpRepository>()) {
    sl.registerLazySingleton<ResendSignupOtpRepository>(
      () => ResendSignupOtpRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SearchRepository>()) {
    sl.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<BannerRepository>()) {
    sl.registerLazySingleton<BannerRepository>(
      () => BannerRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<PopularRestaurantsRepository>()) {
    sl.registerLazySingleton<PopularRestaurantsRepository>(
      () => PopularRestaurantsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<OffersRepository>()) {
    sl.registerLazySingleton<OffersRepository>(
      () => OffersRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<CategoriesRepository>()) {
    sl.registerLazySingleton<CategoriesRepository>(
      () => CategoriesRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<CategoryProductsRepository>()) {
    sl.registerLazySingleton<CategoryProductsRepository>(
      () => CategoryProductsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ProductDetailsRepository>()) {
    sl.registerLazySingleton<ProductDetailsRepository>(
      () => ProductDetailsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<AddToCartRepository>()) {
    sl.registerLazySingleton<AddToCartRepository>(
      () => AddToCartRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<OrderSummaryRepository>()) {
    sl.registerLazySingleton<OrderSummaryRepository>(
      () => OrderSummaryRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SavedAddressRepository>()) {
    sl.registerLazySingleton<SavedAddressRepository>(
      () => SavedAddressRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<AddAddressRepository>()) {
    sl.registerLazySingleton<AddAddressRepository>(
      () => AddAddressRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<UpdateAddressRepository>()) {
    sl.registerLazySingleton<UpdateAddressRepository>(
      () => UpdateAddressRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SelectActiveAddressRepository>()) {
    sl.registerLazySingleton<SelectActiveAddressRepository>(
      () => SelectActiveAddressRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<PlaceOrderRepository>()) {
    sl.registerLazySingleton<PlaceOrderRepository>(
      () => PlaceOrderRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<InitiatePaymentRepository>()) {
    sl.registerLazySingleton<InitiatePaymentRepository>(
      () => InitiatePaymentRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<GetCartRepository>()) {
    sl.registerLazySingleton<GetCartRepository>(
      () => GetCartRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<UpdateQuantityRepository>()) {
    sl.registerLazySingleton<UpdateQuantityRepository>(
      () => UpdateQuantityRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<RemoveCartItemRepository>()) {
    sl.registerLazySingleton<RemoveCartItemRepository>(
      () => RemoveCartItemRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ClearCartRepository>()) {
    sl.registerLazySingleton<ClearCartRepository>(
      () => ClearCartRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<GetWishlistRepository>()) {
    sl.registerLazySingleton<GetWishlistRepository>(
      () => GetWishlistRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ToggleWishlistRepository>()) {
    sl.registerLazySingleton<ToggleWishlistRepository>(
      () => ToggleWishlistRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<AddToCartFromWishlistRepository>()) {
    sl.registerLazySingleton<AddToCartFromWishlistRepository>(
      () => AddToCartFromWishlistRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<GetOrdersRepository>()) {
    sl.registerLazySingleton<GetOrdersRepository>(
      () => GetOrdersRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<GetOrderDetailsRepository>()) {
    sl.registerLazySingleton<GetOrderDetailsRepository>(
      () => GetOrderDetailsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<ReOrderRepository>()) {
    sl.registerLazySingleton<ReOrderRepository>(
      () => ReOrderRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<GetProfileRepository>()) {
    sl.registerLazySingleton<GetProfileRepository>(
      () => GetProfileRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<UpdateProfileRepository>()) {
    sl.registerLazySingleton<UpdateProfileRepository>(
      () => UpdateProfileRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<UpdateProfilePhotoRepository>()) {
    sl.registerLazySingleton<UpdateProfilePhotoRepository>(
      () => UpdateProfilePhotoRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<GetNotificationsRepository>()) {
    sl.registerLazySingleton<GetNotificationsRepository>(
      () => GetNotificationsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<DeleteNotificationRepository>()) {
    sl.registerLazySingleton<DeleteNotificationRepository>(
      () => DeleteNotificationRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<MarkAsReadRepository>()) {
    sl.registerLazySingleton<MarkAsReadRepository>(
      () => MarkAsReadRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<GetTermsRepository>()) {
    sl.registerLazySingleton<GetTermsRepository>(
      () => GetTermsRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<GetPrivacyPolicyRepository>()) {
    sl.registerLazySingleton<GetPrivacyPolicyRepository>(
      () => GetPrivacyPolicyRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<LogoutRepository>()) {
    sl.registerLazySingleton<LogoutRepository>(
      () => LogoutRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<SubmitSupportRepository>()) {
    sl.registerLazySingleton<SubmitSupportRepository>(
      () => SubmitSupportRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<StoreFoodReviewRepository>()) {
    sl.registerLazySingleton<StoreFoodReviewRepository>(
      () => StoreFoodReviewRepositoryImpl(sl<ApiService>()),
    );
  }

  if (!sl.isRegistered<StoreUserFeedbackRepository>()) {
    sl.registerLazySingleton<StoreUserFeedbackRepository>(
      () => StoreUserFeedbackRepositoryImpl(sl<ApiService>()),
    );
  }

  // ==================== USE CASES ====================
  if (!sl.isRegistered<LoginOtpUseCase>()) {
    sl.registerLazySingleton<LoginOtpUseCase>(
      () => LoginOtpUseCase(sl<LoginOtpRepository>()),
    );
  }

  if (!sl.isRegistered<VerifyLoginOtpUseCase>()) {
    sl.registerLazySingleton<VerifyLoginOtpUseCase>(
      () => VerifyLoginOtpUseCase(sl<VerifyLoginOtpRepository>()),
    );
  }

  if (!sl.isRegistered<ResendLoginOtpUseCase>()) {
    sl.registerLazySingleton<ResendLoginOtpUseCase>(
      () => ResendLoginOtpUseCase(sl<ResendLoginOtpRepository>()),
    );
  }

  if (!sl.isRegistered<SignupUseCase>()) {
    sl.registerLazySingleton<SignupUseCase>(
      () => SignupUseCase(sl<SignupRepository>()),
    );
  }

  if (!sl.isRegistered<VerifySignupOtpUseCase>()) {
    sl.registerLazySingleton<VerifySignupOtpUseCase>(
      () => VerifySignupOtpUseCase(sl<VerifySignupOtpRepository>()),
    );
  }

  if (!sl.isRegistered<ResendSignupOtpUseCase>()) {
    sl.registerLazySingleton<ResendSignupOtpUseCase>(
      () => ResendSignupOtpUseCase(sl<ResendSignupOtpRepository>()),
    );
  }

  if (!sl.isRegistered<SearchUseCase>()) {
    sl.registerLazySingleton<SearchUseCase>(
      () => SearchUseCase(sl<SearchRepository>()),
    );
  }

  if (!sl.isRegistered<BannerUseCase>()) {
    sl.registerLazySingleton<BannerUseCase>(
      () => BannerUseCase(sl<BannerRepository>()),
    );
  }

  if (!sl.isRegistered<PopularRestaurantsUseCase>()) {
    sl.registerLazySingleton<PopularRestaurantsUseCase>(
      () => PopularRestaurantsUseCase(sl<PopularRestaurantsRepository>()),
    );
  }

  if (!sl.isRegistered<OffersUseCase>()) {
    sl.registerLazySingleton<OffersUseCase>(
      () => OffersUseCase(sl<OffersRepository>()),
    );
  }

  if (!sl.isRegistered<GetCategoriesUseCase>()) {
    sl.registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(sl<CategoriesRepository>()),
    );
  }

  if (!sl.isRegistered<GetCategoryProductsUseCase>()) {
    sl.registerLazySingleton<GetCategoryProductsUseCase>(
      () => GetCategoryProductsUseCase(sl<CategoryProductsRepository>()),
    );
  }

  if (!sl.isRegistered<GetProductDetailsUseCase>()) {
    sl.registerLazySingleton<GetProductDetailsUseCase>(
      () => GetProductDetailsUseCase(sl<ProductDetailsRepository>()),
    );
  }

  if (!sl.isRegistered<AddToCartUseCase>()) {
    sl.registerLazySingleton<AddToCartUseCase>(
      () => AddToCartUseCase(sl<AddToCartRepository>()),
    );
  }

  if (!sl.isRegistered<GetOrderSummaryUseCase>()) {
    sl.registerLazySingleton<GetOrderSummaryUseCase>(
      () => GetOrderSummaryUseCase(sl<OrderSummaryRepository>()),
    );
  }

  if (!sl.isRegistered<GetSavedAddressUseCase>()) {
    sl.registerLazySingleton<GetSavedAddressUseCase>(
      () => GetSavedAddressUseCase(sl<SavedAddressRepository>()),
    );
  }

  if (!sl.isRegistered<AddAddressUseCase>()) {
    sl.registerLazySingleton<AddAddressUseCase>(
      () => AddAddressUseCase(sl<AddAddressRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateAddressUseCase>()) {
    sl.registerLazySingleton<UpdateAddressUseCase>(
      () => UpdateAddressUseCase(sl<UpdateAddressRepository>()),
    );
  }

  if (!sl.isRegistered<SelectActiveAddressUseCase>()) {
    sl.registerLazySingleton<SelectActiveAddressUseCase>(
      () => SelectActiveAddressUseCase(sl<SelectActiveAddressRepository>()),
    );
  }

  if (!sl.isRegistered<PlaceOrderUseCase>()) {
    sl.registerLazySingleton<PlaceOrderUseCase>(
      () => PlaceOrderUseCase(sl<PlaceOrderRepository>()),
    );
  }

  if (!sl.isRegistered<InitiatePaymentUseCase>()) {
    sl.registerLazySingleton<InitiatePaymentUseCase>(
      () => InitiatePaymentUseCase(sl<InitiatePaymentRepository>()),
    );
  }

  if (!sl.isRegistered<GetCartUseCase>()) {
    sl.registerLazySingleton<GetCartUseCase>(
      () => GetCartUseCase(sl<GetCartRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateQuantityUseCase>()) {
    sl.registerLazySingleton<UpdateQuantityUseCase>(
      () => UpdateQuantityUseCase(sl<UpdateQuantityRepository>()),
    );
  }

  if (!sl.isRegistered<RemoveCartItemUseCase>()) {
    sl.registerLazySingleton<RemoveCartItemUseCase>(
      () => RemoveCartItemUseCase(sl<RemoveCartItemRepository>()),
    );
  }

  if (!sl.isRegistered<ClearCartUseCase>()) {
    sl.registerLazySingleton<ClearCartUseCase>(
      () => ClearCartUseCase(sl<ClearCartRepository>()),
    );
  }

  if (!sl.isRegistered<GetWishlistUseCase>()) {
    sl.registerLazySingleton<GetWishlistUseCase>(
      () => GetWishlistUseCase(sl<GetWishlistRepository>()),
    );
  }

  if (!sl.isRegistered<ToggleWishlistUseCase>()) {
    sl.registerLazySingleton<ToggleWishlistUseCase>(
      () => ToggleWishlistUseCase(sl<ToggleWishlistRepository>()),
    );
  }

  if (!sl.isRegistered<AddToCartFromWishlistUseCase>()) {
    sl.registerLazySingleton<AddToCartFromWishlistUseCase>(
      () => AddToCartFromWishlistUseCase(sl<AddToCartFromWishlistRepository>()),
    );
  }

  if (!sl.isRegistered<GetOrdersUseCase>()) {
    sl.registerLazySingleton<GetOrdersUseCase>(
      () => GetOrdersUseCase(sl<GetOrdersRepository>()),
    );
  }

  if (!sl.isRegistered<GetOrderDetailsUseCase>()) {
    sl.registerLazySingleton<GetOrderDetailsUseCase>(
      () => GetOrderDetailsUseCase(sl<GetOrderDetailsRepository>()),
    );
  }

  if (!sl.isRegistered<ReOrderUseCase>()) {
    sl.registerLazySingleton<ReOrderUseCase>(
      () => ReOrderUseCase(sl<ReOrderRepository>()),
    );
  }

  if (!sl.isRegistered<GetProfileUseCase>()) {
    sl.registerLazySingleton<GetProfileUseCase>(
      () => GetProfileUseCase(sl<GetProfileRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateProfileUseCase>()) {
    sl.registerLazySingleton<UpdateProfileUseCase>(
      () => UpdateProfileUseCase(sl<UpdateProfileRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateProfilePhotoUseCase>()) {
    sl.registerLazySingleton<UpdateProfilePhotoUseCase>(
      () => UpdateProfilePhotoUseCase(sl<UpdateProfilePhotoRepository>()),
    );
  }

  if (!sl.isRegistered<GetNotificationsUseCase>()) {
    sl.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(sl<GetNotificationsRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteNotificationUseCase>()) {
    sl.registerLazySingleton<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCase(sl<DeleteNotificationRepository>()),
    );
  }

  if (!sl.isRegistered<MarkAsReadUseCase>()) {
    sl.registerLazySingleton<MarkAsReadUseCase>(
      () => MarkAsReadUseCase(sl<MarkAsReadRepository>()),
    );
  }

  if (!sl.isRegistered<GetTermsUseCase>()) {
    sl.registerLazySingleton<GetTermsUseCase>(
      () => GetTermsUseCase(sl<GetTermsRepository>()),
    );
  }

  if (!sl.isRegistered<GetPrivacyPolicyUseCase>()) {
    sl.registerLazySingleton<GetPrivacyPolicyUseCase>(
      () => GetPrivacyPolicyUseCase(sl<GetPrivacyPolicyRepository>()),
    );
  }

  if (!sl.isRegistered<LogoutUseCase>()) {
    sl.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(sl<LogoutRepository>()),
    );
  }

  if (!sl.isRegistered<SubmitSupportUseCase>()) {
    sl.registerLazySingleton<SubmitSupportUseCase>(
      () => SubmitSupportUseCase(sl<SubmitSupportRepository>()),
    );
  }

  if (!sl.isRegistered<StoreFoodReviewUseCase>()) {
    sl.registerLazySingleton<StoreFoodReviewUseCase>(
      () => StoreFoodReviewUseCase(sl<StoreFoodReviewRepository>()),
    );
  }

  if (!sl.isRegistered<StoreUserFeedbackUseCase>()) {
    sl.registerLazySingleton<StoreUserFeedbackUseCase>(
      () => StoreUserFeedbackUseCase(sl<StoreUserFeedbackRepository>()),
    );
  }
}