#!/usr/bin/env node
var setup = {
        input: {
            core: "raphael.core.js",
            svg: "raphael.svg.js",
            vml: "raphael.vml.js",
            eve: "eve.js",
            copy: "copy.js"
        },
        output: {
            "build/raphael-min.js": function () {
                return this.copy + "\n" + minify(this.eve + this.core + this.svg + this.vml);
            },
            "build/raphael.js": function () {
                return this.copy + "\n" + this.eve + "\n\n" + this.core + "\n\n" + this.svg + "\n\n" + this.vml;
            },
            "build/raphael.pro-min.js": function () {
                return this.copy + "\n" + minify(this.eve + this.core + this.svg);
            },
            "build/raphael.pro.js": function () {
                return this.copy + "\n" + this.eve + "\n\n" + this.core + "\n\n" + this.svg ;
            }
        }
    },
    ujs = require("/Users/sroebuck/Documents/OpenSource/UglifyJS/uglify-js.js"),
    jsp = ujs.parser,
    pro = ujs.uglify,
    fs = require("fs"),
    rxdr = /\/\*\\[\s\S]+?\\\*\//g;

function minify(code) {
    return pro.gen_code(pro.ast_squeeze(pro.ast_mangle(jsp.parse(code))));
}

var files = {};
for (var file in setup.input) {
    files[file] = String(fs.readFileSync(setup.input[file], "utf8")).replace(rxdr, "");
}
fs.mkdir("build");
for (file in setup.output) {
    (function (file) {
        fs.writeFile(file, setup.output[file].call(files), function () {
            console.log("Saved to \033[32m" + file + "\033[0m\n");
        });
    })(file);
}