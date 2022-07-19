# United States Postal Service unofficial Software Development Kit

Hecho en 🇵🇷 por Radamés J. Valentín Reyes

## Account Registration/Creation
1. Go to https://www.usps.com/business/web-tools-apis/ and click the Register now button to get an API Key(user ID) e-mailed to you.
2. For additional access(things like tracking) create an account at https://gateway.usps.com/eAdmin/view/knowledge?securityId=MID
3. Send an email to uspscustomersupport@usps.gov with the details below(Instructions below were sent by them to my email) to request additional permissions like for example tracking API
~~~
I. Begin using USPS Web Tools  
Shippers using a third-party shipping software or shopping cart provider: Refer to your software provider for instructions to begin using USPS Web Tools. If your software prompts you for URLs to access the USPS APIs, please use the production URL below.  
  
Developers integrating Web Tools into a custom application:  
The following URL is the production URL you will use to access the Web Tools Servers:  
- https://secure.shippingapis.com/ShippingAPI.dll   
  
Step-by-Step Instructions for All USPS Web Tools (important information when getting started):  
- https://www.usps.com/business/web-tools-apis/general-api-developer-guide.pdf  
  
API User’s Guides (API specific technical/integration information):  
- https://www.usps.com/business/web-tools-apis/documentation-updates.htm   
  
USPS Web Tools website: (contains all these resources and more):  
- https://www.usps.com/business/web-tools-apis/welcome.htm
II. Request Additional API Permissions  
Additional API access and permissions are added separately. To obtain these permissions, contact our Internet Customer Care Center ([https://Emailus.usps.com/](https://emailus.usps.com/)) and include "Web Tools API Access" in the subject line. An agent will be happy to assist you.  
  
1\. To obtain Package Tracking API (API=TrackV2) access, users will need to contact the USPS Web Tools Program Office to request access and supply additional information for customer verification.  
        \- Note: This applies to both TrackV2 API simplified track requests (i.e., “TrackRequest”) and TrackV2 API detailed track requests (i.e., “TrackFieldRequest”).  
2\. Users should follow these steps to submit a request for Tracking APIs access:  
        \- Navigate to: https://usps.force.com/emailus/s/web-tools-inquiry. Provide user name (Web Tools User ID), select “Tracking APIs”, select “Track API” and submit the request with the following information below in the “Additional Information” text box:  
                • Web Tools UserID:  
                • Mailer ID (MID):  
                • Company Name:  
                • Requester First and Last Name:  
                • Requester Email:  
                • Requester Phone number:  
                • Mailing Address:  
                • Mailing City:  
                • Mailing State:  
                • Mailing Zip Code:  
                • PROD Registration Date:  
                • API access requested: Package Tracking (API=TrackV2)  
                • Anticipated volume:  
                • Any additional information from the customer:  
  
  
Shipping label API access requires eVS setup/enrollment.  
In general, eVS:  
\- Requires 50 pieces or 50 pounds per mailing  
\- Requires a permit imprint  
\- Requires payment via ACH debit daily (no other forms of payment)  
\- Handles origin entered mail (no destination entry or presort)  
\- Requires enrollment and new Mailer IDs (MIDs) and permits  
\- Will do domestic/international/APO/FPO/DPO/US Territories  
For registration please visit: https://www.usps.com/postalone/evs.htm. Contact [eVS@usps.gov](mailto:eVS@usps.gov) for support. If that will not work for you, then you can follow up with [sales@usps.gov](mailto:sales@usps.gov) (or your local Postmaster or USPS Sales Manager) for additional solutions outside of the Web Tools APIs.  
  
III. Troubleshoot/Additional Questions  
1\. Reference our FAQ document for common questions and concerns: https://www.usps.com/business/web-tools-apis/webtools-faqs.pdf   
2\. Contact your third-party software provider.  
3\. If still experiencing problems, our Internet Customer Care Center ([https://Emailus.usps.com/](https://emailus.usps.com/)) will investigate only if provided with the following:  
  \- Copy of a sample XML request resulting in the issue or error, pasted into the body of the email  
  \- Complete description of exact issue you are experiencing  
  \- Name of API  
  \- Name of third-party software provider
~~~
## Import library/package:

```dart
import 'package:usps_sdk/usps_sdk.dart';
```
## Getting Started
~~~dart
USPSSdk uspsSdk = USPSSdk(userID: userID);
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
- International Rates
The IntlRateV2 API lets customers calculate the rate for international packages and envelopes given the weight
and dimensions of the item.
~~~dart
InternationalRates response = await uspsSdk.internationalRates(
  uspsServiceType: USPSServiceType.priority, 
  zipOrigination: 32003, 
  pounds: 2, 
  ounces: 0, 
  width: 6,
  height: 6,
  length: 6,
  country: "Australia",
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