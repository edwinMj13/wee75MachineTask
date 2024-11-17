const apiKey = "&apikey=SEUDKMOSJ5PR8VFH";  //NEYQQHZ9DSWP6SKC

const baseUrl = "https://www.alphavantage.co/query?";

const urlSearchFunctions = "function=SYMBOL_SEARCH";
const urlGetCompanyFunctions = "function=TIME_SERIES_DAILY";

const urlCompany = "&symbol=";

const urlOutputSize = "&outputsize=compact";

const urlKeywords = "&keywords=";
const rupeeSymbol = "₹";

// url to get Company  https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=TATACHEM.BSE&outputsize=compact&apikey=M91WRHVOU217QROZ
 //final response =  http.get(Uri.parse("$baseUrl$urlGetCompanyFunctions$urlCompany$companyNames$urlOutputSize$apiKey"));
//final response = await http.get(Uri.parse("$baseUrl$urlSearchFunctions$urlKeywords$tag$apiKey"));
// https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=&apikey=SEUDKMOSJ5PR8VFH
//NEYQQHZ9DSWP6SKC