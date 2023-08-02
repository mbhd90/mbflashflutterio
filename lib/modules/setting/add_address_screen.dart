import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';
import "package:latlong2/latlong.dart";
import 'package:geolocator/geolocator.dart';
import '/utils/k_images.dart';
import '/utils/k_geolocation.dart';
import '../../widgets/address_map.dart';
import '../../widgets/custom_image.dart';


import '../authentication/widgets/sign_up_form.dart';
import '/utils/language_string.dart';
import '/widgets/capitalized_word.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/location_button.dart';
import '../../widgets/rounded_app_bar.dart';
import '../profile/controllers/address/address_cubit.dart';
import '../profile/controllers/country_state_by_id/country_state_by_id_cubit.dart';
import '../profile/model/address_model.dart';
import '../profile/model/city_model.dart';
import '../profile/model/country_model.dart';
import '../profile/model/country_state_model.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  CountryModel? _countryModel;
  CountryStateModel? _countryStateModel;
  CityModel? _cityModel;
  LatLng? position;
  String? _phonCode;
  String? _type;

  AddressModel? addressModel;
  List<CountryModel> countries = [];
  List<CountryStateModel> stateList = [];
  List<CityModel> cityList = [];

  final nameCtr = TextEditingController();
  final emailCtr = TextEditingController();
  final phoneCtr = TextEditingController();
  final addressCtr = TextEditingController();
  final zipCtr = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<CountryStateByIdCubit>().countryListLoaded();
  }

  void _loadState(CountryModel countryModel) {
    _countryModel = countryModel;
    _countryStateModel = null;
    _cityModel = null;

    final stateLoadIdCountryId =
        context.read<CountryStateByIdCubit>().stateLoadIdCountryId;

    stateLoadIdCountryId(countryModel.id.toString());
  }

  void _loadCity(CountryStateModel countryStateModel) {
    _countryStateModel = countryStateModel;
    _cityModel = null;

    final cityLoadIdStateId =
        context.read<CountryStateByIdCubit>().cityLoadIdStateId;

    cityLoadIdStateId(countryStateModel.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final addressBl = context.read<CountryStateByIdCubit>();

    return Scaffold(
      appBar: RoundedAppBar(
        titleText: Language.addNewAddress.capitalizeByWord(),
        onTap: () {
          context.read<AddressCubit>().getAddress();
        },
      ),
      body: BlocConsumer<AddressCubit, AddressState>(
        // listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AddressStateUpdating) {
            Utils.loadingDialog(context);
          } else {
            Utils.closeDialog(context);
            if (state is AddressStateUpdateError) {
              Utils.closeDialog(context);
              Utils.errorSnackBar(context, state.message);
              context.read<AddressCubit>().getAddress();
            } else if (state is AddressStateUpdated) {
              Utils.closeDialog(context);
              Navigator.pop(context);
            }
            // else if (state is AddressStateInvalidDataError) {
            //   context.read<AddressCubit>().getAddress();
            // }
          }
        },
        builder: (context, addressState) {
          return BlocBuilder<CountryStateByIdCubit, CountryStateByIdState>(
            builder: (context, state) {
              if (state is CountryStateByIdStateLoadied) {
                _countryStateModel = context
                    .read<CountryStateByIdCubit>()
                    .filterState(addressModel?.stateId.toString() ?? "");
                if (_countryStateModel != null) {
                  // context
                  //     .read<CountryStateByIdCubit>()
                  //     .cityStateChangeCityFilter(_countryStateModel!);

                  _cityModel = context
                      .read<CountryStateByIdCubit>()
                      .filterCity(addressModel?.cityId.toString() ?? "");
                }
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Language.addNewAddress.capitalizeByWord(),
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.5),
                      ),
                      const SizedBox(height: 9),
                      TextFormField(
                        controller: nameCtr,
                        // validator: (s) {
                        //   if (s == null || s.isEmpty) return '*Name Required';
                        //   return null;
                        // },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: Language.name.capitalizeByWord(),
                          fillColor: borderColor.withOpacity(.10),
                        ),
                      ),
                      if (addressState is AddressStateInvalidDataError) ...[
                        if (addressState.errorMsg.name.isNotEmpty)
                          ErrorText(
                              text: addressState.errorMsg.name.first),
                      ],
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailCtr,
                        // validator: (s) {
                        //   if (s == null || s.isEmpty) {
                        //     return '*Valid Email Required';
                        //   }
                        //   if (!Utils.isEmail(s)) return "*Valid Email Required";
                        //   return null;
                        // },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: Language.emailAddress.capitalizeByWord(),
                          fillColor: borderColor.withOpacity(.10),
                        ),
                      ),
                      if (addressState is AddressStateInvalidDataError) ...[
                        if (addressState.errorMsg.email.isNotEmpty)
                          ErrorText(
                              text: addressState.errorMsg.email.first),
                      ],
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: phoneCtr,
                        // validator: (s) {
                        //   if (s == null || s.isEmpty) {
                        //     return '*Phone Number Required';
                        //   }
                        //   return null;
                        // },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: Language.phoneNumber.capitalizeByWord(),
                          fillColor: borderColor.withOpacity(.10),
                                prefixIcon: CountryCodePicker(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  onChanged: (country) {
                                    //print(country);
                                    addressBl.countryList.forEach((value) {
                                      if(value.phone_code == country.dialCode){
                                        _loadState(value);
                                        _countryModel = value;
                                     }
                                    });
                                    _phonCode = country.dialCode ?? '';

                                  },
                                  flagWidth: 35,
                                  initialSelection: 'CM',
                                  favorite: [],
                                  countryFilter: addressBl.countryList.isNotEmpty? addressBl.countryList.map((CountryModel value) => value.code).toList(): [],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                ),
                        ),
                      ),
                      if (addressState is AddressStateInvalidDataError) ...[
                        if (addressState.errorMsg.phone.isNotEmpty)
                          ErrorText(
                              text: addressState.errorMsg.phone.first),
                      ],
                      const SizedBox(height: 16),
                      _countryField(countries),
                      if (addressState is AddressStateInvalidDataError) ...[
                        if (addressState.errorMsg.country.isNotEmpty)
                          ErrorText(
                              text: addressState.errorMsg.country.first),
                      ],
                      const SizedBox(height: 16),
                      stateField(),
                      if (addressState is AddressStateInvalidDataError) ...[
                        if (addressState.errorMsg.state.isNotEmpty)
                          ErrorText(
                              text: addressState.errorMsg.state.first),
                      ],
                      const SizedBox(height: 16),
                      cityField(),
                      if (addressState is AddressStateInvalidDataError) ...[
                        if (addressState.errorMsg.city.isNotEmpty)
                          ErrorText(
                              text: addressState.errorMsg.city.first),
                      ],
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: addressCtr,
                        // validator: (s) {
                        //   if (s == null || s.isEmpty) return '*Address Required';
                        //   return null;
                        // },
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                          fillColor: borderColor.withOpacity(.10),
                          hintText: Language.address.capitalizeByWord(),
                        ),
                      ),
                      if (addressState is AddressStateInvalidDataError) ...[
                        if (addressState.errorMsg.address.isNotEmpty)
                          ErrorText(
                              text: addressState.errorMsg.address.first),
                      ],
                      const SizedBox(height: 16),
                      // TextFormField(
                      //   controller: zipCtr,
                      //   validator: (s) {
                      //     if (s == null || s.isEmpty) {
                      //       return '* Zip Code Required';
                      //     }
                      //     return null;
                      //   },
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     fillColor: borderColor.withOpacity(.10),
                      //     hintText: 'ZipCode',
                      //   ),
                      // ),
                      position != null ? AddressMap(position: position!) : SizedBox(height: 100),
                      LocationButton(text: Language.getDeviceLocation.capitalizeByWord(),
                        onPressed: () async {
                          setState(() {
                            position = null;
                          });
                          Position tmp = await KGeolocation.determinePosition();
                          setState(() {
                            position = new LatLng(tmp.latitude, tmp.longitude);
                          });
                          /*
                          Fluttertoast.showToast(
                            msg: Language.locationServicesAreDisabled,
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );*/
                        }),
                      SizedBox(height: 30),
                      PrimaryButton(
                        text: Language.addNewAddress.capitalizeByWord(),
                        onPressed: () {
                          // if (!_formkey.currentState!.validate()) return;

                          final dataMap = {
                            'name': nameCtr.text.trim(),
                            'email': emailCtr.text.trim(),
                            'phone': phoneCtr.text.trim(),
                            'phone_code': _phonCode!.trim(),                                  
                            'longitude': position!.longitude.toString(),
                            'latitude': position!.latitude.toString(),
                            'country': _countryModel != null
                                ? _countryModel!.id.toString()
                                : "",
                            'state': _countryStateModel != null
                                ? _countryStateModel!.id.toString()
                                : "",
                            'type': 'home',
                            'city': _cityModel != null
                                ? _cityModel!.id.toString()
                                : "",
                            // 'zip_code': zipCtr.text.trim(),
                            'address': addressCtr.text.trim(),
                          };
                          context.read<AddressCubit>().addAddress(dataMap);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _countryField(List<CountryModel> countries) {
    final addressBl = context.read<CountryStateByIdCubit>();
    if(_phonCode == null && addressBl.countryList.isNotEmpty){
      _phonCode = addressBl.countryList[0].phone_code;
    }
    if(_countryModel == null && addressBl.countryList.isNotEmpty){
      _countryModel = addressBl.countryList[0];
    }
    return DropdownButtonFormField<CountryModel>(
      value: _countryModel,
      hint: Text(Language.country.capitalizeByWord()),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          // borderSide: BorderSide(width: 1, color: CustomColors.lineColor),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onTap: () async {
        Utils.closeKeyBoard(context);
      },
      onChanged: (value) {
        if (value == null) return;
        _loadState(value);
      },
      // validator: (value) => value == null ? '*Country Required' : null,
      isDense: true,
      isExpanded: true,
      items: addressBl.countryList.isNotEmpty
          ? addressBl.countryList
              .map<DropdownMenuItem<CountryModel>>((CountryModel value) {
              return DropdownMenuItem<CountryModel>(
                  value: value, child: Text(value.name));
            }).toList()
          : null,
    );
  }

  Widget stateField() {
    final addressBl = context.read<CountryStateByIdCubit>();
    return DropdownButtonFormField<CountryStateModel>(
      value: _countryStateModel,
      hint: Text(Language.state.capitalizeByWord()),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          // borderSide: BorderSide(width: 1, color: CustomColors.lineColor),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onTap: () async {
        Utils.closeKeyBoard(context);
      },
      onChanged: (value) {
        if (value == null) return;
        // _cityModel = null;
        _countryStateModel = value;
        _loadCity(value);
        addressBl.cityStateChangeCityFilter(value);
      },
      // validator: (value) => value == null ? '*State Required' : null,
      isDense: true,
      isExpanded: true,
      items: addressBl.stateList.isNotEmpty
          ? addressBl.stateList.map<DropdownMenuItem<CountryStateModel>>(
              (CountryStateModel value) {
              return DropdownMenuItem<CountryStateModel>(
                  value: value, child: Text(value.name));
            }).toList()
          : null,
    );
  }

  Widget cityField() {
    final addressBl = context.read<CountryStateByIdCubit>();
    return DropdownButtonFormField<CityModel>(
      value: _cityModel,
      hint: Text(Language.city.capitalizeByWord()),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
      ),
      onTap: () {
        Utils.closeKeyBoard(context);
      },
      onChanged: (value) {
        _cityModel = value;
        if (value == null) return;
      },
      // validator: (value) => value == null ? '*City Required' : null,
      isDense: true,
      isExpanded: true,
      items: addressBl.cities.isNotEmpty
          ? addressBl.cities
              .map<DropdownMenuItem<CityModel>>((CityModel value) {
              return DropdownMenuItem<CityModel>(
                  value: value, child: Text(value.name));
            }).toList()
          : [],
    );
  }
}
