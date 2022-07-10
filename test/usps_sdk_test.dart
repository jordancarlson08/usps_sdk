import 'package:usps_sdk/usps_sdk.dart';
import 'package:test/test.dart';
//TODO: Delete user ID before publishing
const String userID = "";

void main() {
  const String separator = "|------------------------------------------------------------------------------------|";
  USPSSdk uspsSdk = USPSSdk(userID: userID);
  test("Validate adress", ()async{
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
    print(separator);
  });
  test("ZIP Code Lookup API", ()async{
    USPSAddress response = await uspsSdk.zipCodeLookupAPI(
      address1: "SUITE K",
      address2: "29851 Aventura",
      state: "CA",
      zip5: "92688",
    );
    print(response.zip5);
    print(separator);
  });
  test("CityStateLookup API", ()async{
    USPSAddress response = await uspsSdk.cityStateLookup(
      zip5: 92688,
    );
    print(response.city);
    print(response.state);
    print(separator);
  });
  test("Domestic Rates Calculator", ()async{
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
    print(separator);
  });
  test("International Rates Calculator", ()async{
    try{
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
      print(response.postage);
      print(separator);
    }catch(error){
      if(error is USPSError){
        print("--------------------------------------------------");
        print("Error code: ${error.errorCode}");
        print("Error description ${error.description}");
        print("Error source: ${error.source}");
        print("--------------------------------------------------");
      }
    }
  });
  test("Tracking", ()async{
    try{
      String response = await uspsSdk.trackAndConfirm(
        trackID: "9305589674000215488420",
      );
      print(response);
      print(separator);
    }catch(error){
      if(error is USPSError){
        print("--------------------------------------------------");
        print("Error code: ${error.errorCode}");
        print("Error description ${error.description}");
        print("Error source: ${error.source}");
        print("--------------------------------------------------");
      }
    }
  });
}