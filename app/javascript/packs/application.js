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

document.addEventListener("DOMContentLoaded", function () {
  document.querySelector("form").addEventListener("submit", function (event) {
    let searchInput = document.querySelector("input[name='search']");
    if (!searchInput.value.trim()) {
      event.preventDefault(); // フォーム送信を中止
      alert("検索ワードを入力してください"); // アラートを表示
    }
  });
});
// 管理者側の検索欄空白時のアラート
document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll("form").forEach(function (form) {
    form.addEventListener("submit", function (event) {
      let nameInput = form.querySelector("input[name='name']");
      let roleSelect = form.querySelector("select[name='role']");

      if (nameInput && !nameInput.value.trim() && roleSelect && !roleSelect.value.trim()) {
        event.preventDefault(); // フォーム送信を中止
        alert("検索ワードを入力してください"); // アラートを表示
      }
    });
  });
});
