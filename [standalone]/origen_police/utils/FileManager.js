const fs = require('fs');

global.exports("GetFileList", (path) => {
    return fs.readdirSync(GetResourcePath("origen_police") + path);
});

global.exports("ReadFile", (path) => {
    return fs.readFileSync(GetResourcePath("origen_police") + path, 'utf8');
});

global.exports("CreateFile", (path, data) => {
    fs.writeFileSync(GetResourcePath("origen_police") + path, data);
});

global.exports("WriteFile", (path, data) => {
    fs.writeFileSync(GetResourcePath("origen_police") + path, data);
});

global.exports("DeleteFile", (path) => {
    fs.unlinkSync(GetResourcePath("origen_police") + path);
});