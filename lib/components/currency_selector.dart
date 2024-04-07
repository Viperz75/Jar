import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencySelectorDialog extends StatefulWidget {
  @override
  _CurrencySelectorDialogState createState() => _CurrencySelectorDialogState();
}

class _CurrencySelectorDialogState extends State<CurrencySelectorDialog> {
  String? _selectedCurrency;
  List<String> currencies = [
    "Afghan afghani",
    "Albanian lek",
    "Algerian dinar",
    "Angolan kwanza",
    "Argentine peso",
    "Armenian dram",
    "Aruban florin",
    "Australian dollar",
    "Azerbaijani manat",
    "Bahamian dollar",
    "Bahraini dinar",
    "Bangladeshi taka",
    "Barbadian dollar",
    "Belarusian ruble",
    "Belize dollar",
    "Bermudian dollar",
    "Bhutanese ngultrum",
    "Bolivian boliviano",
    "Bosnia and Herzegovina convertible mark",
    "Botswana pula",
    "Brazilian real",
    "British pound",
    "Brunei dollar",
    "Bulgarian lev",
    "Burundian franc",
    "Cambodian riel",
    "Central African CFA franc",
    "Cape Verdean escudo",
    "Cayman Islands dollar",
    "Chilean peso",
    "Chinese yuan",
    "Colombian peso",
    "Comorian franc",
    "Congolese franc",
    "Costa Rican colón",
    "Croatian kuna",
    "Cuban peso",
    "Czech koruna",
    "Danish krone",
    "Djiboutian franc",
    "Dominican peso",
    "East Caribbean dollar",
    "Egyptian pound",
    "Eritrean nakfa",
    "Ethiopian birr",
    "Euro",
    "Falkland Islands pound",
    "Fijian dollar",
    "Gambian dalasi",
    "Georgian lari",
    "Ghanaian cedi",
    "Gibraltar pound",
    "Guatemalan quetzal",
    "Guinean franc",
    "Guyanese dollar",
    "Haitian gourde",
    "Honduran lempira",
    "Hong Kong dollar",
    "Hungarian forint",
    "Icelandic króna",
    "Indian rupee",
    "Indonesian rupiah",
    "Iranian rial",
    "Iraqi dinar",
    "Israeli new shekel",
    "Jamaican dollar",
    "Japanese yen",
    "Jordanian dinar",
    "Kazakhstani tenge",
    "Kenyan shilling",
    "Kuwaiti dinar",
    "Kyrgyzstani som",
    "Lao kip",
    "Lebanese pound",
    "Lesotho loti",
    "Liberian dollar",
    "Libyan dinar",
    "Macanese pataca",
    "Malagasy ariary",
    "Malawian kwacha",
    "Malaysian ringgit",
    "Maldivian rufiyaa",
    "Mauritanian ouguiya",
    "Mauritian rupee",
    "Mexican peso",
    "Moldovan leu",
    "Mongolian tögrög",
    "Moroccan dirham",
    "Mozambican metical",
    "Myanmar kyat",
    "Namibian dollar",
    "Nepalese rupee",
    "Netherlands Antillean guilder",
    "New Zealand dollar",
    "Nicaraguan córdoba",
    "Nigerian naira",
    "North Korean won",
    "Norwegian krone",
    "Omani rial",
    "Pakistani rupee",
    "Panamanian balboa",
    "Papua New Guinean kina",
    "Paraguayan guaraní",
    "Peruvian sol",
    "Philippine peso",
    "Polish złoty",
    "Qatari riyal",
    "Romanian leu",
    "Russian ruble",
    "Rwandan franc",
    "Saint Helena pound",
    "Salvadoran colón",
    "Samoan tālā",
    "São Tomé and Príncipe dobra",
    "Saudi riyal",
    "Serbian dinar",
    "Seychellois rupee",
    "Sierra Leonean leone",
    "Singapore dollar",
    "Solomon Islands dollar",
    "Somali shilling",
    "South African rand",
    "South Korean won",
    "South Sudanese pound",
    "Sri Lankan rupee",
    "Sudanese pound",
    "Surinamese dollar",
    "Swazi lilangeni",
    "Swedish krona",
    "Swiss franc",
    "Syrian pound",
    "Tajikistani somoni",
    "Tanzanian shilling",
    "Thai baht",
    "Tongan paʻanga",
    "Trinidad and Tobago dollar",
    "Tunisian dinar",
    "Turkish lira",
    "Turkmenistan manat",
    "Tuvaluan dollar",
    "Ugandan shilling",
    "Ukrainian hryvnia",
    "United Arab Emirates dirham",
    "United States dollar",
    "Uruguayan peso",
    "Uzbekistani soʻm",
    "Vanuatu vatu",
    "Venezuelan bolívar",
    "Vietnamese đồng",
    "Yemeni rial",
    "Zambian kwacha",
    "Zimbabwean dollar"
  ];
  // Add more currencies if needed

  @override
  void initState() {
    super.initState();
    loadSelectedCurrency();
  }

  Future<void> loadSelectedCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedCurrency = prefs.getString('selectedCurrency');
    });
  }

  Future<void> saveSelectedCurrency(String? currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCurrency', currency!);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Currency'),
      content: SingleChildScrollView(
        child: Column(
          children: currencies.map((currency) {
            return RadioListTile<String>(
              title: Text(currency),
              value: currency,
              groupValue: _selectedCurrency,
              onChanged: (String? value) {
                setState(() {
                  _selectedCurrency = value;
                });
                saveSelectedCurrency(value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
