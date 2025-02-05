document.addEventListener('turbo:load', function() {
  // ツールチップを有効にする全ての要素を取得
  var tooltipElements = document.querySelectorAll('[data-toggle="tooltip"]');

  tooltipElements.forEach(function(elem) {
    // マウスが要素に乗った時のイベント
    elem.addEventListener('mouseenter', function() {
      var tooltipText = this.getAttribute('data-tooltip-text') ||
        this.getAttribute('title');
      // var tooltipText = this.getAttribute('title');
      var tooltipDiv = document.createElement('div');
      tooltipDiv.className = 'custom-tooltip';
      tooltipDiv.innerText = tooltipText;

      // 要素の位置にツールチップを配置
      var rect = this.getBoundingClientRect();
      tooltipDiv.style.position = 'absolute';
      tooltipDiv.style.top = rect.top + window.scrollY + 'px';
      tooltipDiv.style.left = rect.left + window.scrollX + 'px';

      document.body.appendChild(tooltipDiv);

      // マウスが要素から離れたときのイベント
      this.addEventListener('mouseleave', function() {
        document.body.removeChild(tooltipDiv);
      }, {
        once: true
      });
    });
  });
});
