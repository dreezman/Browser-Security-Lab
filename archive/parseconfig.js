const configold = `{
"Iframes": [
    {
      "frameName": "ParentIframe",
      "domainName": "localhost",
      "httpPort": "9081",
      "httpsPort": "9381",
      "fullHTTPURL": "http://localhost:9081",
      "fullHTTPSURL": "https://localhost:9381",
      "Description": "ParentFrame has port 9081 and TLS 9381"
    },
    {
      "frameName": "Iframe1",
      "domainName": "localhost",
      "httpPort": "3000",
      "httpsPort": "3300",
      "fullHTTPURL": "http://localhost:3000",
      "fullHTTPSURL": "https://localhost:3300",
      "Description":
        "Iframe1 has different origin as parent, port 3000 and TLS 3300"
    },
    {
      "frameName": "Iframe2",
      "domainName": "localhost",
      "httpPort": "3100",
      "httpsPort": "3400",
      "fullHTTPURL": "http://localhost:3001",
      "fullHTTPSURL": "https://localhost:3301",
      "Description":
        "Iframe2 has different origin as parent, port 3001 and TLS 3301"
    }
  ]
}`;
const fs = require("fs");

fs.readFile("./static/config.json", (err, inputD) => {
  if (err) throw err;
  console.log(inputD.toString());
});
config = inputD.toString();
let i = 0;
const IFrameMap = new Map();
const jsonConfig = JSON.parse(config);
while (i < jsonConfig.Iframes.length) {
  console.log(jsonConfig.Iframes[i]);
  IFrameMap.set(jsonConfig.Iframes[i].frameName, jsonConfig.Iframes[i]);
  i++;
}

IFrameMap.forEach(function (value, key) {
  let text = "";
  text += key + " = " + value;
  console.log("Values:" + text);
});
