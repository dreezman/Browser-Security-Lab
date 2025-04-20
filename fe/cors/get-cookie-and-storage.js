function getCookieAndStorage() {
    const cookies = document.cookie;
    const storage = sessionStorage.getItem('Username') + ":" + localStorage.getItem('Password');
    return { cookies, storage };
}
var cookie9443Storage = getCookieAndStorage()