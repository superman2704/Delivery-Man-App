
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/data/api/api_checker.dart';
import 'package:sixvalley_delivery_boy/features/splash/domain/models/config_model.dart';
import 'package:sixvalley_delivery_boy/features/splash/domain/services/splash_service_interface.dart';

class SplashController extends GetxController implements GetxService {
  final SplashServiceInterface splashServiceInterface;
  SplashController({required this.splashServiceInterface});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  BaseUrls? get baseUrls => _baseUrls;
  bool _firstTimeConnectionCheck = true;
  CurrencyList? _myCurrency;
  CurrencyList? _usdCurrency;
  CurrencyList? _defaultCurrency;
  CurrencyList? get myCurrency => _myCurrency;
  CurrencyList? get usdCurrency => _usdCurrency;
  CurrencyList? get defaultCurrency => _defaultCurrency;
  int? _currencyIndex;
  int? get currencyIndex => _currencyIndex;

  ConfigModel? get configModel => _configModel;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;




  Future<bool> getConfigData() async {
    Response response = await splashServiceInterface.getConfigData();
    bool _isSuccess = false;
    if(response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(response.body);
      _baseUrls = ConfigModel.fromJson(response.body).baseUrls;
      String? _currencyCode = splashServiceInterface.getCurrency();
      for(CurrencyList currencyList in _configModel!.currencyList!) {
        if(currencyList.id == _configModel!.systemDefaultCurrency) {
          if(_currencyCode == null || _currencyCode.isEmpty) {
            _currencyCode = currencyList.code;
          }
          _defaultCurrency = currencyList;
        }
        if(currencyList.code == 'USD') {
          _usdCurrency = currencyList;
        }
      }
      getCurrencyData(_currencyCode);
      _isSuccess = true;
    }else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    update();
    return _isSuccess;
  }





  void getCurrencyData(String? currencyCode) {
    for (var currency in _configModel!.currencyList!) {
      if(currencyCode == currency.code) {
        _myCurrency = currency;
        _currencyIndex = _configModel!.currencyList!.indexOf(currency);
        return;
      }
    }
  }




  void setCurrency(int index) {
    splashServiceInterface.setCurrency(_configModel!.currencyList![index].code!);
    getCurrencyData(_configModel!.currencyList![index].code);
    update();
  }

  Future<bool> initSharedData() {
    return splashServiceInterface.initSharedData();
  }

  Future<bool> removeSharedData() {
    return splashServiceInterface.removeSharedData();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  bool? showIntro() {
    return splashServiceInterface.showIntro();

  }
  bool? notificationSound() {
    return splashServiceInterface.notificationSound();


  }
  void disableIntro() {
    splashServiceInterface.disableIntro();
  }
  void disableNotification() {
    splashServiceInterface.disableNotification();
    update();
  }
  void enableNotification() {
    splashServiceInterface.enableNotification();
    update();
  }
}