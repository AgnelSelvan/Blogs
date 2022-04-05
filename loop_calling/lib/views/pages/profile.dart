import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loop_calling/core/utils/enum/input.dart';
import 'package:loop_calling/core/utils/utils.dart';
import 'package:loop_calling/res/colors.dart';
import 'package:loop_calling/view_model/user/user.dart';
import 'package:loop_calling/views/pages/register.dart';
import 'package:loop_calling/views/widgets/loader.dart';
import 'package:loop_calling/views/widgets/textfield.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late UserProvider _userProvider;
  FocusNode tagFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();

  int selectedIndex = 0;

  performInit() async {
    _userProvider = ref.read(userProvider);
    final failure = await _userProvider.getUserData();

    if (failure != null) {
      Utiliy.showErrorSnackbar(context, message: failure.toString());
    }
  }

  @override
  void initState() {
    performInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Consumer(
                builder: (context, ref, child) {
                  final authProvider = ref.watch(userProvider);
                  if (authProvider.user == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: FutureBuilder<String?>(
                                future: ref.read(userProvider).profilePic,
                                builder: ((context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return snapshot.data == null
                                        ? Icon(
                                            Icons.account_circle,
                                            color: Colors.grey[400]!,
                                            size: 120,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        snapshot.data!))),
                                          );
                                  }
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [CustomLoader()],
                                  );
                                })),
                          ),
                          InkWell(
                            onTap: () async {
                              // final image = await ImagePicker.platform
                              //     .pickImage(source: ImageSource.gallery);
                              // if (image == null) {
                              //   Utiliy.showErrorSnackbar(context,
                              //       message: "Image Not picked");
                              // } else {
                              //   final failure = await ref
                              //       .read(userProvider)
                              //       .uploadImage(File(image.path));
                              //   if (failure != null) {
                              //     Utiliy.showErrorSnackbar(context,
                              //         message: failure.toString());
                              //   } else {
                              //     Utiliy.showSuccessSnackbar(context,
                              //         message: "Image Uplaoded Successfully");
                              //   }
                              // }
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.green[400],
                            ),
                          )
                        ],
                      ),
                      Text(authProvider.user?.user.login ?? ""),
                      Wrap(
                        children: (authProvider.user?.user.tags ?? [])
                            .map((e) => TagContainer(e))
                            .toList(),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Wrap(
                        children: authProvider.tagsList
                            .map((e) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _userProvider.removeTag(e);
                                        },
                                        child: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                      RegisterTextField(
                        hintText: "",
                        onChanged: (va) {
                          setState(() {});
                        },
                        focusNode: tagFocus,
                        labelText: "Enter Tag",
                        inputType: InputType.phone,
                        leadingIcon: Icons.tag,
                        controller: authProvider.tagController,
                      ),
                      if (tagFocus.hasFocus)
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            RegisterButton(
                              text: "Add",
                              btnColor: Colors.green[400],
                              childColor: Colors.white,
                              onPressed: () {
                                _userProvider.addTag();
                              },
                            )
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      RegisterTextField(
                        hintText: "263846293",
                        onChanged: (va) {
                          setState(() {});
                        },
                        labelText: "Enter Mobile No",
                        inputType: InputType.phone,
                        leadingIcon: Icons.dialpad,
                        textInputType: TextInputType.number,
                        controller: authProvider.mobileNoController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RegisterTextField(
                        hintText: "",
                        labelText: "Enter District",
                        inputType: InputType.district,
                        leadingIcon: Icons.apartment,
                        controller: authProvider.districtController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RegisterTextField(
                        hintText: "263846293",
                        labelText: "Enter State",
                        inputType: InputType.state,
                        leadingIcon: Icons.map,
                        controller: authProvider.stateController,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(child: child),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (selectedIndex != 0) {
                                selectedIndex--;
                              }
                              _scrollController.animateTo(
                                -(10 * selectedIndex.toDouble() -
                                    (selectedIndex.toDouble() * 40)),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn,
                              );
                              setState(() {});
                            },
                            icon: const Icon(Icons.arrow_left),
                          ),
                          SizedBox(
                            width: 200,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  10,
                                  (index) => Container(
                                    width: 10,
                                    margin: const EdgeInsets.all(20),
                                    child: Text(
                                      "$index",
                                      style: TextStyle(
                                        color: selectedIndex == index
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ).toList(),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              selectedIndex++;
                              _scrollController.animateTo(
                                10 * selectedIndex.toDouble() +
                                    (selectedIndex.toDouble() * 40),
                                duration: const Duration(seconds: 2),
                                curve: Curves.easeIn,
                              );
                              setState(() {});
                            },
                            icon: const Icon(Icons.arrow_right),
                          ),
                        ],
                      )
                    ],
                  );
                },
                child: RegisterButton(
                  text: "Update",
                  btnColor: AppColors.lightPrimaryColor,
                  childColor: Colors.white,
                  onPressed: () async {
                    final failure = await _userProvider.updateUserData();
                    if (failure != null) {
                      Utiliy.showErrorSnackbar(context,
                          message: failure.toString());
                    } else {
                      Utiliy.showSuccessSnackbar(context,
                          message: "Update Successfull");
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }
}

class TagContainer extends StatelessWidget {
  final String tag;
  const TagContainer(
    this.tag, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Text(
        "#$tag",
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
