// Run against the built utility page served by Vite preview. No Tauri mocks.
// Requires the same optional Playwright test tooling as the other native QA scripts.
const { chromium } = require(process.env.COUCOU_QA_PLAYWRIGHT || 'playwright');
const assert = require('node:assert/strict');
const base = process.env.COUCOU_QA_URL || 'http://127.0.0.1:1425';
(async () => {
 const browser = await chromium.launch({...(process.env.COUCOU_QA_CHROMIUM ? {executablePath:process.env.COUCOU_QA_CHROMIUM} : {}),args:['--no-sandbox','--disable-dev-shm-usage']});
 let cases=0;
 try {
  for (const scale of [1,1.25,1.5,2]) {
   const page = await browser.newPage({viewport:{width:160,height:45},deviceScaleFactor:scale});
   for (const height of [8,32,45]) {
    await page.setViewportSize({width:160,height});
    await page.goto(`${base}/utility.html?kind=snap`);
    await page.locator('.snap').waitFor({state:'attached'});
    assert.equal(await page.locator('.snap').isVisible(),false,'Cold startup must draw nothing, even with a visible browser window');
    await page.evaluate(()=>document.documentElement.dataset.snapActive='true');
    assert.equal(await page.locator('.snap').isVisible(),true,'A valid edge can enable the marker');
    await page.evaluate(()=>{delete document.documentElement.dataset.snapActive});
    assert.equal(await page.locator('.snap').isVisible(),false,'Leaving the edge hides its drawing');
    await page.evaluate(()=>document.documentElement.dataset.snapActive='true');
    await page.reload();
    await page.locator('.snap').waitFor({state:'attached'});
    assert.equal(await page.locator('.snap').isVisible(),false,'A webview reload must reset stale marker state');
    cases++;
   }
   await page.close();
  }
  console.log(`PASS: ${cases} production-page size/DPI cases: startup, show, clear and reload.`);
 } finally { await browser.close(); }
})().catch(e=>{console.error(e);process.exitCode=1});
