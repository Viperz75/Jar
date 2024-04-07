import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyNotifier extends ChangeNotifier {
  String _selectedCurrency = '';

  String get selectedCurrency => _selectedCurrency;

  Future<void> loadSelectedCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedCurrency = prefs.getString('selectedCurrency') ?? '';
    notifyListeners();
  }

  Future<void> saveSelectedCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _selectedCurrency = currency;
    await prefs.setString('selectedCurrency', currency);
    notifyListeners();
  }
}

class CurrencyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currencyNotifier = Provider.of<CurrencyNotifier>(context);
    currencyNotifier.loadSelectedCurrency(); // Load selected currency

    String currencySymbol = ''; // Define currency symbol here
    // switch (currencyNotifier.selectedCurrency) {
    //   case 'Bangladeshi taka':
    //     currencySymbol = '৳';
    //     break;
    //   case 'Indian Rupees':
    //     currencySymbol = '₹';
    //     break;
    //   case 'US Dollars':
    //     currencySymbol = '\$';
    //     break;
    //   case 'UK pound':
    //     currencySymbol = '£';
    //     break;
    //   default:
    //     currencySymbol = ''; // Handle default case
    // }
    switch (currencyNotifier.selectedCurrency) {
      case 'Afghan afghani':
        currencySymbol = '؋';
        break;
      case 'Albanian lek':
        currencySymbol = 'L';
        break;
      case 'Algerian dinar':
        currencySymbol = 'د.ج';
        break;
      case 'Angolan kwanza':
        currencySymbol = 'Kz';
        break;
      case 'Argentine peso':
        currencySymbol = '\$';
        break;
      case 'Armenian dram':
        currencySymbol = '֏';
        break;
      case 'Aruban florin':
        currencySymbol = 'Afl.';
        break;
      case 'Australian dollar':
        currencySymbol = '\$';
        break;
      case 'Azerbaijani manat':
        currencySymbol = '₼';
        break;
      case 'Bahamian dollar':
        currencySymbol = '\$';
        break;
      case 'Bahraini dinar':
        currencySymbol = 'BD;';
        break;
      case 'Bangladeshi taka':
        currencySymbol = '৳';
        break;
      case 'Barbadian dollar':
        currencySymbol = '\$';
        break;
      case 'Belarusian ruble':
        currencySymbol = 'Br';
        break;
      case 'Belize dollar':
        currencySymbol = 'BZ\$';
        break;
      case 'Bermudian dollar':
        currencySymbol = '\$';
        break;
      case 'Bhutanese ngultrum':
        currencySymbol = 'Nu.';
        break;
      case 'Bolivian boliviano':
        currencySymbol = 'Bs.';
        break;
      case 'Bosnia and Herzegovina convertible mark':
        currencySymbol = 'KM';
        break;
      case 'Botswana pula':
        currencySymbol = 'P';
        break;
      case 'Brazilian real':
        currencySymbol = 'R\$';
        break;
      case 'British pound':
        currencySymbol = '£';
        break;
      case 'Brunei dollar':
        currencySymbol = '\$';
        break;
      case 'Bulgarian lev':
        currencySymbol = 'лв.';
        break;
      case 'Burundian franc':
        currencySymbol = 'FBu';
        break;
      case 'Cambodian riel':
        currencySymbol = '៛';
        break;
      case 'Central African CFA franc':
        currencySymbol = 'FCFA';
        break;
      case 'Cape Verdean escudo':
        currencySymbol = 'CVE\$';
        break;
      case 'Cayman Islands dollar':
        currencySymbol = '\$';
        break;
      case 'Chilean peso':
        currencySymbol = '\$';
        break;
      case 'Chinese yuan':
        currencySymbol = '¥';
        break;
      case 'Colombian peso':
        currencySymbol = '\$';
        break;
      case 'Comorian franc':
        currencySymbol = 'CF';
        break;
      case 'Congolese franc':
        currencySymbol = 'FC';
        break;
      case 'Costa Rican colón':
        currencySymbol = '₡';
        break;
      case 'Croatian kuna':
        currencySymbol = 'kn';
        break;
      case 'Cuban peso':
        currencySymbol = '\$';
        break;
      case 'Czech koruna':
        currencySymbol = 'Kč';
        break;
      case 'Danish krone':
        currencySymbol = 'kr';
        break;
      case 'Djiboutian franc':
        currencySymbol = 'Fdj';
        break;
      case 'Dominican peso':
        currencySymbol = 'RD\$';
        break;
      case 'East Caribbean dollar':
        currencySymbol = '\$';
        break;
      case 'Egyptian pound':
        currencySymbol = 'E£';
        break;
      case 'Eritrean nakfa':
        currencySymbol = 'Nfk';
        break;
      case 'Ethiopian birr':
        currencySymbol = 'Br';
        break;
      case 'Euro':
        currencySymbol = '€';
        break;
      case 'Falkland Islands pound':
        currencySymbol = '£';
        break;
      case 'Fijian dollar':
        currencySymbol = '\$';
        break;
      case 'Gambian dalasi':
        currencySymbol = 'D';
        break;
      case 'Georgian lari':
        currencySymbol = '₾';
        break;
      case 'Ghanaian cedi':
        currencySymbol = 'GH₵';
        break;
      case 'Gibraltar pound':
        currencySymbol = '£';
        break;
      case 'Guatemalan quetzal':
        currencySymbol = 'Q';
        break;
      case 'Guinean franc':
        currencySymbol = 'FG';
        break;
      case 'Guyanese dollar':
        currencySymbol = '\$';
        break;
      case 'Haitian gourde':
        currencySymbol = 'G';
        break;
      case 'Honduran lempira':
        currencySymbol = 'L';
        break;
      case 'Hong Kong dollar':
        currencySymbol = '\$';
        break;
      case 'Hungarian forint':
        currencySymbol = 'Ft';
        break;
      case 'Icelandic króna':
        currencySymbol = 'kr';
        break;
      case 'Indian rupee':
        currencySymbol = '₹';
        break;
      case 'Indonesian rupiah':
        currencySymbol = 'Rp';
        break;
      case 'Iranian rial':
        currencySymbol = '﷼';
        break;
      case 'Iraqi dinar':
        currencySymbol = 'ع.د';
        break;
      case 'Israeli new shekel':
        currencySymbol = '₪';
        break;
      case 'Jamaican dollar':
        currencySymbol = 'J\$';
        break;
      case 'Japanese yen':
        currencySymbol = '¥';
        break;
      case 'Jordanian dinar':
        currencySymbol = 'JD';
        break;
      case 'Kazakhstani tenge':
        currencySymbol = '₸';
        break;
      case 'Kenyan shilling':
        currencySymbol = 'KSh';
        break;
      case 'Kuwaiti dinar':
        currencySymbol = 'KD';
        break;
      case 'Kyrgyzstani som':
        currencySymbol = 'с';
        break;
      case 'Lao kip':
        currencySymbol = '₭';
        break;
      case 'Lebanese pound':
        currencySymbol = 'LBP';
        break;
      case 'Lesotho loti':
        currencySymbol = 'L';
        break;
      case 'Liberian dollar':
        currencySymbol = '\$';
        break;
      case 'Libyan dinar':
        currencySymbol = 'LD';
        break;
      case 'Macanese pataca':
        currencySymbol = 'MOP\$';
        break;
      case 'Malagasy ariary':
        currencySymbol = 'Ar';
        break;
      case 'Malawian kwacha':
        currencySymbol = 'MK';
        break;
      case 'Malaysian ringgit':
        currencySymbol = 'RM';
        break;
      case 'Maldivian rufiyaa':
        currencySymbol = 'Rf';
        break;
      case 'Mauritanian ouguiya':
        currencySymbol = 'UM';
        break;
      case 'Mauritian rupee':
        currencySymbol = '₨';
        break;
      case 'Mexican peso':
        currencySymbol = '\$';
        break;
      case 'Moldovan leu':
        currencySymbol = 'MDL';
        break;
      case 'Mongolian tögrög':
        currencySymbol = '₮';
        break;
      case 'Moroccan dirham':
        currencySymbol = 'د.م';
        break;
      case 'Mozambican metical':
        currencySymbol = 'MT';
        break;
      case 'Myanmar kyat':
        currencySymbol = 'K';
        break;
      case 'Namibian dollar':
        currencySymbol = '\$';
        break;
      case 'Nepalese rupee':
        currencySymbol = '₨';
        break;
      case 'Netherlands Antillean guilder':
        currencySymbol = 'NAƒ';
        break;
      case 'New Zealand dollar':
        currencySymbol = '\$';
        break;
      case 'Nicaraguan córdoba':
        currencySymbol = 'C\$';
        break;
      case 'Nigerian naira':
        currencySymbol = '₦';
        break;
      case 'North Korean won':
        currencySymbol = '₩';
        break;
      case 'Norwegian krone':
        currencySymbol = 'kr';
        break;
      case 'Omani rial':
        currencySymbol = 'ر.ع.';
        break;
      case 'Pakistani rupee':
        currencySymbol = '₨';
        break;
      case 'Panamanian balboa':
        currencySymbol = 'B/.';
        break;
      case 'Papua New Guinean kina':
        currencySymbol = 'K';
        break;
      case 'Paraguayan guaraní':
        currencySymbol = '₲';
        break;
      case 'Peruvian sol':
        currencySymbol = 'S/.';
        break;
      case 'Philippine peso':
        currencySymbol = '₱';
        break;
      case 'Polish złoty':
        currencySymbol = 'zł';
        break;
      case 'Qatari riyal':
        currencySymbol = 'QR';
        break;
      case 'Romanian leu':
        currencySymbol = 'RON';
        break;
      case 'Russian ruble':
        currencySymbol = '₽';
        break;
      case 'Rwandan franc':
        currencySymbol = 'RF';
        break;
      case 'Saint Helena pound':
        currencySymbol = '£';
        break;
      case 'Salvadoran colón':
        currencySymbol = '₡';
        break;
      case 'Samoan tālā':
        currencySymbol = '\$';
        break;
      case 'São Tomé and Príncipe dobra':
        currencySymbol = 'Db';
        break;
      case 'Saudi riyal':
        currencySymbol = 'SR';
        break;
      case 'Serbian dinar':
        currencySymbol = 'дин.';
        break;
      case 'Seychellois rupee':
        currencySymbol = '₨';
        break;
      case 'Sierra Leonean leone':
        currencySymbol = 'Le';
        break;
      case 'Singapore dollar':
        currencySymbol = '\$';
        break;
      case 'Solomon Islands dollar':
        currencySymbol = '\$';
        break;
      case 'Somali shilling':
        currencySymbol = 'Sh';
        break;
      case 'South African rand':
        currencySymbol = 'R';
        break;
      case 'South Korean won':
        currencySymbol = '₩';
        break;
      case 'South Sudanese pound':
        currencySymbol = '£';
        break;
      case 'Sri Lankan rupee':
        currencySymbol = 'Rs';
        break;
      case 'Sudanese pound':
        currencySymbol = 'SDG';
        break;
      case 'Surinamese dollar':
        currencySymbol = '\$';
        break;
      case 'Swazi lilangeni':
        currencySymbol = 'L';
        break;
      case 'Swedish krona':
        currencySymbol = 'kr';
        break;
      case 'Swiss franc':
        currencySymbol = 'Fr';
        break;
      case 'Syrian pound':
        currencySymbol = '£';
        break;
      case 'Tajikistani somoni':
        currencySymbol = 'TJS';
        break;
      case 'Tanzanian shilling':
        currencySymbol = 'TSh';
        break;
      case 'Thai baht':
        currencySymbol = '฿';
        break;
      case 'Tongan paʻanga':
        currencySymbol = 'T\$';
        break;
      case 'Trinidad and Tobago dollar':
        currencySymbol = 'TT\$';
        break;
      case 'Tunisian dinar':
        currencySymbol = 'د.ت';
        break;
      case 'Turkish lira':
        currencySymbol = '₺';
        break;
      case 'Turkmenistan manat':
        currencySymbol = 'T';
        break;
      case 'Tuvaluan dollar':
        currencySymbol = '\$';
        break;
      case 'Ugandan shilling':
        currencySymbol = 'UGX';
        break;
      case 'Ukrainian hryvnia':
        currencySymbol = '₴';
        break;
      case 'United Arab Emirates dirham':
        currencySymbol = 'د.إ';
        break;
      case 'United States dollar':
        currencySymbol = '\$';
        break;
      case 'Uruguayan peso':
        currencySymbol = '\$';
        break;
      case 'Uzbekistani soʻm':
        currencySymbol = 'so\'m';
        break;
      case 'Vanuatu vatu':
        currencySymbol = 'VT';
        break;
      case 'Venezuelan bolívar':
        currencySymbol = 'Bs.S';
        break;
      case 'Vietnamese đồng':
        currencySymbol = '₫';
        break;
      case 'Yemeni rial':
        currencySymbol = '﷼';
        break;
      case 'Zambian kwacha':
        currencySymbol = 'ZK';
        break;
      case 'Zimbabwean dollar':
        currencySymbol = 'Z\$';
        break;
      default:
        currencySymbol = ''; // Handle default case
    }


    return Text('$currencySymbol');
  }
}
