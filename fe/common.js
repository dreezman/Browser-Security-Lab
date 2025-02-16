
// when document is loaded, find the parameters on the HTTP call
/*
Used like this
var op1 = decodeURI(getUrlParameter('op1'))
var op2 = decodeURI(getUrlParameter('op2'))
*/
function getUrlParameter(name) {
    return (location.search.split(name + '=')[1] || '').split('&')[0]
}

const apiConfigName = "apiConfig";
async function getConfig(file) {
  const response = await fetch(file);
  const configTemp = await response.json();
  const IFrameMap = new Map();
  let i = 0;
  while (i < configTemp.Iframes.length) {
    // console.log(configTemp.Iframes[i]);
    IFrameMap.set(configTemp.Iframes[i].apiName, configTemp.Iframes[i]);
    i++;
  }
  const mapArray = Array.from(IFrameMap);
  const jsonObject = Object.fromEntries(mapArray);
  const jsonConfig = JSON.stringify(jsonObject);
  localStorage.setItem(apiConfigName, jsonConfig);
}



getConfig("/config.json"); // data is stored in localstorage under "config"
const jsonConfig = JSON.parse(localStorage.getItem("apiConfig"));

