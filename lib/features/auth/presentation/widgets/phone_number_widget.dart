import 'package:doctor/core/classes/icon_classes.dart';
import 'package:doctor/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/country.dart';

class PhoneNumberInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String initialCountryCode;
  final String initialCountry;
  final String initialPhoneNumber;
  final String hintText;
  final TextStyle? textStyle;
  final InputDecoration? decoration;
  final bool showFlag;
  final bool showPhoneIcon;
  final bool showIconDown;
  final bool showCountryCode;

  const PhoneNumberInput({
    Key? key,
    this.onChanged,
    this.initialCountryCode = '+966',
    this.initialCountry = '',
    this.initialPhoneNumber = '',
    this.hintText = '+966 5656 5656 665',
    this.textStyle,
    this.decoration,
    this.showFlag = true,
    this.showPhoneIcon = true,
    this.showIconDown = true,
    this.showCountryCode = true,
  }) : super(key: key);

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  late TextEditingController _phoneController;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.initialPhoneNumber);
    _selectedCountry = CountryPickerUtils.getCountryByPhoneCode(
      widget.initialCountryCode.replaceAll('+', ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420, // 👈 desktop width limit only
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.darkblue),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Country code picker
              GestureDetector(
                onTap: _openCountryPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.showFlag)
                        CountryPickerUtils.getDefaultFlagImage(
                          _selectedCountry,
                        ),
                      SizedBox(width: widget.showFlag ? 8 : 0),
                      if (widget.showCountryCode)
                        Text(
                          '+${_selectedCountry.phoneCode}',
                          style:
                              widget.textStyle ??
                              const TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 16,
                              ),
                        ),
                      if (widget.showIconDown) ...[
                        const SizedBox(width: 8),
                        IconDown.chevronDown,
                      ],
                      if (widget.showPhoneIcon) const SizedBox(width: 8),
                      if (widget.showPhoneIcon) IconePhone.phone,
                    ],
                  ),
                ),
              ),

              // Phone number input
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    cursorColor: AppColor.darkblue,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: widget.textStyle,
                    decoration:
                        widget.decoration ??
                        InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: const TextStyle(
                            fontFamily: 'Serif',
                            color: Color(0xffA3A3A3),
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                        ),
                    onChanged: (value) => _notifyParent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCountryPicker() {
    showDialog(
      context: context,
      builder:
          (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: AppColor.darkblue),
            child: CountryPickerDialog(
              titlePadding: const EdgeInsets.all(8.0),
              searchCursorColor: AppColor.darkblue,
              searchInputDecoration: const InputDecoration(
                hintText: 'Search...',
              ),
              isSearchable: true,
              title: const Text(
                'Select your phone code',
                style: TextStyle(fontFamily: 'Serif'),
              ),
              onValuePicked: (Country country) {
                setState(() {
                  _selectedCountry = country;
                  _notifyParent();
                });
              },
            ),
          ),
    );
  }

  void _notifyParent() {
    if (widget.onChanged != null) {
      widget.onChanged!(
        '+${_selectedCountry.phoneCode}${_phoneController.text}',
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
