document.addEventListener("DOMContentLoaded", function () {
  const searchInput = document.getElementById("search-input");
  const searchMessage = document.getElementById("search-message");
  const searchForm = document.getElementById("search-form");

  if (searchInput && searchMessage && searchForm) {
    // 検索ボックスにフォーカス時にメッセージ表示
    searchInput.addEventListener("focus", function () {
      searchMessage.style.display = "block";
    });

    // フォーカスが外れたときにメッセージを非表示（検索ボタンを押していない場合）
    searchInput.addEventListener("blur", function () {
      setTimeout(() => {
        searchMessage.style.display = "none";
      }, 200);
    });

    // 検索ボタンが押されたときに入力チェック
    searchForm.addEventListener("submit", function (event) {
      if (searchInput.value.trim() === "") {
        event.preventDefault(); // フォーム送信を防ぐ
        searchMessage.style.display = "block"; // メッセージを表示
        searchMessage.textContent = "検索ワードを入力してください。"; // メッセージを明確化
      }
    });
  }
});
