import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingMenu extends StatelessWidget {
  const SettingMenu({
    Key? key,
    required this.text,
    this.assetIcon,
    this.press,
    this.onChanged,
    this.isSwitched,
  }) : super(key: key);

  final String text;
  final String? assetIcon;
  final VoidCallback? press;
  final bool? isSwitched;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              assetIcon!,
              width: 22,
              height: 22,
              // ignore: deprecated_member_use
              color: Colors.white,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            if (onChanged != null)
              SizedBox(
                height: 22,
                child: Switch(
                  value: isSwitched!,
                  onChanged: onChanged,
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}
