const obj = require("./copy.json")

let name = [];
let { arr } = obj

arr.forEach(element => {
    if (name.includes(element.arg1)) {
        console.log(element);
    } else {
        name.push(element.arg1);
    }
});