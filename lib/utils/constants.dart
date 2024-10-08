import 'my_material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;

const langCodeDefault = 'fr';
const supportedLanguages = ['en', 'fr'];

const prefCurrentUser = 'current_user';

/// PAGES
const pageHome = '/home';
const pageNotification = '/notification';
const pageSignIn = '/sign_in';
const pageSetPlace = '/set_place';
const pageImageViewer = '/image_viewer';
const pageNewsDetails = '/news_details';
const pageSetNews = '/set_news';

const fieldStatusCode = 'status_code';

/// SHARED PREFERENCES
const prefSettings = 'settings';

/// PAGES ARGUMENTS
const argumentId = 'id';
const argumentIsNOAnimation = 'is_no_animation';
const argumentMessage = 'message';
const argumentEdit = 'edit';
const argumentImageProvider = 'image_provider';
const argumentPlace = 'place';
const argumentNews = 'news';
const argumentOnDeleted = 'on_deleted';
const argumentDocumentId = 'document_id';

/// SETTINGS FIELD
const settingIsDarkMode = 'is_dark_mode';
const settingLanguage = 'language';
const settingIsFirstUse = 'is_first_use';

/// COLORS
const int colorHex = 0XFF008080;

const Color colorPrimary = Color(colorHex);
const Color colorSecondary = Color(0XFF79B867);
const Color colorThird = Color(0XFF87CEEB);
const Color colorBlack = Color(0XFF130B07);
const Color colorWhite = Color(0XFFFFFFFF);
const Color colorError = Color(0XFF969696);

/// PADDING
const paddingSmall = 6.0;
const paddingSMedium = 8.0;
const paddingMedium = 11.0;
const paddingLargeMedium = 14.0;
const paddingNormal = 18.0;
const paddingLarge = 24.0;
const paddingXLarge = 31.0;
const paddingXXLarge = 41.0;
const paddingXXXLarge = 53.0;

/// FONTS SIZE
const textSizeSmall = 12.0;
const textSizeSMedium = 14.0;
const textSizeMedium = 17.0;
const textSizeLargeMedium = 20.0;
const textSizeNormal = 24.0;
const textSizeLarge = 30.0;
const textSizeXLarge = 35.0;
const textSizeXXLarge = 45.0;
const textSizeXXXLarge = 52.0;

/// NOTIFICATIONS
const fieldNotificationMessage = 'message';
const fieldNotificationGlobalTopic = 'global';

/// FUNCTIONS
const functionSendNotification = 'sendNotification';

const defaultMapPosition = map.LatLng(-11.6753304, 27.4197895);

const downloadAppLink = '[Lien de téléchargement de l\'application]';

const maxDistanceUpdatePlace = 200; // meters

/// firebase storage files reference
const storageRefPlaces = 'places';
const storageRefNews = 'news';

const itemsPerPage = 10;
