// import 'package:flutter/material.dart';
// import 'package:myprojects/pages/WithdrawalRequestPage.dart';
//
// import 'CommisionPayoutPage.dart';
// import 'DashboardPage.dart';
// import 'ManageAgentsPage.dart';
// import 'ManageBranches.dart';
// import 'TotalRevenuePage.dart';
// import 'TotalVenturesPage.dart';
//
// class Referrelpage extends StatelessWidget {
//   const Referrelpage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: ReferrelpageBody());
//   }
// }
//
// class ReferrelpageBody extends StatefulWidget {
//   const ReferrelpageBody({super.key});
//
//   @override
//   State<ReferrelpageBody> createState() => _ReferrelpageBodyState();
// }
//
// class _ReferrelpageBodyState extends State<ReferrelpageBody> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 30.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   icon: const Icon(
//                     Icons.close,
//                     color: Colors.black54,
//                     size: 18,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context); // Close drawer
//                   },
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
//               child: Row(
//                 children: [
//                   Icon(Icons.menu, color: Colors.green),
//                   SizedBox(width: 15),
//                   Text(
//                     "Sri Vayutej \nDevelopers",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView(
//                 children: [
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const Dashboardpage(),
//                         ),
//                       );
//                     },
//                     imagePath: "lib/icons/home.png",
//                     title: "Dashboard",
//                   ),
//
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ManageAgentPage(),
//                         ),
//                       );
//                     },
//                     icon: Icons.people_outlined,
//                     title: "Agents",
//                   ),
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const TotalVenturesPage(),
//                         ),
//                       );
//                     },
//                     imagePath: "lib/icons/bag.png",
//                     title: "Ventures",
//                   ),
//
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ManageBranchesPage(),
//                         ),
//                       );
//                     },
//                     imagePath: "lib/icons/git.png",
//                     title: "Branches",
//                   ),
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const TotalRevenuePage(),
//                         ),
//                       );
//                     },
//                     icon: Icons.account_balance_wallet_outlined,
//                     title: "Investments",
//                   ),
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CommisionPayoutPage(),
//                         ),
//                       );
//                     },
//                     imagePath: "lib/icons/coins.png",
//                     title: "Payouts",
//                   ),
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => const TotalRevenuePage(),
//                       //   ),
//                       // );
//                     },
//                     imagePath: "lib/icons/decision-tree.png",
//                     title: "Referral Tree",
//                   ),
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const Withdrawalrequestpage(),
//                         ),
//                       );
//                     },
//                     imagePath: "lib/icons/coins.png",
//                     title: "Withdrawals",
//                   ),
//                   DrawerMenuRow(
//                     onTap: () {
//                       Navigator.pop(context);
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => const TotalRevenuePage(),
//                       //   ),
//                       // );
//                     },
//                     imagePath: "lib/icons/charts.png",
//                     title: "Reports",
//                   ),
//                   SizedBox(height: 150),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 30),
//                       child: Row(
//                         children: [
//                           Container(
//                             height: 24,
//                             child: Image.asset(
//                               'lib/icons/back-arrow.png',
//                               color: Colors.green,
//                             ),
//                           ),
//                           SizedBox(width: 15),
//                           Text(
//                             "Go Back",
//                             style: TextStyle(fontSize: 16, color: Colors.green),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Container(
//             height: 15,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.black12, // Sets the color of the border
//                 width: 1.0, // Sets the width of the border
//               ),
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(
//                 10.0,
//               ), // Uniform radius for all corners
//             ),
//             child: Builder(
//               builder: (context) => IconButton(
//                 icon: const Icon(Icons.menu),
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer(); // 👈 open only by button
//                 },
//               ),
//             ),
//           ),
//         ),
//
//         actions: [
//           Container(
//             height: 25,
//             child: Image.asset('lib/icons/active.png', color: Colors.black),
//           ),
//           SizedBox(width: 10.0),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Container(
//               height: 30,
//               child: Image.asset('lib/icons/user.png'),
//             ),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Container(color: Colors.black12, height: 1.0),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context); // Go back to previous page
//                       },
//                       child: Container(
//                         height: 45,
//                         width: 45,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black12, width: 1.0),
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(
//                             10.0,
//                           ), // Uniform radius for all corners
//                         ),
//                         child: Container(
//                           height: 8,
//                           child: Image.asset(
//                             'lib/icons/back-arrow.png',
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 20.0),
//                     Text(
//                       "Referral Tree",
//                       style: TextStyle(
//                         fontSize: 26.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.0),
//                 Container(
//                   width: 1000,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black12, width: 1.0),
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(
//                       10.0,
//                     ), // Uniform radius for all corners
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Container(
//                               height: 24,
//                               child: Image.asset(
//                                 'lib/icons/git.png',
//                                 color: Colors.green,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 6,
//                             ), // spacing between icon and text
//                             Text(
//                               "Complete\nRefferal Tree",
//                               style: TextStyle(
//                                 fontSize: 24.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 InkWell(
//                                   onTap: () {},
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 6,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white54,
//                                       borderRadius: BorderRadius.circular(
//                                         6,
//                                       ), // rounded corners
//                                       border: Border.all(
//                                         color: Colors.grey, // border color
//                                         width: 0.5,
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Container(
//                                           height: 14,
//                                           child: Image.asset(
//                                             'lib/icons/share.png',
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 6,
//                                         ), // spacing between icon and text
//                                         Text(
//                                           "Share",
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 InkWell(
//                                   onTap: () {},
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 6,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white54,
//                                       borderRadius: BorderRadius.circular(
//                                         6,
//                                       ), // rounded corners
//                                       border: Border.all(
//                                         color: Colors.grey, // border color
//                                         width: 0.5,
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Container(
//                                           height: 16,
//                                           child: Image.asset(
//                                             'lib/icons/printer.png',
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 4,
//                                         ), // spacing between icon and text
//                                         Text(
//                                           "Print",
//                                           style: TextStyle(
//                                             fontSize: 14,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Text(
//                           "Visualize the entire agent network hierarchy",
//                           style: TextStyle(fontSize: 16.0, color: Colors.green),
//                         ),
//                         SizedBox(height: 30.0),
//                         Container(
//                           width: 500,
//                           height: 600, // fixed container height
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             border: Border.all(color: Colors.black26),
//                           ),
//                           child: Scrollbar(
//                             thumbVisibility: true,
//                             child: SingleChildScrollView(
//                               scrollDirection: Axis.vertical,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         AgentRow(
//                                           name:
//                                               columnData[1]['name'] ??
//                                               'Unknown',
//                                           id: columnData[1]['id'] ?? '-',
//                                           imagePath:
//                                               columnData[1]['image'] ?? '',
//                                         ),
//                                         // Vertical line
//                                         Container(
//                                           width: 0.5,
//                                           height: 400, // long vertical line
//                                           color: Colors.grey,
//                                         ),
//                                         // Top agent
//                                         AgentRow(
//                                           name:
//                                               columnData[0]['name'] ??
//                                               'Unknown',
//                                           id: columnData[0]['id'] ?? '-',
//                                           imagePath:
//                                               columnData[0]['image'] ?? '',
//                                         ),
//                                         SizedBox(
//                                           height: 250,
//                                         ), // space to bottom agent
//                                         // Bottom agent
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DrawerMenuRow extends StatelessWidget {
//   final IconData? icon; // optional icon
//   final String? imagePath; // optional image
//   final String title;
//   final VoidCallback? onTap; // <-- add this
//
//   const DrawerMenuRow({
//     super.key,
//     this.icon,
//     this.imagePath,
//     required this.title,
//     this.onTap, // <-- accept callback
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Widget leadingWidget;
//
//     if (imagePath != null) {
//       leadingWidget = Image.asset(
//         imagePath!,
//         width: 24,
//         height: 24,
//         color: Colors.green,
//       );
//     } else if (icon != null) {
//       leadingWidget = Icon(icon, color: Colors.green);
//     } else {
//       leadingWidget = const SizedBox(width: 24, height: 24);
//     }
//
//     return InkWell(
//       onTap: onTap, // <-- call the callback
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//         child: Row(
//           children: [
//             leadingWidget,
//             const SizedBox(width: 15),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 20, color: Colors.green),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class AgentRow extends StatelessWidget {
//   final String name;
//   final String id;
//   final String imagePath;
//
//   const AgentRow({
//     Key? key,
//     required this.name,
//     required this.id,
//     required this.imagePath,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 25,
//           backgroundImage: imagePath.isNotEmpty ? AssetImage(imagePath) : null,
//           child: imagePath.isEmpty ? Icon(Icons.person) : null,
//         ),
//         SizedBox(width: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
//             Text('ID: $id', style: TextStyle(color: Colors.grey)),
//           ],
//         ),
//       ],
//     );
//   }
// }
