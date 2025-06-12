import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

class PhoneNumberField extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final TextEditingController phoneController;

  const PhoneNumberField({
    Key? key,
    required this.onCountryChanged,
    required this.phoneController,
  }) : super(key: key);

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  Country _selectedCountry = CountryPickerUtils.getCountryByPhoneCode('51'); 

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildCountryDropdown(),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Número telefónico',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return CountryPickerDropdown(
      initialValue: _selectedCountry.isoCode,
      itemBuilder: _buildDropdownItem,
      onValuePicked: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
        widget.onCountryChanged(country.phoneCode);
      },
    );
  }

  Widget _buildDropdownItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8),
        Text("+${country.phoneCode}"),
      ],
    );
  }
}