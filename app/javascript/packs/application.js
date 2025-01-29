// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"       // 正しいRailsのインポート
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "popper.js"
import 'bootstrap'
import "../stylesheets/application";

Rails.start()                      // 正しくRailsをスタート
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", function() {
  const buttons = document.querySelectorAll(".btn-warning");
  buttons.forEach(function(button) {
    button.addEventListener("click", function(event) {
      if (!confirm("準備申請を行いますか？この操作は取り消せません。")) {
        event.preventDefault();
      }
    });
  });
});
