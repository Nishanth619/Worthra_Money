# Design System Document: The Editorial Sanctuary

## 1. Overview & Creative North Star

**Creative North Star: The Silent Ledger**
This design system moves away from the cluttered, anxiety-inducing interfaces typical of fintech. Instead, it adopts the persona of a "High-End Digital Ledger"—a space that feels as intentional and calm as a boutique hotel lobby. We achieve this through **Editorial Minimalism**: a philosophy where whitespace is an active element, not a void, and where information density is sacrificed for clarity and "breathing room."

To break the "template" look, we utilize **Intentional Asymmetry**. Rather than centering everything, we use the `display-lg` typography to anchor views off-center, creating a rhythmic flow that feels like a premium print magazine. We avoid the rigid, boxed-in feel of standard apps by using overlapping layers and shifts in tonal depth to define structure.

---

## 2. Colors

Our palette is rooted in the depth of a moonless night, using `surface` (`#131313`) and `surface_container_lowest` (`#0e0e0e`) to create infinite depth.

### The "No-Line" Rule
**Explicit Instruction:** You are prohibited from using 1px solid borders to section off content. 
Boundaries must be defined solely through background color shifts or subtle tonal transitions. For example, a transaction history section should not be separated by a line; instead, the section should sit on `surface_container_low` against the `surface` background.

### Surface Hierarchy & Nesting
Treat the UI as physical layers of fine paper. 
- **Base Layer:** `surface` (`#131313`)
- **Primary Content Area:** `surface_container` (`#201f1f`)
- **Elevated Cards:** `surface_container_high` (`#2a2a2a`)
- **Interaction/Nested Elements:** `surface_container_highest` (`#353534`)

By nesting `surface_container_high` inside a `surface_container` section, you create a soft, natural lift that communicates hierarchy without visual noise.

### The "Glass & Gradient" Rule
To elevate the "Premium" feel, use **Glassmorphism** for floating action buttons or navigation bars. Use `surface_container` at 80% opacity with a `backdrop-blur` of 20px. 

### Signature Textures
For main CTAs (like "Add Income"), do not use a flat color. Apply a subtle linear gradient from `primary` (`#4edea3`) to `primary_container` (`#10b981`) at a 135-degree angle. This provides a "soul" and metallic luster that flat hex codes lack.

---

## 3. Typography

The typography strategy relies on the contrast between the authoritative **Manrope** and the functional **Inter**.

- **Display & Headlines (Manrope):** These are your "Editorial" voices. Use `display-lg` for total balance amounts. The generous tracking and geometric shapes of Manrope convey a sense of modern wealth and stability.
- **Titles & Body (Inter):** Inter handles the "Data." Use `title-md` for transaction names and `body-md` for descriptions. 
- **The Power of Scale:** By placing a `display-lg` value ($12,450.00) next to a `label-sm` ("TOTAL BALANCE"), the massive contrast in scale creates an immediate focal point, eliminating the need for bold colors or heavy icons.

---

## 4. Elevation & Depth

We reject traditional shadows in favor of **Tonal Layering**.

- **The Layering Principle:** Depth is achieved by "stacking." Place a `surface_container_lowest` card on a `surface_container_low` section. This creates a "sunken" or "carved" effect that feels integrated into the interface rather than hovering over it.
- **Ambient Shadows:** If a card must float (e.g., a modal), use a shadow with a 40px blur, 0% spread, and 6% opacity. The shadow color must be a tinted version of `on_surface` (a soft off-white/grey) rather than pure black, mimicking how light interacts with dark materials.
- **The "Ghost Border" Fallback:** If a container lacks sufficient contrast against its background, use a **Ghost Border**: `outline_variant` at 15% opacity. Never use a 100% opaque border.

---

## 5. Components

### Buttons
- **Primary:** Gradient (`primary` to `primary_container`), `xl` (1.5rem) roundedness. Typography: `title-sm` in `on_primary`.
- **Secondary:** Surface-based. Use `surface_container_highest` background with `on_surface` text.
- **Tertiary/Ghost:** No background. Use `primary` text for "success" actions and `secondary` (coral) for "cautionary" actions.

### Cards & Lists
- **Strict Rule:** Forbid divider lines.
- **Implementation:** Separate list items using the Spacing Scale `3` (1rem). Use a subtle background shift (`surface_container_low`) on every other item, or simply allow the typography to create the rhythm.
- **Rounding:** All cards must use `xl` (1.5rem) roundedness to mimic the premium feel of iOS hardware.

### Input Fields
- **Styling:** Use the `surface_container_lowest` for the field background. 
- **Focus State:** Instead of a thick border, use a `primary` "Ghost Border" (20% opacity) and slightly increase the `surface_bright` level of the background.

### Custom Component: The "Wealth Arc"
A bespoke progress ring for budget tracking. Use `primary` for the stroke, but set the "track" to `surface_container_highest`. Apply a subtle glow (outer shadow) to the tip of the progress bar using the `primary` color at 30% opacity.

---

## 6. Do's and Don'ts

### Do
- **Do** use `display-lg` for monetary values. Let the numbers be the hero of the design.
- **Do** use `secondary` (soft coral) for all "outgoing" money or expense categories to create a consistent mental model.
- **Do** use `primary` (emerald) for "incoming" money and success states.
- **Do** embrace "Negative Space." If a screen feels empty, increase the spacing between elements using the `8` (2.75rem) or `10` (3.5rem) tokens rather than adding more decoration.

### Don't
- **Don't** use pure white (`#FFFFFF`) for text. Always use `on_surface` (`#e5e2e1`) to reduce eye strain in the dark theme.
- **Don't** use standard 4px or 8px corners. Stick to the `xl` (1.5rem) and `lg` (1rem) tokens to maintain the high-end iOS aesthetic.
- **Don't** use icons as primary navigators. Use high-contrast typography combined with subtle icons to maintain an editorial feel.
- **Don't** ever use a solid 1px divider line. Use a `3` (1rem) spacing gap instead.