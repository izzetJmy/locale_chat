abstract class LocaleKeys {
  // Login Register
  static const String loginRegisterWelcome = 'login_register.welcome';
  static const String loginRegisterLogin = 'login_register.login';
  static const String loginRegisterRegister = 'login_register.register';
  static const String loginRegisterEmail = 'login_register.email';
  static const String loginRegisterPassword = 'login_register.password';
  static const String loginRegisterConfirmPassword =
      'login_register.confirm_password';
  static const String loginRegisterEnterValidEmail =
      'login_register.enter_valid_email';
  static const String loginRegisterEnterPassword =
      'login_register.enter_password';
  static const String loginRegisterEnter6DigitPassword =
      'login_register.enter_6_digit_password';
  static const String loginRegisterPasswordsMustMatch =
      'login_register.passwords_must_match';
  static const String loginRegisterEmailRequired =
      'login_register.email_required';
  static const String loginRegisterEnterValidEmailAddress =
      'login_register.enter_valid_email_address';
  static const String loginRegisterDontHaveAccount =
      'login_register.dont_have_account';
  static const String loginRegisterSignUp = 'login_register.sign_up';
  static const String loginRegisterOr = 'login_register.or';
  static const String loginRegisterForgotPassword =
      'login_register.forgot_password';
  static const String loginRegisterAlreadyHaveAccount =
      'login_register.already_have_account';
  static const String loginRegisterSignIn = 'login_register.sign_in';
  // Forgot Password
  static const String forgotPasswordEnterEmailForReset =
      'forgot_password.enter_email_for_reset';
  static const String forgotPasswordSendCode = 'forgot_password.send_code';
  static const String forgotPasswordVerify = 'forgot_password.verify';

  // Reset Password
  static const String resetPasswordEnterNewPassword =
      'reset_password.enter_new_password';
  static const String resetPasswordNewPassword = 'reset_password.new_password';
  static const String resetPasswordUpdate = 'reset_password.update';
  static const String resetPasswordCheckEmail = 'reset_password.check_email';
  static const String resetPasswordBackToLogin = 'reset_password.back_to_login';
  static const String resetPasswordLinkSent = 'reset_password.link_sent';
  // Email Verification
  static const String emailVerificationCheckEmail =
      'email_verification.check_email';
  static const String emailVerificationEmailSent =
      'email_verification.email_sent';
  static const String emailVerificationBack = 'email_verification.back';
  static const String emailVerificationResend = 'email_verification.resend';
  static const String emailVerificationEmail = 'email_verification.email';
  static const String emailVerificationSendCode =
      'email_verification.send_code';
  // Onboarding
  static const String onboardingContinue = 'onboarding.continue';
  static const String onboardingNext = 'onboarding.next';
  static const String onboardingDone = 'onboarding.done';

  // Chat
  static const String chatTypeMessage = 'chat.type_message';
  static const String chatNoMessages = 'chat.no_messages';
  static const String chatSingleChat = 'chat.single_chat';
  static const String chatGroupChat = 'chat.group_chat';
  static const String chatMessageSent = 'chat.message_sent';
  static const String chatMessageError = 'chat.message_error';
  static const String chatNewChat = 'chat.new_chat';
  static const String chatDetails = 'chat.chat_details';
  static const String chatImages = 'chat.images';
  // Image Picker
  static const String imagePickerGallery = 'image_picker.gallery';
  static const String imagePickerCamera = 'image_picker.camera';
  static const String imagePickerImageUploaded = 'image_picker.image_uploaded';
  static const String imagePickerUploadError = 'image_picker.upload_error';
  static const String imagePickerSendImage = 'image_picker.send_image';
  static const String imagePickerSelectFromGallery =
      'image_picker.select_from_gallery';
  static const String imagePickerTakePhoto = 'image_picker.take_photo';
  static const String imagePickerImageNotSelected =
      'image_picker.image_not_selected';
  static const String imagePickerErrorPickingImage =
      'image_picker.error_picking_image';

  // Group
  static const String groupAddMember = 'group.add_member';
  static const String groupRemoveMember = 'group.remove_member';
  static const String groupRemoveMemberConfirmation =
      'group.remove_member_confirmation';
  static const String groupDeleteGroup = 'group.delete_group';
  static const String groupDeleteGroupConfirmation =
      'group.delete_group_confirmation';
  static const String groupCancel = 'group.cancel';
  static const String groupDelete = 'group.delete';
  static const String groupAdminCannotBeRemoved =
      'group.admin_cannot_be_removed';
  static const String groupGroupDetails = 'group.group_details';
  static const String groupMembers = 'group.members';
  static const String groupImages = 'group.images';
  static const String groupAdmin = 'group.admin';
  static const String groupAdd = 'group.add';
  static const String groupSelectGroupImage = 'group.select_group_image';
  static const String groupName = 'group.name';
  static const String groupChange = 'group.change';
  static const String groupCreateGroup = 'group.create_group';
  static const String groupGroupName = 'group.group_name';
  static const String groupCreate = 'group.create';

  // Navigation
  static const String navigationChat = 'navigation.chat';
  static const String navigationGroup = 'navigation.group';
  static const String navigationList = 'navigation.list';
  static const String navigationMap = 'navigation.map';

  // Map
  static const String mapCurrentLocation = 'map.current_location';

  // Profile
  static const String profilePageTitle = 'profile.profile_page_title';
  static const String profileEditProfile = 'profile.edit_profile';
  static const String profileSettings = 'profile.settings';
  static const String profileLogout = 'profile.logout';
  static const String profileChangePhoto = 'profile.change_photo';
  static const String profileChangeName = 'profile.change_name';
  static const String profileChangeEmail = 'profile.change_email';
  static const String profileChangePassword = 'profile.change_password';
  static const String profileDeleteAccount = 'profile.delete_account';
  static const String profileDeleteAccountConfirmation =
      'profile.delete_account_confirmation';
  static const String profileDarkMode = 'profile.dark_mode';
  static const String profileLanguages = 'profile.languages';
  static const String profileSelectProfileImage =
      'profile.select_profile_image';

  // Time
  static const String timeGoodMorning = 'time.good_morning';
  static const String timeGoodAfternoon = 'time.good_afternoon';
  static const String timeGoodEvening = 'time.good_evening';
  static const String timeGoodNight = 'time.good_night';
  // Errors - Auth
  static const String errorsAuthUserNotFound = 'errors.auth.user_not_found';
  static const String errorsAuthWrongPassword = 'errors.auth.wrong_password';
  static const String errorsAuthEmailAlreadyInUse =
      'errors.auth.email_already_in_use';
  static const String errorsAuthWeakPassword = 'errors.auth.weak_password';
  static const String errorsAuthInvalidEmail = 'errors.auth.invalid_email';
  static const String errorsAuthEmailVerified = 'errors.auth.email_verified';
  static const String errorsAuthPleaseCheckYourEmail =
      'errors.auth.please_check_your_email';
  static const String errorsAuthWeHaveSentYouAnEmailOn =
      'errors.auth.we_have_sent_you_an_email_on';
  static const String errorsAuthEmailRequired = 'errors.auth.email_required';
  static const String errorsAuthEnterAFValidEmailAddress =
      'errors.auth.enter_a_valid_email_address';
  static const String errorsAuthOtpHasBeenSent =
      'errors.auth.otp_has_been_sent';
  static const String errorsAuthFailedToSendOtp =
      'errors.auth.failed_to_send_otp';
  static const String errorsAuthGoogleLoginSuccess =
      'errors.auth.google_login_success';
  static const String errorsAuthGoogleLoginError =
      'errors.auth.google_login_error';
  static const String errorsAuthLoginSuccess = 'errors.auth.login_success';
  static const String errorsAuthPleaseVerifyYourEmail =
      'errors.auth.please_verify_your_email';
  static const String errorsAuthRegisterSuccess =
      'errors.auth.register_success';
  static const String errorsAuthPasswordChangedToSuccessful =
      'errors.auth.password_changed_to_successful';
  static const String errorsAuthOtpIsVerified = 'errors.auth.otp_is_verified';
  static const String errorsAuthInvalidOtp = 'errors.auth.invalid_otp';
  // Errors - Profile
  static const String errorsProfileErrorUpdatingUsername =
      'errors.profile.error_updating_username';
  static const String errorsProfileErrorUpdatingPassword =
      'errors.profile.error_updating_password';
  static const String errorsProfileUpdateSuccess =
      'errors.profile.update_success';
  static const String errorsProfileSuccessUpdatingUsername =
      'errors.profile.success_updating_username';

  // Errors - Search
  static const String errorsSearchNoOneToChat = 'errors.search.no_one_to_chat';
  static const String errorsSearchSearchForPeople =
      'errors.search.search_for_people';
  static const String errorsSearchNoDataAvailable =
      'errors.search.no_data_available';

  // Errors - Location
  static const String errorsLocationPermissionNotGranted =
      'errors.location.location_permission_not_granted';
  static const String errorsLocationPermissionGranted =
      'errors.location.location_permission_granted';
  static const String errorsLocationPermissionDenied =
      'errors.location.location_permission_denied';

  // Errors - Group
  static const String errorsGroupNoUsersFound = 'errors.group.no_users_found';
  static const String errorsGroupNoAvailableUsersToAdd =
      'errors.group.no_available_users_to_add';
  static const String errorsGroupYouCannotChatWithYourself =
      'errors.group.you_cannot_chat_with_yourself';
  static const String errorsGroupNoImagesUploaded =
      'errors.group.no_images_uploaded';
  static const String errorsGroupGroupImageUploaded =
      'errors.group.group_image_uploaded';
  static const String errorsGroupGroupImageUploadError =
      'errors.group.group_image_upload_error';
  static const String errorsGroupPleaseEnterAUsername =
      'errors.group.please_enter_a_username';
  static const String errorsGroupUpdatedSuccessfully =
      'errors.group.updated_successfully';
  static const String errorsGroupErrorUpdatingUsername =
      'errors.group.error_updating_username';
  static const String errorsGroupPleaseEnterAGroupName =
      'errors.group.please_enter_a_group_name';
  static const String errorsGroupPleaseSelectAGroupImage =
      'errors.group.please_select_a_group_image';
  static const String errorsGroupPleaseSelectAtLeastOneMember =
      'errors.group.please_select_at_least_one_member';
  static const String errorsGroupErrorCreatingGroup =
      'errors.group.error_creating_group';

  // Errors - Chat
  static const String errorsChatNoImagesUploaded =
      'errors.chat.no_images_uploaded';

  static String noInternetConnection = 'noInternetConnection';
  static String retry = 'retry';
  static String exit = 'exit';
}
