# Over-the-air updates

Shipping JavaScript updates without App Store review using EAS Update.

## How OTA updates work

1. You make a JS/asset change (no native code changes)
2. Run `eas update` to publish the update
3. Users get the update on next app launch — no App Store/Play Store review

## Setup

```bash
eas update:configure
```

This adds the `expo-updates` config to your `app.json`.

## Publishing updates

```bash
# Update for all platforms
eas update --branch production --message "Fix login bug"

# Update for specific platform
eas update --branch production --platform ios --message "iOS-specific fix"
```

## Branches and channels

- **Branch:** A stream of updates (like a git branch)
- **Channel:** A deployment target mapped to a branch

```bash
# Map the production channel to the production branch
eas channel:edit production --branch production
```

## When OTA works vs when it doesn't

**OTA works for:**
- JavaScript code changes
- Asset changes (images, fonts)
- Configuration changes

**OTA does NOT work for:**
- Native module additions/changes
- `app.json` changes (name, icon, splash)
- SDK version upgrades
- New native permissions

For native changes, you need a full build via `eas build`.

## Best practices

- Use separate branches for staging and production
- Include a meaningful message with every update
- Test updates on staging before pushing to production
- Roll back quickly if an update causes issues: `eas update:rollback`
- Monitor crash rates after OTA updates
- Keep update sizes small — only changed files are downloaded
