const { test, expect } = require('@playwright/test');

test.describe('Home Page', () => {
  test('loads successfully', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveTitle(/Lorraine Lai/);
  });

  test('displays the name heading', async ({ page }) => {
    await page.goto('/');
    const heading = page.locator('h1');
    await expect(heading).toContainText('Lorraine Lai');
  });

  test('displays the tagline', async ({ page }) => {
    await page.goto('/');
    // The seed data includes a tagline
    const tagline = page.locator('p.italic');
    await expect(tagline).toBeVisible();
  });

  test('displays the about section', async ({ page }) => {
    await page.goto('/');
    const aboutHeading = page.locator('h2');
    await expect(aboutHeading).toContainText('About');
  });

  test('displays profile placeholder when no image', async ({ page }) => {
    await page.goto('/');
    // Should show initials LL in the placeholder circle
    const placeholder = page.getByText('LL', { exact: true });
    await expect(placeholder).toBeVisible();
  });

  test('displays navigation buttons', async ({ page }) => {
    await page.goto('/');
    await expect(page.getByRole('link', { name: 'Musings' })).toBeVisible();
    await expect(page.getByRole('link', { name: 'Gallery' })).toBeVisible();
  });

  test('has correct pastel background color', async ({ page }) => {
    await page.goto('/');
    const body = page.locator('body');
    // Check that the body has the warm-white background class
    await expect(body).toHaveClass(/bg-warm-white/);
  });
});

test.describe('Health Check', () => {
  test('rails health check works', async ({ page }) => {
    const response = await page.goto('/up');
    expect(response.status()).toBe(200);
  });
});
