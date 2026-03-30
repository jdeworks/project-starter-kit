# Mobile testing

Testing strategies for mobile apps.

## Test layers

| Layer | What to test | Tools |
|-------|-------------|-------|
| **Unit** | Business logic, utilities, hooks | Jest / Vitest |
| **Component** | UI components render correctly | React Native Testing Library |
| **Integration** | Screens, navigation, API calls | React Native Testing Library + MSW |
| **E2E** | Full app flows on device/simulator | Detox / Maestro |

## Unit tests (example: React Native)

```javascript
import { calculateDiscount } from '../utils/pricing'

test('applies 10% discount for orders over $100', () => {
  expect(calculateDiscount(150)).toBe(15)
})

test('no discount for orders under $100', () => {
  expect(calculateDiscount(50)).toBe(0)
})
```

## Component tests

```javascript
import { render, screen } from '@testing-library/react-native'
import { ProductCard } from '../components/ProductCard'

test('displays product name and price', () => {
  render(<ProductCard name="Widget" price={29.99} />)
  expect(screen.getByText('Widget')).toBeTruthy()
  expect(screen.getByText('$29.99')).toBeTruthy()
})
```

## What to test vs skip

**Test:** Business logic, data transformations, custom hooks, form validation, API response handling, error states.

**Skip:** Styling, animations, third-party library internals, platform-specific rendering.

## Platform-specific testing

- Test on both iOS and Android simulators/emulators
- Pay attention to: keyboard behavior, gestures, navigation transitions, status bar
- Use `Platform.OS` checks sparingly — most code should be platform-agnostic

## Running tests

```bash
npm test            # Watch mode
npm run test:run    # CI mode (single run)
```
