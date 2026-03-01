const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  page.setDefaultTimeout(60000);

  // 访问工信部备案查询系统
  await page.goto('https://beian.miit.gov.cn/');
  await page.waitForLoadState('networkidle');
  await page.waitForTimeout(5000);

  console.log('Page title:', await page.title());
  console.log('Current URL:', page.url());

  // 截图
  await page.screenshot({ path: '/Users/lifenghu/lobsterai/project/miit_beian.png' });

  const bodyText = await page.evaluate(() => document.body.innerText);
  console.log('页面内容:');
  console.log(bodyText.substring(0, 2000));

  await browser.close();
})();
