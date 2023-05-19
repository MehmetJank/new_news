// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class ProfileMenu extends StatelessWidget {
//   const ProfileMenu({
//     Key? key,
//     required this.title,
//     required this.icon,
//     required this.info,
//   }) : super(key: key);

//   final String title, icon, info;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         children: [
//           Row(
//             children: [
//               SvgPicture.asset(
//                 icon,
//                 width: 22,
//               ),
//               const SizedBox(width: 20),
//               Expanded(child: Text(title)),
//             ],
//           ),
//           Expanded(child: Text(info)),
//         ],
//       ),
//     );
//   }
// }
