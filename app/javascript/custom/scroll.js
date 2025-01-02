// 同時スクロール
document.addEventListener('DOMContentLoaded', () => {
    const scrollableElements = document.querySelectorAll('.scrollableChartWrapper');
    
    scrollableElements.forEach(masterElement => {
        masterElement.addEventListener('scroll', () => {
            const scrollLeft = masterElement.scrollLeft;

            scrollableElements.forEach(element => {
                if (element !== masterElement) {
                    element.scrollLeft = scrollLeft;
                }
            });
        });
    });
});