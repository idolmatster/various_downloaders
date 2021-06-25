
const writeToClipboard = (str) => {
    let el = document.createElement("textarea")
    let success = false

    el.value = str
    document.body.append(el)
    el.select()
    success = document.execCommand("copy")
    el.remove()

    return success
        ? Promise.resolve(str)
        : Promise.reject(new Error("Unable to write to clipboard"))
}

const downloadGallary = (imageUrl, title) => {
    let tmp1 = imageUrl.split("/");
    let tmp2 = tmp1[tmp1.length - 1].split(".");
    let number = tmp2[0];
    let baseurl = tmp1.slice(0, -1).join('/');

    let gallery = { title, number, baseurl };
    let gallery_json = JSON.stringify(gallery);

    writeToClipboard(gallery_json);
}

const copyImageUrlToClipboard = (info, tab) => {
    let imageUrl = info.srcUrl;
    let title = tab.title.split(" - ").slice(0, -2).join(' - ');

    if (imageUrl.includes("hentai-cosplays.com/"))
        return downloadGallary(imageUrl, title);
    else
        return alert('that\'s the the wrong website, it\'s not going to work here')
}

chrome.contextMenus.create({
    title: "download imageseries",
    type: "normal",
    contexts: ["image"],
    enabled: true,
    onclick: copyImageUrlToClipboard
})
