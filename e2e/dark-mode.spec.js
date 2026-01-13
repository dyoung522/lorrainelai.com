// @ts-check
const { test, expect } = require('@playwright/test');

test.describe('Dark Mode', () => {
  test('theme toggle button is visible', async ({ page }) => {
    await page.goto('/');

    // Theme toggle should be visible
    const toggleButton = page.locator('button[title="Toggle dark mode"]');
    await expect(toggleButton).toBeVisible();
  });

  test('clicking toggle switches to dark mode', async ({ page }) => {
    await page.goto('/');

    // Initially should be in light mode (no .dark class)
    const html = page.locator('html');
    await expect(html).not.toHaveClass(/dark/);

    // Click the toggle button
    const toggleButton = page.locator('button[title="Toggle dark mode"]');
    await toggleButton.click();

    // Should now have .dark class
    await expect(html).toHaveClass(/dark/);
  });

  test('dark mode persists across page reload', async ({ page }) => {
    await page.goto('/');

    // Click toggle to enable dark mode
    const toggleButton = page.locator('button[title="Toggle dark mode"]');
    await toggleButton.click();

    // Verify dark mode is on
    await expect(page.locator('html')).toHaveClass(/dark/);

    // Reload the page
    await page.reload();

    // Dark mode should still be on
    await expect(page.locator('html')).toHaveClass(/dark/);
  });

  test('clicking toggle again switches back to light mode', async ({ page }) => {
    await page.goto('/');

    const toggleButton = page.locator('button[title="Toggle dark mode"]');
    const html = page.locator('html');

    // Click to enable dark mode
    await toggleButton.click();
    await expect(html).toHaveClass(/dark/);

    // Click again to disable dark mode
    await toggleButton.click();
    await expect(html).not.toHaveClass(/dark/);
  });

  test('sun icon shown in dark mode, moon icon in light mode', async ({ page }) => {
    await page.goto('/');

    const sunIcon = page.locator('svg[data-theme-target="sunIcon"]');
    const moonIcon = page.locator('svg[data-theme-target="moonIcon"]');

    // In light mode: moon visible, sun hidden
    await expect(moonIcon).toBeVisible();
    await expect(sunIcon).toBeHidden();

    // Toggle to dark mode
    const toggleButton = page.locator('button[title="Toggle dark mode"]');
    await toggleButton.click();

    // In dark mode: sun visible, moon hidden
    await expect(sunIcon).toBeVisible();
    await expect(moonIcon).toBeHidden();
  });
});
