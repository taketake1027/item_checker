import Rails from "@rails/ujs"       
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "popper.js"
import 'bootstrap'
import "../stylesheets/application";

Rails.start()                     
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", function () {
  // 検索フォームの送信前チェック
  document.querySelectorAll("form").forEach(function (form) {
    form.addEventListener("submit", function (event) {
      // 検索入力のバリデーション
      let searchInput = form.querySelector("input[name='search']");
      if (searchInput && !searchInput.value.trim()) {
        event.preventDefault(); // フォーム送信を中止
        alert("検索ワードを入力してください"); // アラートを表示
      }

      // 管理者側の名前と役職のバリデーション
      let nameInput = form.querySelector("input[name='name']");
      let roleSelect = form.querySelector("select[name='role']");

      if (nameInput && !nameInput.value.trim() && roleSelect && !roleSelect.value.trim()) {
        event.preventDefault(); // フォーム送信を中止
        alert("検索ワードを入力してください"); // アラートを表示
      }
    });
  });
});
