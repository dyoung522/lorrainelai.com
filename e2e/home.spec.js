const { test, expect } = require('@playwright/test');

test('home page loads successfully', async ({ page }) => {
  await page.goto('/');
  await expect(page).toHaveTitle(/Lorraine/);
});

test('home page displays welcome heading', async ({ page }) => {
  await page.goto('/');
  const heading = page.locator('h1');
  await expect(heading).toContainText('Welcome to Lorraine Lai');
});

test('home page displays description', async ({ page }) => {
  await page.goto('/');
  const description = page.locator('p');
  await expect(description).toContainText('Personal website and portfolio');
});

test('rails health check works', async ({ page }) => {
  const response = await page.goto('/up');
  expect(response.status()).toBe(200);
});
