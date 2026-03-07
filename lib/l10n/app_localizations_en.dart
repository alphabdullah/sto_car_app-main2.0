// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'STO Car Marketplace';

  @override
  String get exploreCategories => 'Explore Categories';

  @override
  String get home => 'Home';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get verifiedAccount => 'Verified Account';

  @override
  String get notVerified => 'Not Verified';

  @override
  String get user => 'User';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get searchHint => 'Search for Vehicles, Parts, Services...';

  @override
  String searchingFor(String value) {
    return 'Searching for: $value';
  }

  @override
  String languageChangedTo(String language) {
    return 'Language changed to $language';
  }

  @override
  String get carAuctions => 'Car Auctions';

  @override
  String liveAuctionsCount(int count) {
    return '$count live auctions';
  }

  @override
  String get stoPerformance => 'STO Performance';

  @override
  String get bookService => 'Book a service';

  @override
  String get performanceParts => 'Performance Parts';

  @override
  String companiesCount(int count) {
    return '$count companies';
  }

  @override
  String get getVerified => 'Get Verified';

  @override
  String get accountVerified => 'Account Verified';

  @override
  String get verifyYourAccount => 'Verify your account';

  @override
  String get signup => 'Signup';

  @override
  String get liveAuctions => 'Live Auctions';

  @override
  String get viewAll => 'View All';

  @override
  String errorLoadingHome(String error) {
    return 'Error loading home screen: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get auctionNotFound => 'Auction not found';

  @override
  String get backToAuctions => 'Back to Auctions';

  @override
  String get description => 'Description';

  @override
  String get winningBid => 'Winning Bid';

  @override
  String get outbid => 'Outbid';

  @override
  String get winning => 'Winning';

  @override
  String get currentBid => 'Current Bid';

  @override
  String get timeLeft => 'Time Left';

  @override
  String get totalBids => 'Total Bids';

  @override
  String get endingSoon => 'Ending soon';

  @override
  String get loginToPlaceBid => 'Login to Place Bid';

  @override
  String get verificationRequired => 'Verification Required';

  @override
  String get pleaseVerifyToPlaceBids =>
      'Please verify your account to place bids';

  @override
  String get verifyNow => 'Verify Now';

  @override
  String get verifyAccountToPlaceBids => 'Verify your account to place bids';

  @override
  String get updateBid => 'Update Bid';

  @override
  String get placeBid => 'Place Bid';

  @override
  String get noLiveAuctions => 'No Live Auctions';

  @override
  String get noLiveAuctionsMessage =>
      'There are currently no live auctions available';

  @override
  String get noBidsYet => 'No Bids Yet';

  @override
  String get loginToViewBiddedAuctions => 'Login to view your bidded auctions';

  @override
  String get noBidsYetMessage =>
      'You haven\'t placed any bids on live auctions';

  @override
  String get noClosedAuctions => 'No Closed Auctions';

  @override
  String get loginToViewClosedAuctions => 'Login to view your closed auctions';

  @override
  String get noClosedAuctionsMessage =>
      'You don\'t have any closed auctions where you were outbid';

  @override
  String get myBids => 'My Bids';

  @override
  String get closed => 'Closed';

  @override
  String get viewDetails => 'View Details';

  @override
  String get verifyToBid => 'Verify to Bid';

  @override
  String placeBidTitle(String title) {
    return 'Place Bid - $title';
  }

  @override
  String minimumBidIs(String amount) {
    return 'Minimum bid is $amount AED';
  }

  @override
  String get bidPlacedSuccess => 'Bid placed successfully!';

  @override
  String get bidFailedTryAgain => 'Failed to place bid. Please try again.';

  @override
  String bidFailedWithError(String error) {
    return 'Failed to place bid: $error';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get bidAmount => 'Bid Amount';

  @override
  String get minimumBid => 'Minimum Bid';

  @override
  String bidsCount(int count) {
    return '$count Bids';
  }

  @override
  String get loginToViewCreateBookings => 'Login to view and create bookings';

  @override
  String get serviceBookings => 'Service Bookings';

  @override
  String bookingCount(int count) {
    return '$count booking';
  }

  @override
  String bookingsCount(int count) {
    return '$count bookings';
  }

  @override
  String get noBookingsYet => 'No Bookings Yet';

  @override
  String get bookFirstServiceAppointment =>
      'Book your first service appointment';

  @override
  String get bookAService => 'Book a Service';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get phone => 'Phone';

  @override
  String get bookingNumberLabel => 'Booking #';

  @override
  String get bookingNumberFull => 'Booking Number';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get back => 'Back';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get carName => 'Car Name';

  @override
  String get carModel => 'Car Model';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get carNameHint => 'e.g., BMW, Mercedes';

  @override
  String get carModelHint => 'e.g., 3 Series, C-Class';

  @override
  String get submitBooking => 'Submit Booking';

  @override
  String get enterServiceDescription =>
      'Enter service description or additional notes';

  @override
  String get preferredDate => 'Preferred Date';

  @override
  String get preferredTime => 'Preferred Time';

  @override
  String get selectPreferredDate => 'Select preferred date';

  @override
  String get selectPreferredTime => 'Select preferred time';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get pleaseEnterPhone => 'Please enter your phone number';

  @override
  String get pleaseEnterCarModel => 'Please enter car model';

  @override
  String get pleaseEnterCarName => 'Please enter car name';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get pleaseSelectTime => 'Please select a time';

  @override
  String get bookingSubmittedSuccess => 'Booking submitted successfully!';

  @override
  String failedToSubmitBooking(String error) {
    return 'Failed to submit booking: $error';
  }

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get createdAt => 'Created At';

  @override
  String get adminNotes => 'Admin Notes';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectTime => 'Select time';

  @override
  String get unverifiedAccount => 'Unverified Account';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get email => 'Email';

  @override
  String get role => 'Role';

  @override
  String get memberSince => 'Member Since';

  @override
  String get emiratesId => 'Emirates ID';

  @override
  String get frontSide => 'Front Side';

  @override
  String get backSide => 'Back Side';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get parts => 'Parts';

  @override
  String get noPartsAvailable => 'No Parts Available';

  @override
  String get noPartsAvailableMessage =>
      'This company doesn\'t have any parts listed yet';

  @override
  String get inStock => 'In Stock';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get price => 'Price';

  @override
  String get available => 'Available';

  @override
  String get verifyAccountToPurchaseParts =>
      'Verify your account to purchase parts';

  @override
  String get purchase => 'Purchase';

  @override
  String get featuredMarketplace => 'Featured Marketplace';

  @override
  String viewingProductsFrom(String name) {
    return 'Viewing products from $name';
  }

  @override
  String showingSpecializedComponents(int count) {
    return 'Showing $count specialized components';
  }

  @override
  String get advancedFilters => 'Advanced Filters';

  @override
  String get live => 'Live';

  @override
  String get noPartsFound => 'No Parts Found';

  @override
  String get noPartsFoundMessage =>
      'Try adjusting your filters or search query';

  @override
  String get resetAll => 'Reset All';

  @override
  String get condition => 'CONDITION';

  @override
  String get priceRangeAed => 'PRICE RANGE (AED)';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get partsStore => 'Parts Store';

  @override
  String get explorePremiumComponents => 'Explore Premium Components';

  @override
  String get searchPartsHint => 'Search parts, brands, OEM...';

  @override
  String get verifiedBrands => 'Verified Brands';

  @override
  String get totalParts => 'Total Parts';

  @override
  String get featured => 'FEATURED';

  @override
  String get shopByBrand => 'SHOP BY BRAND';

  @override
  String get allBrands => 'All Brands';

  @override
  String get partNumber => 'Part #';

  @override
  String get oemNumber => 'OEM #';

  @override
  String get compatible => 'Compatible';

  @override
  String get years => 'Years';

  @override
  String get present => 'Present';

  @override
  String get stock => 'Stock';

  @override
  String get units => 'units';

  @override
  String unitsCount(int count) {
    return '$count Units';
  }

  @override
  String get verifyAccountToPurchase => 'Verify account to purchase';

  @override
  String get purchaseNow => 'Purchase Now';

  @override
  String purchasedSuccess(String name) {
    return '$name purchased successfully!';
  }

  @override
  String get purchaseFailedTryAgain => 'Purchase failed. Please try again.';

  @override
  String get notifications => 'Notifications';

  @override
  String unreadNotificationCount(int count) {
    return '$count unread notification';
  }

  @override
  String unreadNotificationsCount(int count) {
    return '$count unread notifications';
  }

  @override
  String get allCaughtUp => 'All caught up!';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get delete => 'Delete';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get emptyNotificationsMessage =>
      'You\'re all caught up!\nWe\'ll notify you when something important happens.';

  @override
  String get loginRequired => 'Login Required';

  @override
  String get pleaseLoginToViewNotifications =>
      'Please login to view your notifications';

  @override
  String get login => 'Login';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get adminOverview => 'Admin Overview';

  @override
  String get statisticsOverview => 'Statistics Overview';

  @override
  String get auctionRevenue => 'Auction Revenue';

  @override
  String get partsRevenue => 'Parts Revenue';

  @override
  String get pendingAuctions => 'Pending Auctions';

  @override
  String get partsAvailable => 'Parts Available';

  @override
  String get bookingsToday => 'Bookings Today';

  @override
  String get pendingBookings => 'Pending Bookings';

  @override
  String get totalAuctions => 'Total Auctions';

  @override
  String get totalUsers => 'Total Users';

  @override
  String get verifiedUsers => 'Verified Users';

  @override
  String get visualAnalytics => 'Visual Analytics';

  @override
  String get allMetrics => 'All Metrics';

  @override
  String get pendingApproval => 'Pending Approval';

  @override
  String get totalBookings => 'Total Bookings';

  @override
  String get allTime => 'All Time';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get barChart => 'Bar Chart';

  @override
  String get pieChart => 'Pie Chart';

  @override
  String get lineChart => 'Line Chart';

  @override
  String get statisticsComparison => 'Statistics Comparison';

  @override
  String get distributionOverview => 'Distribution Overview';

  @override
  String get trendAnalysis => 'Trend Analysis';

  @override
  String get chartAuctions => 'Auctions';

  @override
  String get chartLive => 'Live';

  @override
  String get chartPending => 'Pending';

  @override
  String get chartParts => 'Parts';

  @override
  String get chartBookings => 'Bookings';

  @override
  String get chartPendingB => 'Pending B';

  @override
  String get chartUsers => 'Users';

  @override
  String get chartVerified => 'Verified';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get fullNameHint => 'Enter your full name';

  @override
  String get phoneNumberHint => 'Enter your phone number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get tapToUpload => 'Tap to upload';

  @override
  String get uploadEmiratesId => 'Upload Emirates ID';

  @override
  String get uploadEmiratesIdDescription =>
      'Please upload both the front and back of your Emirates Card for verification.';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get forgotPasswordDescription =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get rememberPassword => 'Remember your password? ';

  @override
  String get manageAuctions => 'Manage Auctions';

  @override
  String get manageAndApproveAuctions => 'Manage and approve auctions';

  @override
  String get pendingApprovalTab => 'Pending Approval';

  @override
  String get allAuctionsTab => 'All Auctions';

  @override
  String get noPendingAuctions => 'No Pending Auctions';

  @override
  String get allAuctionsReviewed => 'All auctions have been reviewed';

  @override
  String get noAuctions => 'No Auctions';

  @override
  String get noAuctionsCreatedYet => 'No auctions have been created yet';

  @override
  String get startingBid => 'Starting Bid';

  @override
  String get lotNumber => 'Lot #';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get statusPending => 'PENDING';

  @override
  String get statusApproved => 'APPROVED';

  @override
  String get statusLive => 'LIVE';

  @override
  String get statusClosed => 'CLOSED';

  @override
  String get statusRejected => 'REJECTED';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get auctionApprovedSuccessfully => 'Auction approved successfully';

  @override
  String get auctionRejected => 'Auction rejected';

  @override
  String get failedToLoadPendingAuctions =>
      'Failed to load pending auctions. Please try again.';

  @override
  String get failedToApproveAuction =>
      'Failed to approve auction. Please try again.';

  @override
  String get failedToRejectAuction =>
      'Failed to reject auction. Please try again.';

  @override
  String get manageBookings => 'Manage Bookings';

  @override
  String get manageAndApproveBookings => 'Manage and approve bookings';

  @override
  String get noPendingBookings => 'No Pending Bookings';

  @override
  String get allBookingsReviewed => 'All bookings have been reviewed';

  @override
  String get noBookings => 'No Bookings';

  @override
  String get noBookingsCreatedYet => 'No bookings have been created yet';

  @override
  String get pendingTab => 'Pending';

  @override
  String get allBookingsTab => 'All Bookings';

  @override
  String get createdLabel => 'Created';

  @override
  String get pending => 'Pending';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get completed => 'Completed';

  @override
  String get bookingApprovedSuccessfully => 'Booking approved successfully';

  @override
  String get bookingRejected => 'Booking rejected';

  @override
  String get rejectBookingTitle => 'Reject Booking';

  @override
  String get rejectBookingConfirmMessage =>
      'Are you sure you want to reject this booking?';

  @override
  String get rejectionReasonLabel => 'Rejection Reason *';

  @override
  String get rejectionReasonHint => 'e.g., Service not available';

  @override
  String get additionalNotesLabel => 'Additional Notes';

  @override
  String get additionalNotesHint => 'Please choose another date';

  @override
  String get rejectionReasonRequired => 'Rejection reason is required';

  @override
  String get bookingIdLabel => 'Booking ID';

  @override
  String get userLabel => 'User';

  @override
  String get statusLabel => 'Status';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String get vehicleDetails => 'Vehicle Details';

  @override
  String get carLabel => 'Car';

  @override
  String get modelLabel => 'Model';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get descriptionNotes => 'Description/Notes';

  @override
  String get close => 'Close';

  @override
  String get details => 'Details';

  @override
  String get editFormFields => 'Edit Form Fields';

  @override
  String get customizeBookingFormFields => 'Customize booking form fields';

  @override
  String get save => 'Save';

  @override
  String get formFieldsCustomizeInfo =>
      'Customize the booking form fields. Users will see these fields when creating a booking.';

  @override
  String get addNewField => 'Add New Field';

  @override
  String get noFieldsAddedYet => 'No fields added yet';

  @override
  String get tapAddNewFieldHint =>
      'Tap \"Add New Field\" to create your first field';

  @override
  String get formFieldsUpdatedSuccess => 'Form fields updated successfully';

  @override
  String get fieldLabel => 'Field Label';

  @override
  String get enterFieldLabel => 'Enter field label';

  @override
  String get fieldType => 'Field Type';

  @override
  String get placeholderOptional => 'Placeholder (Optional)';

  @override
  String get enterPlaceholderText => 'Enter placeholder text';

  @override
  String get optionsCommaSeparated => 'Options (comma-separated)';

  @override
  String get optionsHint => 'Option 1, Option 2, Option 3';

  @override
  String get requiredField => 'Required Field';

  @override
  String get usersMustFillThisField => 'Users must fill this field';

  @override
  String get newField => 'New Field';

  @override
  String get fieldTypeText => 'Text';

  @override
  String get fieldTypeNumber => 'Number';

  @override
  String get fieldTypeDate => 'Date';

  @override
  String get fieldTypeTime => 'Time';

  @override
  String get fieldTypeDropdown => 'Dropdown';

  @override
  String get fieldTypeCheckbox => 'Checkbox';

  @override
  String get fieldTypeTextarea => 'Textarea';

  @override
  String get soldParts => 'Sold Parts';

  @override
  String get saleRecorded => 'sale recorded';

  @override
  String get salesRecorded => 'sales recorded';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'unit';

  @override
  String get total => 'Total';

  @override
  String get soldOn => 'Sold on';

  @override
  String get buyer => 'Buyer';

  @override
  String get noSalesRecorded => 'No Sales Recorded';

  @override
  String get noPartsSoldYet => 'No parts have been sold yet';

  @override
  String get addPart => 'Add Part';

  @override
  String timeMinAgo(int count) {
    return '$count min ago';
  }

  @override
  String get timeHourAgo => '1 hour ago';

  @override
  String timeHoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String timeDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get editPart => 'Edit Part';

  @override
  String get company => 'Company';

  @override
  String get partName => 'Part Name';

  @override
  String get category => 'Category';

  @override
  String get priceAed => 'Price (AED)';

  @override
  String get stockQuantity => 'Stock Quantity';

  @override
  String get pleaseFillRequiredFields => 'Please fill all required fields';

  @override
  String get partUpdatedSuccessfully => 'Part updated successfully';

  @override
  String get partAddedSuccessfully => 'Part added successfully';

  @override
  String get deletePartTitle => 'Delete Part';

  @override
  String get deletePartConfirmMessage =>
      'Are you sure you want to delete this part?';

  @override
  String get partDeletedSuccessfully => 'Part deleted successfully';

  @override
  String get add => 'Add';

  @override
  String get wallet => 'Wallet';

  @override
  String get balance => 'Balance';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get verificationDescription =>
      'To participate in auctions and purchase parts, please deposit 4,500 AED to verify your account.';

  @override
  String get depositAmountLabel => 'Deposit Amount';

  @override
  String amountCurrency(String currency) {
    return 'Amount ($currency)';
  }

  @override
  String get enterDepositAmount => 'Enter deposit amount';

  @override
  String get depositWithStripe => 'Deposit with Stripe';

  @override
  String get quickDeposit => 'Quick Deposit';

  @override
  String get deposit => 'Deposit';

  @override
  String get withdrawal => 'Withdrawal';

  @override
  String dateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String depositSuccess(Object amount) {
    return 'Deposit of $amount AED successful!';
  }

  @override
  String get accountVerifiedMessage =>
      'Account verified! You can now bid and purchase parts.';

  @override
  String get depositFailed => 'Deposit failed';

  @override
  String get depositFailedTryAgain => 'Deposit failed. Please try again.';
}
