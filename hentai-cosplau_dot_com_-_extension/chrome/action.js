
const downloadGallary = (imageUrl) => {
    let title = document.title.split(" - ").slice(0, -2).join(' - ');
    let tmp1 = imageUrl.split("/");
    let tmp2 = tmp1[tmp1.length - 1].split(".");
    let number = tmp2[0];
    let baseurl = tmp1.slice(0, -1).join('/');

    for (let index = 1; index <= number; index++) {
        console.log(`${baseurl}/${index}.jpg`);
        chrome.downloads.download({
            url: `${baseurl}/${index}.jpg`,
            filename: `./${title}/${index}.jpg` // Optional
        });
    }
}

const copyImageUrlToClipboard = (info, tab) => {
    let imageUrl = info.srcUrl;

    if (imageUrl.includes("hentai-cosplays.com/"))
        return downloadGallary(imageUrl);
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
