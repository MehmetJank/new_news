import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    this.icon,
    this.assetIcon,
    this.press,
    this.onChanged,
    this.isSwitched,
  }) : super(key: key);

  final String text;
  final String? assetIcon;
  final IconData? icon;
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        onPressed: press,
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                weight: 22,
                color: Theme.of(context).iconTheme.color,
              )
            else if (assetIcon != null)
              SvgPicture.asset(
                assetIcon!,
                width: 22,
                color: Theme.of(context).iconTheme.color,
              ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
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
                color: Colors.black26,
              ),
          ],
        ),
      ),
    );
  }
}
