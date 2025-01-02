document.addEventListener("turbo:load", function() {
  const charts = document.querySelectorAll('[data-chart-type="line"]');
    
  charts.forEach(canvas => {
    // データ属性から設定を取得
    const datasetLabel   = canvas.dataset.datasetLabel;
    const labels         = JSON.parse(canvas.dataset.labels);
    const data           = JSON.parse(canvas.dataset.data);
    const gradientColor1 = JSON.parse(canvas.dataset.gradientColor1);
    const gradientColor2 = JSON.parse(canvas.dataset.gradientColor2);

    // チャートサイズ調整
    const xAxisLabelMinWidth = 30;
    const width = labels.length * xAxisLabelMinWidth;
    
    canvas.style.width  = width < 1100 ? "100%" : `${width}px`;
    canvas.style.height = "150px";

    // グラデーション作成
    const ctx = canvas.getContext('2d');
    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(gradientColor1[0], gradientColor1[1]);
    gradient.addColorStop(gradientColor2[0], gradientColor2[1]);

    // ボーダーカラーを不透明度1に
    const solidBorderColor = gradientColor1[1].replace('0.7)', '1)');

    const chart = new Chart(ctx, {
      type: 'line',
      data: {
          labels: labels,
          datasets: [
              {
                  label: datasetLabel,
                  data: data,
                  borderWidth: 3,
                  borderColor: solidBorderColor,
                  tension: 0.4,
                  fill: true,
                  backgroundColor: gradient,
                  pointBackgroundColor: 'white',
                  pointBorderColor: solidBorderColor,
                  pointBorderWidth: 1,
                  pointRadius: 4,
                  // pointBorderColor: 'rgba(75, 192, 192, 1)',
                  // pointHoverRadius: 4
                  }
          ]
      },
      options: {
          responsive: false,
          plugins: {
              title: {
                  display: false,
              },
              legend: {
                  display: false,
              },
              tooltip: {
                enabled: true,
                callbacks: {
                    // ツールチップのタイトルを日本式にフォーマット
                    title: function(tooltipItems) {
                        if (tooltipItems.length > 0) {
                            const tooltipItem = tooltipItems[0];
                            const timestamp = tooltipItem.parsed.x;
                            const date = new Date(timestamp);
                            return date.toLocaleDateString('ja-JP', { dateStyle: 'short' });
                        }
                        return '';
                    },
                }
            }
          },
          scales: {
              x: {
                  display: true,
                  type: 'time',
                  time: {
                      unit: 'day',
                      displayFormats: {
                          day: 'MM/dd'
                      }
                  },
                  grid: {
                      color: "rgba(0,0,255,0.03)",
                      lineWidth: 1,
                  },
                  ticks: {
                      maxRotation: 0
                  }
              },
              y: {
                  suggestedMax: 5,
                  display: true,
                  beginAtZero: true,
                  ticks: {
                      display: false,
                      stepSize: 1,
                      maxTicksLimit: 20
                  },
                  grid: {
                      color: "rgba(0,0,255,0.1)",
                      lineWidth: 1,
                  }
              },
              }
          },
      }); 
  });
  // スクロールバーを右端にする（最新のデータを表示）
  setTimeout(() => {
    const scrollableWrappers = document.querySelectorAll('.scrollableChartWrapper');

    scrollableWrappers.forEach(wrapper => {
        wrapper.scrollLeft = wrapper.scrollWidth;
    });
  }, 100);
});
