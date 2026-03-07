import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'STO Car Marketplace'**
  String get appTitle;

  /// No description provided for @exploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore Categories'**
  String get exploreCategories;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @verifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'Verified Account'**
  String get verifiedAccount;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for Vehicles, Parts, Services...'**
  String get searchHint;

  /// No description provided for @searchingFor.
  ///
  /// In en, this message translates to:
  /// **'Searching for: {value}'**
  String searchingFor(String value);

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChangedTo(String language);

  /// No description provided for @carAuctions.
  ///
  /// In en, this message translates to:
  /// **'Car Auctions'**
  String get carAuctions;

  /// No description provided for @liveAuctionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} live auctions'**
  String liveAuctionsCount(int count);

  /// No description provided for @stoPerformance.
  ///
  /// In en, this message translates to:
  /// **'STO Performance'**
  String get stoPerformance;

  /// No description provided for @bookService.
  ///
  /// In en, this message translates to:
  /// **'Book a service'**
  String get bookService;

  /// No description provided for @performanceParts.
  ///
  /// In en, this message translates to:
  /// **'Performance Parts'**
  String get performanceParts;

  /// No description provided for @companiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} companies'**
  String companiesCount(int count);

  /// No description provided for @getVerified.
  ///
  /// In en, this message translates to:
  /// **'Get Verified'**
  String get getVerified;

  /// No description provided for @accountVerified.
  ///
  /// In en, this message translates to:
  /// **'Account Verified'**
  String get accountVerified;

  /// No description provided for @verifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify your account'**
  String get verifyYourAccount;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @liveAuctions.
  ///
  /// In en, this message translates to:
  /// **'Live Auctions'**
  String get liveAuctions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @errorLoadingHome.
  ///
  /// In en, this message translates to:
  /// **'Error loading home screen: {error}'**
  String errorLoadingHome(String error);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @auctionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Auction not found'**
  String get auctionNotFound;

  /// No description provided for @backToAuctions.
  ///
  /// In en, this message translates to:
  /// **'Back to Auctions'**
  String get backToAuctions;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @winningBid.
  ///
  /// In en, this message translates to:
  /// **'Winning Bid'**
  String get winningBid;

  /// No description provided for @outbid.
  ///
  /// In en, this message translates to:
  /// **'Outbid'**
  String get outbid;

  /// No description provided for @winning.
  ///
  /// In en, this message translates to:
  /// **'Winning'**
  String get winning;

  /// No description provided for @currentBid.
  ///
  /// In en, this message translates to:
  /// **'Current Bid'**
  String get currentBid;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time Left'**
  String get timeLeft;

  /// No description provided for @totalBids.
  ///
  /// In en, this message translates to:
  /// **'Total Bids'**
  String get totalBids;

  /// No description provided for @endingSoon.
  ///
  /// In en, this message translates to:
  /// **'Ending soon'**
  String get endingSoon;

  /// No description provided for @loginToPlaceBid.
  ///
  /// In en, this message translates to:
  /// **'Login to Place Bid'**
  String get loginToPlaceBid;

  /// No description provided for @verificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification Required'**
  String get verificationRequired;

  /// No description provided for @pleaseVerifyToPlaceBids.
  ///
  /// In en, this message translates to:
  /// **'Please verify your account to place bids'**
  String get pleaseVerifyToPlaceBids;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @verifyAccountToPlaceBids.
  ///
  /// In en, this message translates to:
  /// **'Verify your account to place bids'**
  String get verifyAccountToPlaceBids;

  /// No description provided for @updateBid.
  ///
  /// In en, this message translates to:
  /// **'Update Bid'**
  String get updateBid;

  /// No description provided for @placeBid.
  ///
  /// In en, this message translates to:
  /// **'Place Bid'**
  String get placeBid;

  /// No description provided for @noLiveAuctions.
  ///
  /// In en, this message translates to:
  /// **'No Live Auctions'**
  String get noLiveAuctions;

  /// No description provided for @noLiveAuctionsMessage.
  ///
  /// In en, this message translates to:
  /// **'There are currently no live auctions available'**
  String get noLiveAuctionsMessage;

  /// No description provided for @noBidsYet.
  ///
  /// In en, this message translates to:
  /// **'No Bids Yet'**
  String get noBidsYet;

  /// No description provided for @loginToViewBiddedAuctions.
  ///
  /// In en, this message translates to:
  /// **'Login to view your bidded auctions'**
  String get loginToViewBiddedAuctions;

  /// No description provided for @noBidsYetMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t placed any bids on live auctions'**
  String get noBidsYetMessage;

  /// No description provided for @noClosedAuctions.
  ///
  /// In en, this message translates to:
  /// **'No Closed Auctions'**
  String get noClosedAuctions;

  /// No description provided for @loginToViewClosedAuctions.
  ///
  /// In en, this message translates to:
  /// **'Login to view your closed auctions'**
  String get loginToViewClosedAuctions;

  /// No description provided for @noClosedAuctionsMessage.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any closed auctions where you were outbid'**
  String get noClosedAuctionsMessage;

  /// No description provided for @myBids.
  ///
  /// In en, this message translates to:
  /// **'My Bids'**
  String get myBids;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @verifyToBid.
  ///
  /// In en, this message translates to:
  /// **'Verify to Bid'**
  String get verifyToBid;

  /// No description provided for @placeBidTitle.
  ///
  /// In en, this message translates to:
  /// **'Place Bid - {title}'**
  String placeBidTitle(String title);

  /// No description provided for @minimumBidIs.
  ///
  /// In en, this message translates to:
  /// **'Minimum bid is {amount} AED'**
  String minimumBidIs(String amount);

  /// No description provided for @bidPlacedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bid placed successfully!'**
  String get bidPlacedSuccess;

  /// No description provided for @bidFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Failed to place bid. Please try again.'**
  String get bidFailedTryAgain;

  /// No description provided for @bidFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Failed to place bid: {error}'**
  String bidFailedWithError(String error);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @bidAmount.
  ///
  /// In en, this message translates to:
  /// **'Bid Amount'**
  String get bidAmount;

  /// No description provided for @minimumBid.
  ///
  /// In en, this message translates to:
  /// **'Minimum Bid'**
  String get minimumBid;

  /// No description provided for @bidsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Bids'**
  String bidsCount(int count);

  /// No description provided for @loginToViewCreateBookings.
  ///
  /// In en, this message translates to:
  /// **'Login to view and create bookings'**
  String get loginToViewCreateBookings;

  /// No description provided for @serviceBookings.
  ///
  /// In en, this message translates to:
  /// **'Service Bookings'**
  String get serviceBookings;

  /// No description provided for @bookingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} booking'**
  String bookingCount(int count);

  /// No description provided for @bookingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} bookings'**
  String bookingsCount(int count);

  /// No description provided for @noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No Bookings Yet'**
  String get noBookingsYet;

  /// No description provided for @bookFirstServiceAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book your first service appointment'**
  String get bookFirstServiceAppointment;

  /// No description provided for @bookAService.
  ///
  /// In en, this message translates to:
  /// **'Book a Service'**
  String get bookAService;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @bookingNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking #'**
  String get bookingNumberLabel;

  /// No description provided for @bookingNumberFull.
  ///
  /// In en, this message translates to:
  /// **'Booking Number'**
  String get bookingNumberFull;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @carName.
  ///
  /// In en, this message translates to:
  /// **'Car Name'**
  String get carName;

  /// No description provided for @carModel.
  ///
  /// In en, this message translates to:
  /// **'Car Model'**
  String get carModel;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @carNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., BMW, Mercedes'**
  String get carNameHint;

  /// No description provided for @carModelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 3 Series, C-Class'**
  String get carModelHint;

  /// No description provided for @submitBooking.
  ///
  /// In en, this message translates to:
  /// **'Submit Booking'**
  String get submitBooking;

  /// No description provided for @enterServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter service description or additional notes'**
  String get enterServiceDescription;

  /// No description provided for @preferredDate.
  ///
  /// In en, this message translates to:
  /// **'Preferred Date'**
  String get preferredDate;

  /// No description provided for @preferredTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred Time'**
  String get preferredTime;

  /// No description provided for @selectPreferredDate.
  ///
  /// In en, this message translates to:
  /// **'Select preferred date'**
  String get selectPreferredDate;

  /// No description provided for @selectPreferredTime.
  ///
  /// In en, this message translates to:
  /// **'Select preferred time'**
  String get selectPreferredTime;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterCarModel.
  ///
  /// In en, this message translates to:
  /// **'Please enter car model'**
  String get pleaseEnterCarModel;

  /// No description provided for @pleaseEnterCarName.
  ///
  /// In en, this message translates to:
  /// **'Please enter car name'**
  String get pleaseEnterCarName;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get pleaseSelectTime;

  /// No description provided for @bookingSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking submitted successfully!'**
  String get bookingSubmittedSuccess;

  /// No description provided for @failedToSubmitBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit booking: {error}'**
  String failedToSubmitBooking(String error);

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @adminNotes.
  ///
  /// In en, this message translates to:
  /// **'Admin Notes'**
  String get adminNotes;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @unverifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'Unverified Account'**
  String get unverifiedAccount;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @emiratesId.
  ///
  /// In en, this message translates to:
  /// **'Emirates ID'**
  String get emiratesId;

  /// No description provided for @frontSide.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get frontSide;

  /// No description provided for @backSide.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get backSide;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @parts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get parts;

  /// No description provided for @noPartsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Parts Available'**
  String get noPartsAvailable;

  /// No description provided for @noPartsAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'This company doesn\'t have any parts listed yet'**
  String get noPartsAvailableMessage;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @verifyAccountToPurchaseParts.
  ///
  /// In en, this message translates to:
  /// **'Verify your account to purchase parts'**
  String get verifyAccountToPurchaseParts;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @featuredMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Featured Marketplace'**
  String get featuredMarketplace;

  /// No description provided for @viewingProductsFrom.
  ///
  /// In en, this message translates to:
  /// **'Viewing products from {name}'**
  String viewingProductsFrom(String name);

  /// No description provided for @showingSpecializedComponents.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} specialized components'**
  String showingSpecializedComponents(int count);

  /// No description provided for @advancedFilters.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get advancedFilters;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @noPartsFound.
  ///
  /// In en, this message translates to:
  /// **'No Parts Found'**
  String get noPartsFound;

  /// No description provided for @noPartsFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search query'**
  String get noPartsFoundMessage;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'CONDITION'**
  String get condition;

  /// No description provided for @priceRangeAed.
  ///
  /// In en, this message translates to:
  /// **'PRICE RANGE (AED)'**
  String get priceRangeAed;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @partsStore.
  ///
  /// In en, this message translates to:
  /// **'Parts Store'**
  String get partsStore;

  /// No description provided for @explorePremiumComponents.
  ///
  /// In en, this message translates to:
  /// **'Explore Premium Components'**
  String get explorePremiumComponents;

  /// No description provided for @searchPartsHint.
  ///
  /// In en, this message translates to:
  /// **'Search parts, brands, OEM...'**
  String get searchPartsHint;

  /// No description provided for @verifiedBrands.
  ///
  /// In en, this message translates to:
  /// **'Verified Brands'**
  String get verifiedBrands;

  /// No description provided for @totalParts.
  ///
  /// In en, this message translates to:
  /// **'Total Parts'**
  String get totalParts;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'FEATURED'**
  String get featured;

  /// No description provided for @shopByBrand.
  ///
  /// In en, this message translates to:
  /// **'SHOP BY BRAND'**
  String get shopByBrand;

  /// No description provided for @allBrands.
  ///
  /// In en, this message translates to:
  /// **'All Brands'**
  String get allBrands;

  /// No description provided for @partNumber.
  ///
  /// In en, this message translates to:
  /// **'Part #'**
  String get partNumber;

  /// No description provided for @oemNumber.
  ///
  /// In en, this message translates to:
  /// **'OEM #'**
  String get oemNumber;

  /// No description provided for @compatible.
  ///
  /// In en, this message translates to:
  /// **'Compatible'**
  String get compatible;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @unitsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Units'**
  String unitsCount(int count);

  /// No description provided for @verifyAccountToPurchase.
  ///
  /// In en, this message translates to:
  /// **'Verify account to purchase'**
  String get verifyAccountToPurchase;

  /// No description provided for @purchaseNow.
  ///
  /// In en, this message translates to:
  /// **'Purchase Now'**
  String get purchaseNow;

  /// No description provided for @purchasedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} purchased successfully!'**
  String purchasedSuccess(String name);

  /// No description provided for @purchaseFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get purchaseFailedTryAgain;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @unreadNotificationCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread notification'**
  String unreadNotificationCount(int count);

  /// No description provided for @unreadNotificationsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} unread notifications'**
  String unreadNotificationsCount(int count);

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUp;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotifications;

  /// No description provided for @emptyNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!\nWe\'ll notify you when something important happens.'**
  String get emptyNotificationsMessage;

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @pleaseLoginToViewNotifications.
  ///
  /// In en, this message translates to:
  /// **'Please login to view your notifications'**
  String get pleaseLoginToViewNotifications;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @adminOverview.
  ///
  /// In en, this message translates to:
  /// **'Admin Overview'**
  String get adminOverview;

  /// No description provided for @statisticsOverview.
  ///
  /// In en, this message translates to:
  /// **'Statistics Overview'**
  String get statisticsOverview;

  /// No description provided for @auctionRevenue.
  ///
  /// In en, this message translates to:
  /// **'Auction Revenue'**
  String get auctionRevenue;

  /// No description provided for @partsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Parts Revenue'**
  String get partsRevenue;

  /// No description provided for @pendingAuctions.
  ///
  /// In en, this message translates to:
  /// **'Pending Auctions'**
  String get pendingAuctions;

  /// No description provided for @partsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Parts Available'**
  String get partsAvailable;

  /// No description provided for @bookingsToday.
  ///
  /// In en, this message translates to:
  /// **'Bookings Today'**
  String get bookingsToday;

  /// No description provided for @pendingBookings.
  ///
  /// In en, this message translates to:
  /// **'Pending Bookings'**
  String get pendingBookings;

  /// No description provided for @totalAuctions.
  ///
  /// In en, this message translates to:
  /// **'Total Auctions'**
  String get totalAuctions;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @verifiedUsers.
  ///
  /// In en, this message translates to:
  /// **'Verified Users'**
  String get verifiedUsers;

  /// No description provided for @visualAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Visual Analytics'**
  String get visualAnalytics;

  /// No description provided for @allMetrics.
  ///
  /// In en, this message translates to:
  /// **'All Metrics'**
  String get allMetrics;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @barChart.
  ///
  /// In en, this message translates to:
  /// **'Bar Chart'**
  String get barChart;

  /// No description provided for @pieChart.
  ///
  /// In en, this message translates to:
  /// **'Pie Chart'**
  String get pieChart;

  /// No description provided for @lineChart.
  ///
  /// In en, this message translates to:
  /// **'Line Chart'**
  String get lineChart;

  /// No description provided for @statisticsComparison.
  ///
  /// In en, this message translates to:
  /// **'Statistics Comparison'**
  String get statisticsComparison;

  /// No description provided for @distributionOverview.
  ///
  /// In en, this message translates to:
  /// **'Distribution Overview'**
  String get distributionOverview;

  /// No description provided for @trendAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Trend Analysis'**
  String get trendAnalysis;

  /// No description provided for @chartAuctions.
  ///
  /// In en, this message translates to:
  /// **'Auctions'**
  String get chartAuctions;

  /// No description provided for @chartLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get chartLive;

  /// No description provided for @chartPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get chartPending;

  /// No description provided for @chartParts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get chartParts;

  /// No description provided for @chartBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get chartBookings;

  /// No description provided for @chartPendingB.
  ///
  /// In en, this message translates to:
  /// **'Pending B'**
  String get chartPendingB;

  /// No description provided for @chartUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get chartUsers;

  /// No description provided for @chartVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get chartVerified;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get tapToUpload;

  /// No description provided for @uploadEmiratesId.
  ///
  /// In en, this message translates to:
  /// **'Upload Emirates ID'**
  String get uploadEmiratesId;

  /// No description provided for @uploadEmiratesIdDescription.
  ///
  /// In en, this message translates to:
  /// **'Please upload both the front and back of your Emirates Card for verification.'**
  String get uploadEmiratesIdDescription;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password? '**
  String get rememberPassword;

  /// No description provided for @manageAuctions.
  ///
  /// In en, this message translates to:
  /// **'Manage Auctions'**
  String get manageAuctions;

  /// No description provided for @manageAndApproveAuctions.
  ///
  /// In en, this message translates to:
  /// **'Manage and approve auctions'**
  String get manageAndApproveAuctions;

  /// No description provided for @pendingApprovalTab.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApprovalTab;

  /// No description provided for @allAuctionsTab.
  ///
  /// In en, this message translates to:
  /// **'All Auctions'**
  String get allAuctionsTab;

  /// No description provided for @noPendingAuctions.
  ///
  /// In en, this message translates to:
  /// **'No Pending Auctions'**
  String get noPendingAuctions;

  /// No description provided for @allAuctionsReviewed.
  ///
  /// In en, this message translates to:
  /// **'All auctions have been reviewed'**
  String get allAuctionsReviewed;

  /// No description provided for @noAuctions.
  ///
  /// In en, this message translates to:
  /// **'No Auctions'**
  String get noAuctions;

  /// No description provided for @noAuctionsCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'No auctions have been created yet'**
  String get noAuctionsCreatedYet;

  /// No description provided for @startingBid.
  ///
  /// In en, this message translates to:
  /// **'Starting Bid'**
  String get startingBid;

  /// No description provided for @lotNumber.
  ///
  /// In en, this message translates to:
  /// **'Lot #'**
  String get lotNumber;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get statusApproved;

  /// No description provided for @statusLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get statusLive;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'CLOSED'**
  String get statusClosed;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'REJECTED'**
  String get statusRejected;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @auctionApprovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Auction approved successfully'**
  String get auctionApprovedSuccessfully;

  /// No description provided for @auctionRejected.
  ///
  /// In en, this message translates to:
  /// **'Auction rejected'**
  String get auctionRejected;

  /// No description provided for @failedToLoadPendingAuctions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load pending auctions. Please try again.'**
  String get failedToLoadPendingAuctions;

  /// No description provided for @failedToApproveAuction.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve auction. Please try again.'**
  String get failedToApproveAuction;

  /// No description provided for @failedToRejectAuction.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject auction. Please try again.'**
  String get failedToRejectAuction;

  /// No description provided for @manageBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage Bookings'**
  String get manageBookings;

  /// No description provided for @manageAndApproveBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage and approve bookings'**
  String get manageAndApproveBookings;

  /// No description provided for @noPendingBookings.
  ///
  /// In en, this message translates to:
  /// **'No Pending Bookings'**
  String get noPendingBookings;

  /// No description provided for @allBookingsReviewed.
  ///
  /// In en, this message translates to:
  /// **'All bookings have been reviewed'**
  String get allBookingsReviewed;

  /// No description provided for @noBookings.
  ///
  /// In en, this message translates to:
  /// **'No Bookings'**
  String get noBookings;

  /// No description provided for @noBookingsCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings have been created yet'**
  String get noBookingsCreatedYet;

  /// No description provided for @pendingTab.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingTab;

  /// No description provided for @allBookingsTab.
  ///
  /// In en, this message translates to:
  /// **'All Bookings'**
  String get allBookingsTab;

  /// No description provided for @createdLabel.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get createdLabel;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @bookingApprovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Booking approved successfully'**
  String get bookingApprovedSuccessfully;

  /// No description provided for @bookingRejected.
  ///
  /// In en, this message translates to:
  /// **'Booking rejected'**
  String get bookingRejected;

  /// No description provided for @rejectBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Booking'**
  String get rejectBookingTitle;

  /// No description provided for @rejectBookingConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this booking?'**
  String get rejectBookingConfirmMessage;

  /// No description provided for @rejectionReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason *'**
  String get rejectionReasonLabel;

  /// No description provided for @rejectionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Service not available'**
  String get rejectionReasonHint;

  /// No description provided for @additionalNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotesLabel;

  /// No description provided for @additionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Please choose another date'**
  String get additionalNotesHint;

  /// No description provided for @rejectionReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason is required'**
  String get rejectionReasonRequired;

  /// No description provided for @bookingIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingIdLabel;

  /// No description provided for @userLabel.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userLabel;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @vehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;

  /// No description provided for @carLabel.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get carLabel;

  /// No description provided for @modelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get modelLabel;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @descriptionNotes.
  ///
  /// In en, this message translates to:
  /// **'Description/Notes'**
  String get descriptionNotes;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @editFormFields.
  ///
  /// In en, this message translates to:
  /// **'Edit Form Fields'**
  String get editFormFields;

  /// No description provided for @customizeBookingFormFields.
  ///
  /// In en, this message translates to:
  /// **'Customize booking form fields'**
  String get customizeBookingFormFields;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @formFieldsCustomizeInfo.
  ///
  /// In en, this message translates to:
  /// **'Customize the booking form fields. Users will see these fields when creating a booking.'**
  String get formFieldsCustomizeInfo;

  /// No description provided for @addNewField.
  ///
  /// In en, this message translates to:
  /// **'Add New Field'**
  String get addNewField;

  /// No description provided for @noFieldsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No fields added yet'**
  String get noFieldsAddedYet;

  /// No description provided for @tapAddNewFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add New Field\" to create your first field'**
  String get tapAddNewFieldHint;

  /// No description provided for @formFieldsUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Form fields updated successfully'**
  String get formFieldsUpdatedSuccess;

  /// No description provided for @fieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Field Label'**
  String get fieldLabel;

  /// No description provided for @enterFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter field label'**
  String get enterFieldLabel;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Field Type'**
  String get fieldType;

  /// No description provided for @placeholderOptional.
  ///
  /// In en, this message translates to:
  /// **'Placeholder (Optional)'**
  String get placeholderOptional;

  /// No description provided for @enterPlaceholderText.
  ///
  /// In en, this message translates to:
  /// **'Enter placeholder text'**
  String get enterPlaceholderText;

  /// No description provided for @optionsCommaSeparated.
  ///
  /// In en, this message translates to:
  /// **'Options (comma-separated)'**
  String get optionsCommaSeparated;

  /// No description provided for @optionsHint.
  ///
  /// In en, this message translates to:
  /// **'Option 1, Option 2, Option 3'**
  String get optionsHint;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required Field'**
  String get requiredField;

  /// No description provided for @usersMustFillThisField.
  ///
  /// In en, this message translates to:
  /// **'Users must fill this field'**
  String get usersMustFillThisField;

  /// No description provided for @newField.
  ///
  /// In en, this message translates to:
  /// **'New Field'**
  String get newField;

  /// No description provided for @fieldTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get fieldTypeText;

  /// No description provided for @fieldTypeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get fieldTypeNumber;

  /// No description provided for @fieldTypeDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldTypeDate;

  /// No description provided for @fieldTypeTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get fieldTypeTime;

  /// No description provided for @fieldTypeDropdown.
  ///
  /// In en, this message translates to:
  /// **'Dropdown'**
  String get fieldTypeDropdown;

  /// No description provided for @fieldTypeCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Checkbox'**
  String get fieldTypeCheckbox;

  /// No description provided for @fieldTypeTextarea.
  ///
  /// In en, this message translates to:
  /// **'Textarea'**
  String get fieldTypeTextarea;

  /// No description provided for @soldParts.
  ///
  /// In en, this message translates to:
  /// **'Sold Parts'**
  String get soldParts;

  /// No description provided for @saleRecorded.
  ///
  /// In en, this message translates to:
  /// **'sale recorded'**
  String get saleRecorded;

  /// No description provided for @salesRecorded.
  ///
  /// In en, this message translates to:
  /// **'sales recorded'**
  String get salesRecorded;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get unit;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @soldOn.
  ///
  /// In en, this message translates to:
  /// **'Sold on'**
  String get soldOn;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @noSalesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No Sales Recorded'**
  String get noSalesRecorded;

  /// No description provided for @noPartsSoldYet.
  ///
  /// In en, this message translates to:
  /// **'No parts have been sold yet'**
  String get noPartsSoldYet;

  /// No description provided for @addPart.
  ///
  /// In en, this message translates to:
  /// **'Add Part'**
  String get addPart;

  /// No description provided for @timeMinAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String timeMinAgo(int count);

  /// No description provided for @timeHourAgo.
  ///
  /// In en, this message translates to:
  /// **'1 hour ago'**
  String get timeHourAgo;

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String timeHoursAgo(int count);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String timeDaysAgo(int count);

  /// No description provided for @editPart.
  ///
  /// In en, this message translates to:
  /// **'Edit Part'**
  String get editPart;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @partName.
  ///
  /// In en, this message translates to:
  /// **'Part Name'**
  String get partName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @priceAed.
  ///
  /// In en, this message translates to:
  /// **'Price (AED)'**
  String get priceAed;

  /// No description provided for @stockQuantity.
  ///
  /// In en, this message translates to:
  /// **'Stock Quantity'**
  String get stockQuantity;

  /// No description provided for @pleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillRequiredFields;

  /// No description provided for @partUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Part updated successfully'**
  String get partUpdatedSuccessfully;

  /// No description provided for @partAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Part added successfully'**
  String get partAddedSuccessfully;

  /// No description provided for @deletePartTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Part'**
  String get deletePartTitle;

  /// No description provided for @deletePartConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this part?'**
  String get deletePartConfirmMessage;

  /// No description provided for @partDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Part deleted successfully'**
  String get partDeletedSuccessfully;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @verificationDescription.
  ///
  /// In en, this message translates to:
  /// **'To participate in auctions and purchase parts, please deposit 4,500 AED to verify your account.'**
  String get verificationDescription;

  /// No description provided for @depositAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Deposit Amount'**
  String get depositAmountLabel;

  /// No description provided for @amountCurrency.
  ///
  /// In en, this message translates to:
  /// **'Amount ({currency})'**
  String amountCurrency(String currency);

  /// No description provided for @enterDepositAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter deposit amount'**
  String get enterDepositAmount;

  /// No description provided for @depositWithStripe.
  ///
  /// In en, this message translates to:
  /// **'Deposit with Stripe'**
  String get depositWithStripe;

  /// No description provided for @quickDeposit.
  ///
  /// In en, this message translates to:
  /// **'Quick Deposit'**
  String get quickDeposit;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @withdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal'**
  String get withdrawal;

  /// No description provided for @dateAtTime.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String dateAtTime(String date, String time);

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @depositSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deposit of {amount} AED successful!'**
  String depositSuccess(Object amount);

  /// No description provided for @accountVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Account verified! You can now bid and purchase parts.'**
  String get accountVerifiedMessage;

  /// No description provided for @depositFailed.
  ///
  /// In en, this message translates to:
  /// **'Deposit failed'**
  String get depositFailed;

  /// No description provided for @depositFailedTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Deposit failed. Please try again.'**
  String get depositFailedTryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
