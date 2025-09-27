import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:new_project/adminpages/ReportsPage.dart';
import 'package:new_project/adminpages/WithdrawalRequestPage.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'CommisionPayoutPage.dart';
import 'ManageAgentsPage.dart';
import 'ManageBranches.dart';
import 'ReferrelPage.dart';
import 'TotalRevenuePage.dart';
import 'TotalVenturesPage.dart';
import 'networkpage.dart';

class Dashboardpage extends StatelessWidget {
  const Dashboardpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: DashboardBody());
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {

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
    final TextEditingController ventureNameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController totaltreesController = TextEditingController();
    final TextEditingController treessoldController = TextEditingController();
    String? selectedVenureStatus;

    final List<String> venturestatus = ["Upcoming", "Ongoing", "Completed"];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // 👈 removes side margins
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // 👈 square corners
          ),
          child: SizedBox(
            width: double.infinity, // 👈 full width
            height: 700, // adjust height as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 👇 Close button at top-right
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    iconSize: 24,
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  // Title + subtitle
                  Column(
                    children: const [
                      Text(
                        "Create New Venture",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Fill in the details below to add a new venture",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

                  // 👇 Scrollable form
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Venture Name",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: ventureNameController,
                            decoration: const InputDecoration(
                              hintText: "e.g.,Green Meadows Phase 1",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Location",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: locationController,
                            decoration: const InputDecoration(
                              hintText: "e.g.,Near Pharma City",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Status",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          DropdownButtonFormField<String>(
                            value: selectedVenureStatus,
                            items: venturestatus.map((ventures) {
                              return DropdownMenuItem(
                                value: ventures,
                                child: Text(
                                  ventures,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedVenureStatus = value;
                              });
                            },
                            hint: const Text(
                              "Select venture status",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
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
                          const Text(
                            "Total Trees",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: totaltreesController,
                            decoration: const InputDecoration(
                              hintText: "e.g.,100",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Trees Sold(Initial)",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: treessoldController,
                            decoration: const InputDecoration(
                              hintText: "0",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity, // full width button
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                print(
                                  "venture name: ${ventureNameController.text}",
                                );
                                print("location: ${locationController.text}");

                                print(
                                  "total trees: ${totaltreesController.text}",
                                );
                                print(
                                  "trees sold: ${treessoldController.text}",
                                );

                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Create Venture",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showUserFormDialog2(BuildContext context) {
    final TextEditingController branchNameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // 👈 removes side margins
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // 👈 square corners
          ),
          child: SizedBox(
            width: double.infinity, // 👈 full width
            height: 400, // adjust height as needed
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 👇 Close button at top-right
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    iconSize: 24,
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  // Title + subtitle
                  Column(
                    children: const [
                      Text(
                        "Create New Branch",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Fill in the details below to add a new branch",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),

                  // 👇 Scrollable form
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Branch Name",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: branchNameController,
                            decoration: const InputDecoration(
                              hintText: "e.g.,Hyderabad Main",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Location",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 6.0),
                          TextField(
                            controller: locationController,
                            decoration: const InputDecoration(
                              hintText: "e.g., Ameerpet",
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity, // full width button
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                print(
                                  "branchname: ${branchNameController.text}",
                                );
                                print("location: ${locationController.text}");
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Create Branch",
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  String _selectedDate = "pick a date range"; // default text
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  /// Handle date selection
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      DateTime? start = args.value.startDate;
      DateTime? endNullable = args.value.endDate ?? start;

      if (start != null && endNullable != null) {
        DateTime now = DateTime.now();
        // Ensure end is not after today
        DateTime end = endNullable.isAfter(now) ? now : endNullable;

        setState(() {
          if (start == end) {
            // single date
            _selectedDate = DateFormat("dd MMMM yyyy").format(start);
          } else {
            // range
            _selectedDate =
                "${DateFormat('dd MMM yyyy').format(start)} → ${DateFormat('dd MMM yyyy').format(end)}";
          }
        });
      }
    }
  }

  /// Show popup just under TextField
  void _showCalendar(BuildContext context) {
    if (_overlayEntry != null) return; // already open

    final renderBox = _fieldKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    DateTime now = DateTime.now();

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // tap outside to close
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
            ),
          ),

          // calendar popup
          Positioned(
            top: position.dy + size.height + 5, // below textfield
            left: position.dx,
            width: 320,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  onSelectionChanged: _onSelectionChanged,
                  view: DateRangePickerView.month,
                  minDate: DateTime(
                    now.year,
                    1,
                    1,
                  ), // first day of year or desired min
                  maxDate: now, // ✅ prevent selecting future dates
                  initialDisplayDate: now,
                  showNavigationArrow: true, // allow moving across months
                  allowViewNavigation: true, // allow year/month picker
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 15,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black12, // Sets the color of the border
                width: 1.0, // Sets the width of the border
                // Sets the style of the border (e.g., solid, dashed, dotted)
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
            padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 5.0),
                Text(
                  "Dashboard",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                SizedBox(height: 12.0),
                Row(
                  children: [
                    Container(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Today", style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12, // Sets the color of the border
                          width: 1.0, // Sets the width of the border
                          // Sets the style of the border (e.g., solid, dashed, dotted)
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Uniform radius for all corners
                      ),
                      // color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "This Week",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12, // Sets the color of the border
                          width: 1.0, // Sets the width of the border
                          // Sets the style of the border (e.g., solid, dashed, dotted)
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), // Uniform radius for all corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "This Month",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                  ],
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12, // Sets the color of the border
                      width: 1.0, // Sets the width of the border
                      // Sets the style of the border (e.g., solid, dashed, dotted)
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      10.0,
                    ), // Uniform radius for all corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("All Time", style: TextStyle(fontSize: 16.0)),
                  ),
                ),
                SizedBox(height: 10.0),
                GestureDetector(
                  key: _fieldKey,
                  onTap: () {
                    if (_overlayEntry == null) {
                      _showCalendar(context);
                    } else {
                      _removeOverlay();
                    }
                  },
                  child: Container(
                    height: 55.0,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.black),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedDate,
                            style: TextStyle(
                              fontSize: 18,
                              color: _selectedDate == "pick a date range"
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TotalRevenuePage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFF4A9782),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "TOTAL REVENUE", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit
                                            .scaleDown, // scales both icon + text
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_outlined,
                                              size: 30, // 👈 base size
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "17,00,000",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30, // 👈 base size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "20", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      " investments", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommisionPayoutPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFFD92C54),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  child: Image.asset(
                                    'lib/icons/coins.png',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "COMMISSION PAID", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit
                                            .scaleDown, // scales both icon + text
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_outlined,
                                              size: 30, // 👈 base size
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "1,91,000",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30, // 👈 base size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Paid to agent", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "network", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFF3D74B6),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  child: Image.asset(
                                    'lib/icons/text.png',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "NET WORTH", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit
                                            .scaleDown, // scales both icon + text
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.currency_rupee_outlined,
                                              size: 30, // 👈 base size
                                              color: Colors.white,
                                            ),
                                            Text(
                                              "15,00,000",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30, // 👈 base size
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Revenue -", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Commissions", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageAgentPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFFB13BFF),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.people_outlined,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "TOTAL AGENTS", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "34", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "All registered agents", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TotalVenturesPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFFD92C54),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  child: Image.asset(
                                    'lib/icons/bag.png',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "TOTAL VENTURES", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "4", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Ready for investment", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageBranchesPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 200,
                        width: 175,
                        child: Card(
                          color: Color(0xFFFFD66B),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  child: Image.asset(
                                    'lib/icons/bank.png',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "TOTAL BRANCHES", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "2", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Across the", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "organization", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Referrelpage(),
                        //   ),
                        // );
                      },

                      child: Container(
                        width: 175,
                        child: Card(
                          color: Color(0xFF67AE6E),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  child: Image.asset(
                                    'lib/icons/decision-tree.png',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "REFERRAL TREE", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "VIEW", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "NETWORK", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Complete agent", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "hierarchy", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Withdrawalrequestpage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 175,
                        child: Card(
                          color: Color(0xFF3D74B6),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  child: Image.asset(
                                    'lib/icons/pig.png',
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "WITHDRAWAL", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "REQUESTS", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "2", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Pending", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Approve agent", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "payouts", // 👈 text comes from list
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Reportspage()),
                    );
                  },
                  child: Container(
                    width: 175,
                    child: Card(
                      color: Color(0xFF5C7285),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              child: Image.asset(
                                'lib/icons/charts.png',
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "REPORTS", // 👈 text comes from list
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "VIEW &", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "EXPORT", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Download detailed", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "reports", // 👈 text comes from list
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.0),
                InkWell(
                  onTap: () {
                    showUserFormDialog(context);
                  },
                  child: Container(
                    width: 175,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12, // Sets the color of the border
                        width: 1.0, // Sets the width of the border
                        // Sets the style of the border (e.g., solid, dashed, dotted)
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ), // Uniform radius for all corners
                    ),
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 25,
                            child: Image.asset(
                              'lib/icons/add-friend.png',
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Text("Create Agent", style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    showUserFormDialog1(context);
                  },
                  child: Container(
                    width: 175,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12, // Sets the color of the border
                        width: 1.0, // Sets the width of the border
                        // Sets the style of the border (e.g., solid, dashed, dotted)
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ), // Uniform radius for all corners
                    ),
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            child: Image.asset(
                              'lib/icons/add.png',
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Text(
                            "Create Venture",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                InkWell(
                  onTap: () {
                    showUserFormDialog2(context);
                  },
                  child: Container(
                    width: 175,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12, // Sets the color of the border
                        width: 1.0, // Sets the width of the border
                        // Sets the style of the border (e.g., solid, dashed, dotted)
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ), // Uniform radius for all corners
                    ),
                    // color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 30,
                            child: Image.asset(
                              'lib/icons/git.png',
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Text("Create Branch", style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
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
