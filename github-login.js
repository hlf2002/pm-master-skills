const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();
  await page.goto('https://github.com/login');
  console.log('GitHub login page opened');

  // Wait for user to login
  await page.waitForTimeout(300000); // 5 minutes
  await browser.close();
})();
