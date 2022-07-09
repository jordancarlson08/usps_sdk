# United States Postal Service unofficial Software Development Kit

Hecho en 🇵🇷 por Radamés J. Valentín Reyes

## Import:

```dart
import 'package:usps_sdk/usps_sdk.dart';
```
## Getting Started
~~~dart
USPSSdk   uspsSdk = USPSSdk(userID: userID);
~~~
## SDK Functions

### Address Information
https://www.usps.com/business/web-tools-apis/address-information-api.pdf
- Verify
The Address/Standardization “Verify” API, which corrects errors in street addresses, including
abbreviations and missing information, and supplies ZIP Codes and ZIP Codes + 4. By eliminating address errors, you will improve overall package delivery service.
~~~dart
USPSAddress response = await uspsSdk.validate(
  address: USPSAddress(
    firmName: "",
    address1: "SUITE K",
    address2: "29851 Aventura",
    city: "",
    state: "CA",
    zip5: "92688",
    zip4: "",
  ),
);
print(response.state);
~~~
- ZIP Code Lookup API
The ZipCodeLookup API, which returns the ZIP Code and ZIP Code + 4 corresponding to the given
address, city, and state (use USPS state abbreviations).
~~~dart
USPSAddress  response = await uspsSdk.zipCodeLookupAPI(
  address1: "SUITE K",
  address2: "29851 Aventura",
  state: "CA",
  zip5: "92688",
);
~~~
- CityStateLookup API
City/State Lookup API returns the city and state corresponding to the given ZIP Code.
~~~dart
USPSAddress   response = await   uspsSdk.cityStateLookup(
  zip5: 92688,
);
print(response.city);
print(response.state);
~~~
### Track and Confirm
https://www.usps.com/business/web-tools-apis/track-and-confirm-api.pdf
### Rate Calculator
https://www.usps.com/business/web-tools-apis/rate-calculator-api.pdf
- Domestic Rates
The RateV4 API lets customers calculate the rate for domestic packages and envelopes given the weight and
dimensions of the item
~~~dart
DomesticRates response = await uspsSdk.domesticRates(
  uspsServiceType: USPSServiceType.priority, 
  zipOrigination: 32003, 
  zipDestination: 92688,
  uspsContainer: USPSContainer.flatRateEnvelope,
  pounds: 2,
  ounces: 0,
);
print(response.rate);
for(USPSSpecialService uspsSpecialService in response.availableServices){
  print("Available");
  print(uspsSpecialService.available);
  print("Price");
  print(uspsSpecialService.price);
  print("Service ID");
  print(uspsSpecialService.serviceID);
  print("Service Name");
  print(uspsSpecialService.serviceName);
  print("-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_");
}
~~~
- International Rates(Still does not work on this package)
The IntlRateV2 API lets customers calculate the rate for international packages and envelopes given the weight
and dimensions of the item.
~~~dart
String response = await uspsSdk.internationalRates(
  uspsServiceType: USPSServiceType.priority,
  zipOrigination: 32003,
  zipDestination: 2046,
  pounds: 2,
  ounces: 0,
  country: "Australia",
  acceptanceDateTime: DateTime.now(),
  utc: -4,
);
~~~
### eVS Label(Shipping Label)
https://www.usps.com/business/web-tools-apis/evs-label-api.pdf
### Package Pickup
https://www.usps.com/business/web-tools-apis/package-pickup-api.pdf

# Error catching
~~~dart
try{
  String  response = await  uspsSdk.trackAndConfirm(
      trackID: "9305589674000215488420",
  );
  print(response);
  }catch(error){
      if(error is USPSError){
      print("--------------------------------------------------");
      print("Error code: ${error.errorCode}");
      print("Error description ${error.description}");
      print("Error source: ${error.source}");
      print("--------------------------------------------------");
  }
}
~~~

# Donate
<a href="https://www.paypal.com/paypalme/onlinespawn"><img src="https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_74x46.jpg"/></a>
# References
- https://www.usps.com/business/web-tools-apis/documentation-updates.htm