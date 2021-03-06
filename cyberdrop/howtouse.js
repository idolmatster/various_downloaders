const cyberdrop = require('./cyberdrop');
main()
async function main() {
    console.log(await cyberdrop.getGallery('https://cyberdrop.me/a/cktntNj1'));
    cyberdrop.downloadGallery('https://cyberdrop.me/a/cktntNj1');
}
