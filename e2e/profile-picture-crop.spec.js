const { test, expect } = require('@playwright/test');
const path = require('path');

test.describe('Profile Picture Cropping', () => {
  // Note: These tests require authentication. They will be skipped if not authenticated.
  // To fully test the cropping flow, run in headed mode with manual login.

  test('cropper interface appears when selecting an image', async ({ page }) => {
    await page.goto('/');

    // Check if we're signed in (Change Photo link should be visible on hover)
    const changePhotoLink = page.locator('text=Change Photo');

    // If not visible (not signed in), skip this test
    const isSignedIn = await changePhotoLink.isVisible({ timeout: 1000 }).catch(() => false);
    if (!isSignedIn) {
      test.skip('Not signed in - skipping authenticated test');
      return;
    }

    // Click to edit profile picture
    await changePhotoLink.click();

    // Wait for the form to appear
    await expect(page.locator('[data-controller="image-cropper"]')).toBeVisible();

    // File input should be present
    const fileInput = page.locator('input[type="file"][accept="image/*"]');
    await expect(fileInput).toBeAttached();

    // Set a test image file
    const testImagePath = path.join(__dirname, 'fixtures', 'test-image.png');
    await fileInput.setInputFiles(testImagePath);

    // Cropper container should become visible
    await expect(page.locator('[data-image-cropper-target="container"]')).toBeVisible();

    // Zoom buttons should be visible
    await expect(page.getByRole('button', { name: 'Zoom out' })).toBeVisible();
    await expect(page.getByRole('button', { name: 'Zoom in' })).toBeVisible();

    // Save and Cancel buttons should be visible
    await expect(page.getByRole('button', { name: 'Save' })).toBeVisible();
    await expect(page.getByRole('button', { name: 'Cancel' })).toBeVisible();
  });

  test('cancel button hides cropper interface', async ({ page }) => {
    await page.goto('/');

    const changePhotoLink = page.locator('text=Change Photo');
    const isSignedIn = await changePhotoLink.isVisible({ timeout: 1000 }).catch(() => false);
    if (!isSignedIn) {
      test.skip('Not signed in - skipping authenticated test');
      return;
    }

    await changePhotoLink.click();

    const fileInput = page.locator('input[type="file"][accept="image/*"]');
    const testImagePath = path.join(__dirname, 'fixtures', 'test-image.png');
    await fileInput.setInputFiles(testImagePath);

    // Wait for cropper to appear
    const cropperContainer = page.locator('[data-image-cropper-target="container"]');
    await expect(cropperContainer).toBeVisible();

    // Click Cancel
    await page.getByRole('button', { name: 'Cancel' }).click();

    // Cropper should be hidden
    await expect(cropperContainer).toBeHidden();
  });

  test('zoom buttons are accessible', async ({ page }) => {
    await page.goto('/');

    const changePhotoLink = page.locator('text=Change Photo');
    const isSignedIn = await changePhotoLink.isVisible({ timeout: 1000 }).catch(() => false);
    if (!isSignedIn) {
      test.skip('Not signed in - skipping authenticated test');
      return;
    }

    await changePhotoLink.click();

    const fileInput = page.locator('input[type="file"][accept="image/*"]');
    const testImagePath = path.join(__dirname, 'fixtures', 'test-image.png');
    await fileInput.setInputFiles(testImagePath);

    await expect(page.locator('[data-image-cropper-target="container"]')).toBeVisible();

    // Test that zoom buttons have accessible names
    const zoomOutButton = page.getByRole('button', { name: 'Zoom out' });
    const zoomInButton = page.getByRole('button', { name: 'Zoom in' });

    await expect(zoomOutButton).toBeVisible();
    await expect(zoomInButton).toBeVisible();

    // Click zoom buttons (should not throw)
    await zoomInButton.click();
    await zoomOutButton.click();
  });
});

test.describe('Profile Picture Cropping - Public View', () => {
  test('profile picture section is visible', async ({ page }) => {
    await page.goto('/');

    // Profile picture or placeholder should be visible
    const profileImage = page.getByAltText('Lorraine Lai');
    const placeholder = page.getByText('LL', { exact: true });

    const imageVisible = await profileImage.isVisible().catch(() => false);
    const placeholderVisible = await placeholder.isVisible().catch(() => false);

    expect(imageVisible || placeholderVisible).toBe(true);
  });
});
