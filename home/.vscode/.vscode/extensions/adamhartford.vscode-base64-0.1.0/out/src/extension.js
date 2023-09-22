'use strict';
var vscode = require('vscode');
var Window = vscode.window;
var Range = vscode.Range;
function activate(context) {
    console.log('vscode-base64" is now active');
    var encode = vscode.commands.registerCommand('extension.base64Encode', function () {
        var e = Window.activeTextEditor;
        var d = e.document;
        var sel = e.selections;
        base64Encode(e, d, sel);
    });
    var decode = vscode.commands.registerCommand('extension.base64Decode', function () {
        var e = Window.activeTextEditor;
        var d = e.document;
        var sel = e.selections;
        base64Decode(e, d, sel);
    });
    context.subscriptions.push(encode);
    context.subscriptions.push(decode);
}
exports.activate = activate;
function base64Encode(e, d, sel) {
    e.edit(function (edit) {
        sel.forEach(function (s) {
            var txt = d.getText(new Range(s.start, s.end));
            var b = new Buffer(txt);
            edit.replace(s, b.toString('base64'));
        });
    });
}
function base64Decode(e, d, sel) {
    e.edit(function (edit) {
        sel.forEach(function (s) {
            var txt = d.getText(new Range(s.start, s.end));
            var b = new Buffer(txt, 'base64');
            edit.replace(s, b.toString());
        });
    });
}
function deactivate() {
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map