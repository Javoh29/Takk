import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final String tag = 'AddPhotoPage';
  File? _image;
  final picker = ImagePicker();
  DateTime? _selectDate;
  String _name = '';

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _showDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        _selectDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Create User Page'),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: scaffoldColor,
    //     elevation: 0,
    //     leading: TextButton.icon(
    //         onPressed: () => Navigator.pop(context),
    //         icon: Icon(
    //           Ionicons.chevron_back_outline,
    //           size: 22,
    //           color: textColor1,
    //         ),
    //         style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
    //         label: Text(
    //           'Back',
    //           style: kTextStyle(color: textColor1, size: 16, fontWeight: FontWeight.w500),
    //         )),
    //     actions: [
    //       Center(
    //         child: Padding(
    //           padding: const EdgeInsets.only(right: 5),
    //           child: TextButton(
    //               onPressed: () {
    //                 if (_name.isNotEmpty && _selectDate != null)
    //                   Future.delayed(Duration.zero, () async {
    //                     showLoadingDialog(context);
    //                     context
    //                         .read<UserProvider>()
    //                         .setUserData(tag,
    //                             name: _name,
    //                             date: DateFormat('yyyy-MM-dd').format(_selectDate!),
    //                             imgPath: _image != null ? _image!.path : null)
    //                         .then((value) {
    //                       Navigator.pop(context);
    //                       if (context.read<UserProvider>().getState(tag) == 'success') {
    //                         Navigator.pushAndRemoveUntil(
    //                             context,
    //                             MaterialPageRoute(
    //                               builder: (_) => HomePage(),
    //                             ),
    //                             (r) => false);
    //                       } else
    //                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                           content: Text(value),
    //                           backgroundColor: Colors.redAccent,
    //                         ));
    //                     });
    //                   });
    //                 else if (_name.isEmpty)
    //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                     content: Text('Please enter your name!'),
    //                     backgroundColor: Colors.redAccent,
    //                   ));
    //                 else if (_selectDate == null)
    //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //                     content: Text('Please enter your birth date!'),
    //                     backgroundColor: Colors.redAccent,
    //                   ));
    //               },
    //               style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
    //               child: Text(
    //                 'Next',
    //                 style: kTextStyle(color: textColor1, size: 16, fontWeight: FontWeight.w500),
    //               )),
    //         ),
    //       )
    //     ],
    //     leadingWidth: 85,
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           'Introduce yourself',
    //           style: kTextStyle(color: textColor1, size: 24, fontWeight: FontWeight.bold),
    //         ),
    //         Padding(
    //           padding: const EdgeInsets.only(bottom: 30),
    //           child: Text(
    //             'Please, provide your name and profile photo',
    //             style: kTextStyle(color: textColor3, fontWeight: FontWeight.w500),
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.center,
    //           child: _image == null
    //               ? Stack(
    //                   children: [
    //                     Container(
    //                       height: 60,
    //                       width: 150,
    //                       margin: EdgeInsets.all(5),
    //                       alignment: Alignment.center,
    //                       decoration: BoxDecoration(color: textColor3, borderRadius: BorderRadius.circular(30)),
    //                       child: TextButton.icon(
    //                           onPressed: getImage,
    //                           style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
    //                           icon: Icon(
    //                             Ionicons.camera_outline,
    //                             size: 24,
    //                             color: textColor1,
    //                           ),
    //                           label: Text(
    //                             'Add Photo',
    //                             style: kTextStyle(color: textColor1, size: 16, fontWeight: FontWeight.w500),
    //                           )),
    //                     ),
    //                     Positioned(
    //                         right: 0,
    //                         bottom: 0,
    //                         child: Icon(
    //                           Ionicons.add_circle,
    //                           size: 30,
    //                           color: textColor1,
    //                         ))
    //                   ],
    //                 )
    //               : GestureDetector(
    //                   onTap: getImage,
    //                   child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(45),
    //                       child: Image.file(
    //                         _image!,
    //                         height: 90,
    //                         width: 90,
    //                         fit: BoxFit.cover,
    //                       )),
    //                 ),
    //         ),
    //         SizedBox(
    //           height: 20,
    //         ),
    //         TextField(
    //           autofocus: true,
    //           style: kTextStyle(color: textColor1, size: 16, fontWeight: FontWeight.w500),
    //           decoration: InputDecoration(
    //             hintText: 'Enter your name',
    //             hintStyle: kTextStyle(color: Colors.black26, size: 16, fontWeight: FontWeight.w400),
    //             prefix: Padding(
    //               padding: const EdgeInsets.only(right: 30),
    //               child: Text(
    //                 'Name',
    //                 style: kTextStyle(color: textColor2, size: 16, fontWeight: FontWeight.w500),
    //               ),
    //             ),
    //             enabledBorder: UnderlineInputBorder(
    //               borderSide: BorderSide(color: Colors.black12, width: 0.8),
    //             ),
    //             focusedBorder: UnderlineInputBorder(
    //               borderSide: BorderSide(color: Colors.black12, width: 0.8),
    //             ),
    //           ),
    //           onChanged: (text) => _name = text,
    //         ),
    //         SizedBox(
    //           height: 5,
    //         ),
    //         Row(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(right: 15),
    //               child: Text(
    //                 'Birth date:',
    //                 style: kTextStyle(color: textColor2, size: 16, fontWeight: FontWeight.w500),
    //               ),
    //             ),
    //             Expanded(
    //               child: Text(
    //                 _selectDate == null ? 'Select' : DateFormat.yMMMd().format(_selectDate!),
    //                 style: kTextStyle(
    //                     color: _selectDate == null ? Colors.black26 : textColor1,
    //                     size: 16,
    //                     fontWeight: FontWeight.w500),
    //               ),
    //             ),
    //             IconButton(
    //                 highlightColor: Colors.transparent,
    //                 splashColor: Colors.transparent,
    //                 onPressed: () => _showDate(),
    //                 icon: Icon(
    //                   Ionicons.chevron_down_outline,
    //                   color: textColor2,
    //                   size: 20,
    //                 ))
    //           ],
    //         ),
    //         Divider(
    //           height: 1,
    //           color: Colors.black26,
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
