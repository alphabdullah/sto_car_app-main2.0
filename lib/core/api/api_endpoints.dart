/// API Endpoints Configuration
///
/// Centralized definition of all API endpoints for the STO Car platform.
/// Organized by feature category for easy maintenance and reference.
class ApiEndpoints {
  ApiEndpoints._();

  // Base Configuration
  // For Android Emulator: use 10.0.2.2 instead of localhost
  // For iOS Simulator: use localhost
  // For Physical Device: use your computer's IP address (e.g., http://192.168.1.100:8000)
  static String get baseUrl {
    // Live Server URL (Hostinger)
    return 'https://www.bidssync.com';
  }

  static const String apiVersion = 'v1';
  static const String apiPrefix = '/api/$apiVersion';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String contentTypeMultipart = 'multipart/form-data';
  static const String acceptJson = 'application/json';

  // ============================================================================
  // AUTHENTICATION ENDPOINTS
  // ============================================================================

  static const String authPrefix = '$apiPrefix/auth';

  /// Register a new user
  /// POST /api/v1/auth/register
  static const String register = '$authPrefix/register';

  /// Login user
  /// POST /api/v1/auth/login
  static const String login = '$authPrefix/login';

  /// Admin login
  /// POST /api/v1/auth/admin/login
  static const String adminLogin = '$authPrefix/admin/login';

  /// Request password reset OTP
  /// POST /api/v1/auth/forgot-password
  static const String forgotPassword = '$authPrefix/forgot-password';

  /// Reset password with OTP
  /// POST /api/v1/auth/reset-password
  static const String resetPassword = '$authPrefix/reset-password';

  /// Logout user
  /// POST /api/v1/auth/logout
  static const String logout = '$authPrefix/logout';

  /// Get current authenticated user
  /// GET /api/v1/auth/me
  static const String getCurrentUser = '$authPrefix/me';

  /// Update user profile
  /// PUT /api/v1/auth/profile
  static const String updateProfile = '$authPrefix/profile';

  /// Update profile image
  /// POST /api/v1/auth/profile/image
  static const String updateProfileImage = '$authPrefix/profile/image';

  /// Change password
  /// POST /api/v1/auth/change-password
  static const String changePassword = '$authPrefix/change-password';

  /// Verify user account
  /// POST /api/v1/auth/verify
  static const String verifyAccount = '$authPrefix/verify';

  /// Request verification OTP
  /// POST /api/v1/auth/request-verification
  static const String requestVerification = '$authPrefix/request-verification';

  // ============================================================================
  // AUCTION ENDPOINTS
  // ============================================================================

  static const String auctionsPrefix = '$apiPrefix/auctions';

  /// Get all auctions with filters
  /// GET /api/v1/auctions
  static const String getAuctions = auctionsPrefix;

  /// Get single auction details
  /// GET /api/v1/auctions/:id
  static String getAuction(String id) => '$auctionsPrefix/$id';

  /// Create new auction
  /// POST /api/v1/auctions
  static const String createAuction = auctionsPrefix;

  /// Update auction
  /// PUT /api/v1/auctions/:id
  static String updateAuction(String id) => '$auctionsPrefix/$id';

  /// Delete auction
  /// DELETE /api/v1/auctions/:id
  static String deleteAuction(String id) => '$auctionsPrefix/$id';

  /// Place a bid
  /// POST /api/v1/auctions/:id/bid
  static String placeBid(String id) => '$auctionsPrefix/$id/bid';

  /// Watch an auction
  /// POST /api/v1/auctions/:id/watch
  static String watchAuction(String id) => '$auctionsPrefix/$id/watch';

  /// Unwatch an auction
  /// DELETE /api/v1/auctions/:id/watch
  static String unwatchAuction(String id) => '$auctionsPrefix/$id/watch';

  /// Get user's bidded auctions
  /// GET /api/v1/my-bids
  static const String getMyBids = '$apiPrefix/my-bids';

  /// Get user's created auctions
  /// GET /api/v1/my-auctions
  static const String getMyAuctions = '$apiPrefix/my-auctions';

  /// Get watched auctions
  /// GET /api/v1/watched-auctions
  static const String getWatchedAuctions = '$apiPrefix/watched-auctions';

  // ============================================================================
  // PARTS ENDPOINTS
  // ============================================================================

  static const String partsPrefix = '$apiPrefix/parts';

  /// Get all parts with filters
  /// GET /api/v1/parts
  static const String getParts = partsPrefix;

  /// Get single part details
  /// GET /api/v1/parts/:id
  static String getPart(String id) => '$partsPrefix/$id';

  /// Get part categories
  /// GET /api/v1/parts/categories
  static const String getPartCategories = '$partsPrefix/categories';

  /// Create new part listing
  /// POST /api/v1/parts
  static const String createPart = partsPrefix;

  /// Update part listing
  /// PUT /api/v1/parts/:id
  static String updatePart(String id) => '$partsPrefix/$id';

  /// Delete part listing
  /// DELETE /api/v1/parts/:id
  static String deletePart(String id) => '$partsPrefix/$id';

  /// Purchase a part
  /// POST /api/v1/parts/:id/purchase
  static String purchasePart(String id) => '$partsPrefix/$id/purchase';

  /// Add part to favorites
  /// POST /api/v1/parts/:id/favorite
  static String addPartToFavorites(String id) => '$partsPrefix/$id/favorite';

  /// Remove part from favorites
  /// DELETE /api/v1/parts/:id/favorite
  static String removePartFromFavorites(String id) =>
      '$partsPrefix/$id/favorite';

  /// Get user's part listings
  /// GET /api/v1/my-parts
  static const String getMyParts = '$apiPrefix/my-parts';

  /// Get user's purchased parts
  /// GET /api/v1/my-purchases
  static const String getMyPurchases = '$apiPrefix/my-purchases';

  /// Get user's sold parts
  /// GET /api/v1/my-sales
  static const String getMySales = '$apiPrefix/my-sales';

  /// Get favorite parts
  /// GET /api/v1/favorite-parts
  static const String getFavoriteParts = '$apiPrefix/favorite-parts';

  // ============================================================================
  // SERVICE TYPES ENDPOINTS
  // ============================================================================

  static const String serviceTypesPrefix = '$apiPrefix/service-types';

  /// Get service types with fields
  /// GET /api/v1/service-types
  static const String getServiceTypes = serviceTypesPrefix;

  // ============================================================================
  // BOOKINGS ENDPOINTS
  // ============================================================================

  static const String bookingsPrefix = '$apiPrefix/bookings';

  /// Get user's bookings
  /// GET /api/v1/bookings
  static const String getBookings = bookingsPrefix;

  /// Create new booking
  /// POST /api/v1/bookings
  static const String createBooking = bookingsPrefix;

  /// Get single booking details
  /// GET /api/v1/bookings/:id
  static String getBooking(String id) => '$bookingsPrefix/$id';

  /// Update booking
  /// PUT /api/v1/bookings/:id
  static String updateBooking(String id) => '$bookingsPrefix/$id';

  /// Cancel booking
  /// POST /api/v1/bookings/:id/cancel
  static String cancelBooking(String id) => '$bookingsPrefix/$id/cancel';

  /// Create service booking
  /// POST /api/v1/service-bookings
  static const String createServiceBooking = '$apiPrefix/service-bookings';

  // ============================================================================
  // WALLET ENDPOINTS
  // ============================================================================

  static const String walletPrefix = '$apiPrefix/wallet';

  /// Get wallet details
  /// GET /api/v1/wallet
  static const String getWallet = walletPrefix;

  /// Get wallet transactions
  /// GET /api/v1/wallet/transactions
  static const String getWalletTransactions = '$walletPrefix/transactions';

  /// Get transaction summary
  /// GET /api/v1/wallet/summary
  static const String getWalletSummary = '$walletPrefix/summary';

  /// Deposit to wallet (simulation - in real app would integrate payment gateway)
  /// POST /api/v1/wallet/deposit
  static const String depositToWallet = '$walletPrefix/deposit';

  /// Withdraw from wallet
  /// POST /api/v1/wallet/withdraw
  static const String withdrawFromWallet = '$walletPrefix/withdraw';

  // Stripe Payments
  static const String stripePrefix = '$apiPrefix/payments/stripe';

  /// Create verification intent
  /// POST /api/v1/payments/stripe/verification-intent
  static const String createVerificationIntent =
      '$stripePrefix/verification-intent';

  /// Confirm stripe payment
  /// POST /api/v1/payments/stripe/confirm
  static const String confirmStripePayment = '$stripePrefix/confirm';

  // ============================================================================
  // NOTIFICATIONS ENDPOINTS
  // ============================================================================

  static const String notificationsPrefix = '$apiPrefix/notifications';

  /// Get user's notifications
  /// GET /api/v1/notifications
  static const String getNotifications = notificationsPrefix;

  /// Get unread count
  /// GET /api/v1/notifications/unread-count
  static const String getUnreadCount = '$notificationsPrefix/unread-count';

  /// Mark notification as read
  /// POST /api/v1/notifications/:id/read
  static String markNotificationAsRead(String id) =>
      '$notificationsPrefix/$id/read';

  /// Mark all notifications as read
  /// POST /api/v1/notifications/read-all
  static const String markAllNotificationsAsRead =
      '$notificationsPrefix/read-all';

  /// Delete notification
  /// DELETE /api/v1/notifications/:id
  static String deleteNotification(String id) => '$notificationsPrefix/$id';

  /// Delete all notifications
  /// DELETE /api/v1/notifications
  static const String deleteAllNotifications = notificationsPrefix;

  // ============================================================================
  // ADMIN ENDPOINTS
  // ============================================================================

  static const String adminPrefix = '$apiPrefix/admin';

  /// Get dashboard statistics
  /// GET /api/v1/admin/dashboard
  static const String getAdminDashboard = '$adminPrefix/dashboard';

  /// Get recent activities
  /// GET /api/v1/admin/activities
  static const String getAdminActivities = '$adminPrefix/activities';

  // Admin Users
  static const String adminUsersPrefix = '$adminPrefix/users';

  /// Get all users
  /// GET /api/v1/admin/users
  static const String getAdminUsers = adminUsersPrefix;

  /// Update user
  /// PUT /api/v1/admin/users/:id
  static String updateAdminUser(String id) => '$adminUsersPrefix/$id';

  /// Delete user
  /// DELETE /api/v1/admin/users/:id
  static String deleteAdminUser(String id) => '$adminUsersPrefix/$id';

  // Admin Auctions
  static const String adminAuctionsPrefix = '$adminPrefix/auctions';

  /// Get pending auctions for approval
  /// GET /api/v1/admin/auctions/pending
  static const String getPendingAuctions = '$adminAuctionsPrefix/pending';

  /// Approve auction
  /// POST /api/v1/admin/auctions/:id/approve
  static String approveAuction(String id) => '$adminAuctionsPrefix/$id/approve';

  /// Reject auction
  /// POST /api/v1/admin/auctions/:id/reject
  static String rejectAuction(String id) => '$adminAuctionsPrefix/$id/reject';

  // Admin Bookings
  static const String adminBookingsPrefix = '$adminPrefix/bookings';

  /// Get all bookings
  /// GET /api/v1/admin/bookings
  static const String getAdminBookings = adminBookingsPrefix;

  /// Get service bookings
  /// GET /api/v1/admin/service-bookings
  static const String getServiceBookings = '$adminPrefix/service-bookings';

  /// Approve booking
  /// POST /api/v1/admin/bookings/:id/approve
  static String approveBooking(String id) => '$adminBookingsPrefix/$id/approve';

  /// Reject booking
  /// POST /api/v1/admin/bookings/:id/reject
  static String rejectBooking(String id) => '$adminBookingsPrefix/$id/reject';

  /// Update booking status
  /// PUT /api/v1/admin/bookings/:id/status
  static String updateBookingStatus(String id) =>
      '$adminBookingsPrefix/$id/status';

  // Admin Service Types
  static const String adminServiceTypesPrefix = '$adminPrefix/service-types';

  /// Get all service types
  /// GET /api/v1/admin/service-types
  static const String getAdminServiceTypes = adminServiceTypesPrefix;

  /// Create service type
  /// POST /api/v1/admin/service-types
  static const String createServiceType = adminServiceTypesPrefix;

  /// Update service type
  /// PUT /api/v1/admin/service-types/:id
  static String updateServiceType(String id) => '$adminServiceTypesPrefix/$id';

  /// Delete service type
  /// DELETE /api/v1/admin/service-types/:id
  static String deleteServiceType(String id) => '$adminServiceTypesPrefix/$id';

  // Admin Service Fields
  static const String adminServiceFieldsPrefix = '$adminPrefix/service-fields';

  /// Add field to service type
  /// POST /api/v1/admin/service-types/:id/fields
  static String addServiceTypeField(String id) =>
      '$adminServiceTypesPrefix/$id/fields';

  /// Update service field
  /// PUT /api/v1/admin/service-fields/:id
  static String updateServiceField(String id) =>
      '$adminServiceFieldsPrefix/$id';

  /// Delete service field
  /// DELETE /api/v1/admin/service-fields/:id
  static String deleteServiceField(String id) =>
      '$adminServiceFieldsPrefix/$id';
}
