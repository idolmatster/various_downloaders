let axios = require("axios");
const https = require('https'); // or 'https' for https:// URLs
const fs = require('fs');

let parser = require('really-relaxed-json').createParser();
async function main() {
    let url = 'https://cyberdrop.me/a/cktntNj1';
    downloadGallery(url);
}
main();

async function getGallery(url) {
    let gallery_xml = await getData(url);
    let gallery_name = await getName(gallery_xml);
    let gallery = await getImages(gallery_xml);
    return { gallery_arr: gallery, gallery_name: gallery_name }
}

async function downloadGallery(url) {
    let gallery = await getGallery(url)
    return download(await gallery);
}

async function getData(url) {
    let gallery = await axios.get(url);
    return await gallery.data;
}

async function getName(gallery_xml) {
    let gallery_name = gallery_xml.split('id=\"title\" class=\"title has-text-centered\" title=\"');
    gallery_name = gallery_name[1].split('\">');
    gallery_name = gallery_name[0];
    return await gallery_name;
}

async function getImages(gallery_xml) {
    gallery_xml = gallery_xml.split("dynamicEl: ")
    gallery_xml = gallery_xml[1].split('\n  })');
    gallery_xml = gallery_xml[0];
    let gallery_arr = parser.stringToJson(gallery_xml);
    gallery_arr = JSON.parse(gallery_arr);
    return gallery_arr;
}

async function download(gallery) {
    let { gallery_arr, gallery_name } = gallery;
    let dir = `./${gallery_name}`;
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir);
    } else { return };
    gallery_arr.forEach(photo => {
        let link = photo.downloadUrl;
        let fname = link.split('/');
        fname = fname[3];
        let fileWithDir = `${dir}/${fname}`
        let file = fs.createWriteStream(fileWithDir);
        https.get(link, function (response) {
            response.pipe(file);
        });
    });
}

module.exports.downloadGallery = downloadGallery;
module.exports.getGallery = getGallery;