const fs = require('fs');
const i18n = JSON.parse(fs.readFileSync('./i18n.json'));

fs.mkdirSync('../i18n');
for (const lang in i18n) {
    if (!Object.hasOwnProperty.call(i18n, lang)) {
        continue;
    }
    const data = i18n[lang];
    const bufview = new TextEncoder().encode(JSON.stringify(data, null, 4));
    fs.writeFileSync(`../i18n/${lang}.i18n.json`, bufview);
}