import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
import 'package:project_blueprint/config/constants/app_colors.dart';
import 'package:project_blueprint/presentation/pages/auth/viewmodel/auth_viewmodel.dart';

class AuthPage extends ViewModelBuilderWidget<AuthViewModel> {
  AuthPage({super.key});

  @override
  Widget builder(BuildContext context, AuthViewModel viewModel, Widget? child) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.scaffoldColor,
        leading: TextButton(
            onPressed: () => Future.delayed(Duration.zero, () {
                  showLoadingDialog(context);
                  model.getCompInfo(tag).then((value) {
                    if (model.getState(tag) == 'success') {
                      cafeModel.getCafesList(tag, false, isToken: false).then((e) {
                        Navigator.pop(context);
                        if (cafeModel.getState(tag) == 'success') {
                          isGuest = true;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HomePage(),
                              ),
                              (r) => false);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(cafeModel.getErr(tag)),
                            backgroundColor: Colors.redAccent,
                          ));
                        }
                      });
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(model.getErr(tag)),
                        backgroundColor: Colors.redAccent,
                      ));
                    }
                  });
                }),
            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
            child: Text(
              'Skip',
              style: kTextStyle(color: textColor1, size: 16, fontWeight: FontWeight.w500),
            )),
        actions: [
          Center(
            child: TextButton(
                onPressed: () => Future.delayed(Duration.zero, () {
                      if (_phone.length == _selectModel.maxLength) {
                        showLoadingDialog(context);
                        model.setAuth(phone: '${_selectModel.dialCode}$_phone', tag: tag).then((value) {
                          Navigator.pop(context);
                          if (model.getState(tag) == 'success') {
                            Navigator.pushNamed(context, Routes.checkCodePage,
                                arguments: {'phone': '${_selectModel.dialCode}$_phone'});
                          } else
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(value),
                              backgroundColor: Colors.redAccent,
                            ));
                        });
                      } else
                        setState(() {
                          isValidate = true;
                        });
                    }),
                style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.transparent)),
                child: Text(
                  'Next',
                  style: kTextStyle(color: textColor1, size: 16, fontWeight: FontWeight.w500),
                )),
          )
        ],
      ),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/app_logo.svg',
                height: 100,
                color: textColor3,
              )),
          ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Welcome to Takk',
                  style: kTextStyle(color: textColor1, size: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Enter your phone number to login or create an account',
                  style: kTextStyle(color: textColor3, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: textColor2, width: 1),
                    boxShadow: [BoxShadow(color: Color(0xffECECEC), offset: Offset(0, 0), blurRadius: 10)]),
                child: Row(
                  children: [
                    ScaleContainer(
                      onTap: () {
                        setState(() {
                          isOpenDrop = !isOpenDrop;
                        });
                      },
                      child: Container(
                        height: 55,
                        width: 80,
                        padding: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                          color: textColor3,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                'assets/flags/${_selectModel.code.toLowerCase()}.png',
                                width: 30,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                isOpenDrop ? Ionicons.chevron_up_outline : Ionicons.chevron_down_outline,
                                size: 16,
                                color: textColor1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixText: '+${_selectModel.dialCode}  ',
                          prefixStyle: kTextStyle(color: textColor1, size: 16, fontWeight: FontWeight.w500),
                          labelText: 'Phone number*',
                          labelStyle: kTextStyle(color: textColor2, fontWeight: FontWeight.w500),
                          suffixIcon: isValidate
                              ? Icon(
                                  Icons.error_outline,
                                  size: 25,
                                  color: Colors.redAccent,
                                )
                              : null,
                        ),
                        onSubmitted: (text) {
                          if (text.length == _selectModel.maxLength)
                            Future.delayed(Duration.zero, () {
                              showLoadingDialog(context);
                              context
                                  .read<UserProvider>()
                                  .setAuth(phone: '${_selectModel.dialCode}$text', tag: tag)
                                  .then((value) {
                                Navigator.pop(context);
                                if (model.getState(tag) == 'success') {
                                  Navigator.pushNamed(context, Routes.checkCodePage,
                                      arguments: {'phone': '${_selectModel.dialCode}$text'});
                                } else
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(value),
                                    backgroundColor: Colors.redAccent,
                                  ));
                              });
                            });
                          else
                            setState(() {
                              isValidate = true;
                            });
                        },
                        inputFormatters: [
                          new LengthLimitingTextInputFormatter(_selectModel.maxLength),
                        ],
                        onChanged: (text) {
                          _phone = text;
                          if (isValidate) {
                            setState(() {
                              isValidate = false;
                            });
                          }
                        },
                        style: kTextStyle(color: textColor1, size: 16, fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ),
              if (isOpenDrop && _listAll.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: _listSort.length >= 3 ? 280 : ((_listSort.length + 1) * 50) + 20,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12, width: 1),
                      boxShadow: [BoxShadow(color: Color(0xffECECEC), offset: Offset(0, 0), blurRadius: 10)]),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Ionicons.search_outline,
                              size: 22,
                              color: Colors.black38,
                            ),
                            hintText: 'Search for countries',
                            hintStyle: kTextStyle(color: Colors.black26, size: 16, fontWeight: FontWeight.w400),
                            prefixIconConstraints: BoxConstraints(minHeight: 20, minWidth: 45),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 0.8),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 0.8),
                            ),
                          ),
                          onChanged: (text) {
                            if (text.isNotEmpty)
                              _searchCountry(text.toLowerCase());
                            else {
                              _listSort.clear();
                              _listSort.addAll(_listAll);
                            }
                          },
                          cursorColor: Colors.grey,
                          style: kTextStyle(color: Colors.black54, size: 16, fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Scrollbar(
                            radius: Radius.circular(5),
                            child: ListView.builder(
                                itemCount: _listSort.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) => ListTile(
                                      onTap: () {
                                        setState(() {
                                          isOpenDrop = false;
                                          _selectModel = _listSort[index];
                                          _listSort.clear();
                                          _listSort.addAll(_listAll);
                                        });
                                      },
                                      leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.asset(
                                            'assets/flags/${_listSort[index].code.toLowerCase()}.png',
                                            height: 30,
                                          )),
                                      title: Text(
                                        '${_listSort[index].name} (+${_listSort[index].dialCode})',
                                        style: kTextStyle(color: Colors.black54, size: 16, fontWeight: FontWeight.w500),
                                      ),
                                    )),
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) {
    return AuthViewModel(context: context);
  }
}
