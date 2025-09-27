import 'package:flutter/material.dart';
import 'package:new_project/adminpages/WithdrawalRequestPage.dart';

import 'CommisionPayoutPage.dart';
import 'DashboardPage.dart';
import 'ManageBranches.dart';
import 'TotalRevenuePage.dart';
import 'TotalVenturesPage.dart';

class ManageAgentPage extends StatelessWidget {
  const ManageAgentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ManageAgentPageBody());
  }
}

class ManageAgentPageBody extends StatefulWidget {
  const ManageAgentPageBody({super.key});

  @override
  State<ManageAgentPageBody> createState() => _ManageAgentPageBodyState();
}

class _ManageAgentPageBodyState extends State<ManageAgentPageBody> {
  final FocusNode _focusNode = FocusNode();

  void showUserFormDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController fatherNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController pannumController = TextEditingController();
    final TextEditingController aadharnumController = TextEditingController();
    final TextEditingController bankaccountController = TextEditingController();
    final TextEditingController ifsccodeController = TextEditingController();
    String? selectedBranch;
    String? selectreferredby;
    String? selectventure;

    final List<String> branches = ["Branch A", "Branch B", "Branch C"];
    final List<String> referredby = [
      "chinthala ramesh(svd-st-27)",
      "mathesh(svd-st-25)",
      "shiam (svd-st-44)",
      "thalapally naveen(svd-st-13)",
    ];
    final List<String> ventures = [
      "vemulawada 5acres ramanpet venture(22/600 sold)",
      "kondagattu 5acres prakruthi shikara(5/800 sold)",
      "prakruthikshira-4hnk,chinnapendyala(2/900 sold)",
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // 👈 Square corners
              ),
              content: SizedBox(
                width: 600,
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      iconSize: 20,
                      onPressed: () => Navigator.of(context).pop(),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Create New Agent & Initial Investment",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "This will create an agent's profile and their login credentials.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 12.0),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                    // 👇 scrollable form
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Father's Name"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: fatherNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Login Email"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            SizedBox(height: 10.0),
                            Text("Login Password"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Mobile"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: mobileController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Branch"),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: selectedBranch,
                              items: branches.map((branch) {
                                return DropdownMenuItem(
                                  value: branch,
                                  child: Text(
                                    branch,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedBranch = value;
                                });
                              },
                              hint: const Text(
                                "Select a Branch",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("PAN Card"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: pannumController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Aadhar Number"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: aadharnumController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Bank Account Number"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: bankaccountController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("IFSC Code"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: ifsccodeController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text("Referred By(Upline)"),
                            SizedBox(height: 6.0),
                            DropdownButtonFormField<String>(
                              value: selectreferredby,
                              items: referredby.map((refer) {
                                return DropdownMenuItem(
                                  value: refer,
                                  child: Text(
                                    refer,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectreferredby = value;
                                });
                              },
                              // hint: const Text(
                              //   "Select a Branch",
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Venture"),
                            SizedBox(height: 6.0),
                            DropdownButtonFormField<String>(
                              value: selectventure,
                              isExpanded:
                                  true, // 👈 allow full width and wrap long text
                              items: ventures.map((vent) {
                                return DropdownMenuItem(
                                  value: vent,
                                  child: Text(
                                    vent,
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow
                                        .ellipsis, // 👈 optional: shorten long text
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectventure = value;
                                });
                              },
                              hint: const Text(
                                "Select a Venture for the investment",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              dropdownColor: Colors.white,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Number of Trees",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "Investment Amount",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                // Minus Button
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 20),
                                  onPressed: () {
                                    if (numberOfTrees > 1) {
                                      numberOfTrees--;
                                      updateInvestment();
                                    }
                                  },
                                ),

                                // Number of Trees TextField with focus border
                                SizedBox(
                                  width: 50,
                                  child: Focus(
                                    child: TextField(
                                      controller: treeController,
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      onChanged: (value) {
                                        int val = int.tryParse(value) ?? 1;
                                        if (val < 1) val = 1;
                                        numberOfTrees = val;
                                        updateInvestment();
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,
                                            width: 1.5,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Colors.green,
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 6,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Plus Button
                                IconButton(
                                  icon: const Icon(Icons.add, size: 20),
                                  onPressed: () {
                                    numberOfTrees++;
                                    updateInvestment();
                                  },
                                ),

                                const SizedBox(width: 6),

                                // Investment Amount Field (readonly) with border color change
                                Expanded(
                                  child: TextField(
                                    controller: investmentController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                          color: Colors.green,
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 6,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),
                            SizedBox(
                              width:
                                  double.infinity, // take full available width
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .green, // 👈 button background color
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // 👈 border radius
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ), // taller button
                                ),
                                onPressed: () {
                                  print("Name: ${nameController.text}");
                                  print(
                                    "Father Name: ${fatherNameController.text}",
                                  );
                                  print("Email: ${emailController.text}");
                                  print("Password: ${passwordController.text}");
                                  print("Mobile: ${mobileController.text}");
                                  print("Branch: $selectedBranch");
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Create Agent"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showUserFormDialog1(BuildContext context) {
    final TextEditingController nameController1 = TextEditingController();
    final TextEditingController fatherNameController1 = TextEditingController();
    final TextEditingController emailController1 = TextEditingController();
    final TextEditingController mobileController1 = TextEditingController();
    final TextEditingController pannumController1 = TextEditingController();
    final TextEditingController aadharnumController1 = TextEditingController();
    final TextEditingController bankaccountController1 =
        TextEditingController();
    final TextEditingController ifsccodeController1 = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // 👈 Square corners
              ),
              content: SizedBox(
                width: 600,
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      iconSize: 20,
                      onPressed: () => Navigator.of(context).pop(),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Edit Agent Details",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Modify the details for chinthala ramesh.Click save when you're done",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 12.0),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),

                    // 👇 scrollable form
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: nameController1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Father's Name"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: fatherNameController1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Email"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: emailController1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Mobile"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: mobileController1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("PAN Card"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: pannumController1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Aadhar Number"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: aadharnumController1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("Bank Account Number"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: bankaccountController1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text("IFSC Code"),
                            SizedBox(height: 6.0),
                            TextField(
                              controller: ifsccodeController1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .green, // 👈 border color when clicked/focused
                                    width: 2.0,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10, // 👈 height of TextField
                                  horizontal: 20,
                                ),
                              ),
                            ),

                            SizedBox(height: 20),
                            SizedBox(
                              width:
                                  double.infinity, // take full available width
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors
                                      .green, // 👈 button background color
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // 👈 border radius
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ), // taller button
                                ),
                                onPressed: () {
                                  print("Name: ${nameController1.text}");
                                  print(
                                    "Father Name: ${fatherNameController1.text}",
                                  );
                                  print("Email: ${emailController1.text}");
                                  print("Mobile: ${mobileController1.text}");
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Save Changes"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  int numberOfTrees = 1;
  double investmentPerTree = 50000;

  final TextEditingController treeController = TextEditingController();
  final TextEditingController investmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    treeController.text = numberOfTrees.toString();
    investmentController.text = (numberOfTrees * investmentPerTree)
        .toStringAsFixed(2);
  }

  void updateInvestment() {
    setState(() {
      investmentController.text = (numberOfTrees * investmentPerTree)
          .toStringAsFixed(2);
      treeController.text = numberOfTrees.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> data = [
      {"name": "Chinnala Tyuh", "id": "svd-st-23", "status": "Active"},
      {"name": "Sunitha Sharma", "id": "svd-st-24", "status": "Active"},
      {"name": "Ravi Kumar Chinnala", "id": "svd-st-25", "status": "Active"},
      {"name": "Anil Kumar", "id": "svd-st-26", "status": "Active"},
      {"name": "Priya Reddy", "id": "svd-st-27", "status": "Active"},
      {"name": "Suresh Babu", "id": "svd-st-28", "status": "Active"},
      {"name": "Kavya Sharma", "id": "svd-st-29", "status": "Active"},
      {"name": "Vikram Singh", "id": "svd-st-30", "status": "Active"},
    ];
    return Scaffold(
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 18,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close drawer
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.menu, color: Colors.green),
                  SizedBox(width: 15),
                  Text(
                    "Sri Vayutej \nDevelopers",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dashboardpage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/home.png",
                    title: "Dashboard",
                  ),

                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageAgentPage(),
                        ),
                      );
                    },
                    icon: Icons.people_outlined,
                    title: "Agents",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TotalVenturesPage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/bag.png",
                    title: "Ventures",
                  ),

                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageBranchesPage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/git.png",
                    title: "Branches",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TotalRevenuePage(),
                        ),
                      );
                    },
                    icon: Icons.account_balance_wallet_outlined,
                    title: "Investments",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CommisionPayoutPage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/coins.png",
                    title: "Payouts",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const TotalRevenuePage(),
                      //   ),
                      // );
                    },
                    imagePath: "lib/icons/decision-tree.png",
                    title: "Referral Tree",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Withdrawalrequestpage(),
                        ),
                      );
                    },
                    imagePath: "lib/icons/coins.png",
                    title: "Withdrawals",
                  ),
                  DrawerMenuRow(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const TotalRevenuePage(),
                      //   ),
                      // );
                    },
                    imagePath: "lib/icons/charts.png",
                    title: "Reports",
                  ),
                  SizedBox(height: 150),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Container(
                            height: 24,
                            child: Image.asset(
                              'lib/icons/back-arrow.png',
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Go Back",
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
            height: 15,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12, // Sets the color of the border
                width: 1.0, // Sets the width of the border
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10.0,
              ), // Uniform radius for all corners
            ),
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // 👈 open only by button
                },
              ),
            ),
          ),
        ),

        actions: [
          Container(
            height: 25,
            child: Image.asset('lib/icons/active.png', color: Colors.black),
          ),
          SizedBox(width: 10.0),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: 30,
              child: Image.asset('lib/icons/user.png'),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.black12, height: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); // Go back to previous page
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.0),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            10.0,
                          ), // Uniform radius for all corners
                        ),
                        child: Container(
                          height: 8,
                          child: Image.asset(
                            'lib/icons/back-arrow.png',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Text(
                      "Manage Agents",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Search by name or ID...',
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.green,
                              width: 2,
                            ), // changes on click
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.0),

                    InkWell(
                      onTap: () {
                        showUserFormDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            6,
                          ), // rounded corners
                          border: Border.all(
                            color: Colors.green, // border color
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 14,
                              child: Image.asset(
                                'lib/icons/add-friend.png',
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ), // spacing between icon and text
                            Text(
                              "Create Agent",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 1000,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1.0),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Uniform radius for all corners
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people_outlined,
                              size: 30,
                              color: Colors.green,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Agents",
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Manage and view all registered agents and their referral upline",
                          style: TextStyle(fontSize: 12.0, color: Colors.green),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                "Agent",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 40.0),
                              Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 130.0),
                              Text(
                                "Actions",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 3.0),
                        // Divider(thickness: 0.3, color: Colors.green),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = data[index];
                            final name = item["name"] ?? '';
                            final id = item["id"] ?? '';
                            final status = item["status"] ?? '';

                            return Column(
                              children: [
                                const Divider(
                                  thickness: 0.3,
                                  color: Colors.green,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name + ID
                                      // Name + ID column (auto-wrap)
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                              maxLines: null,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              id,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 30),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: getStatusContainerColor(
                                                  status,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      50,
                                                    ), // pill shape
                                              ),
                                              child: Text(
                                                status,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: getStatusTextColor(
                                                    status,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white54,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ), // rounded corners
                                          border: Border.all(
                                            color: Colors.grey, // border color
                                            width: 0.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              height: 14,
                                              child: Image.asset(
                                                'lib/icons/down-arrow.png',
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ), // spacing between icon and text
                                            Text(
                                              "Receipt",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 6.0),
                                      InkWell(
                                        onTap: () {
                                          showUserFormDialog1(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white54,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ), // rounded corners
                                            border: Border.all(
                                              color:
                                                  Colors.grey, // border color
                                              width: 0.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 14,
                                                child: Image.asset(
                                                  'lib/icons/edit-button.png',
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 6,
                                              ), // spacing between icon and text
                                              Text(
                                                "Edit",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerMenuRow extends StatelessWidget {
  final IconData? icon; // optional icon
  final String? imagePath; // optional image
  final String title;
  final VoidCallback? onTap; // <-- add this

  const DrawerMenuRow({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    this.onTap, // <-- accept callback
  });

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;

    if (imagePath != null) {
      leadingWidget = Image.asset(
        imagePath!,
        width: 24,
        height: 24,
        color: Colors.green,
      );
    } else if (icon != null) {
      leadingWidget = Icon(icon, color: Colors.green);
    } else {
      leadingWidget = const SizedBox(width: 24, height: 24);
    }

    return InkWell(
      onTap: onTap, // <-- call the callback
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper to get background color
Color getStatusContainerColor(String status) {
  switch (status.toLowerCase()) {
    case "Active":
      return Colors.green;
    default:
      return Colors.green;
  }
}

// Helper to get text color
Color getStatusTextColor(String status) {
  switch (status.toLowerCase()) {
    case "Active":
      return Colors.white;
    default:
      return Colors.white;
  }
}
