WebFontConfig = {
  google: { families: [ 'Droid Sans:regular,bold' ] }
};
(function() {
  var wf = document.createElement('script');
  wf.src = ('https:' == document.location.protocol ? 'https' : 'http') +
      '://ajax.googleapis.com/ajax/libs/webfont/1/webfont.js';
  wf.type = 'text/javascript';
  wf.async = 'true';
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(wf, s);
})();

//////////////////////////////////////////////////

$(function() {
  // var editor = CodeMirror.fromTextArea($('form.page textarea')[0], {
  //   mode: "htmlmixed",
  //   lineNumbers: true,
  //   tabMode: 'indent'
  // });

  var editor = ace.edit("editor");
  var HTMLMode = require("ace/mode/html").Mode;

  editor.getSession().setMode(new HTMLMode());
});