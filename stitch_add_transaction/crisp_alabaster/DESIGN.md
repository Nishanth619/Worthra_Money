# Design System Strategy: Tactile Minimalism & The Editorial Surface

## 1. Overview & Creative North Star: "The Curated Gallery"
This design system is built upon the concept of **The Curated Gallery**. We are moving away from the "app-as-a-utility" aesthetic and toward a "digital editorial" experience. The goal is to make the user feel as though they are interacting with high-quality, heavy-weight paper stock arranged in a deliberate, spatial composition.

To achieve this, we reject the "bootstrap" look of boxes-within-boxes. Instead, we utilize **Intentional Asymmetry** and **Tonal Depth**. By leveraging extreme white space (using the `20` and `24` spacing tokens) and overlapping card elements, we create a sense of breathability and prestige. The interface doesn't just display data; it "presents" it.

---

## 2. Colors: Tonal Architecture
The palette is rooted in an ultra-clean foundation, using the Vibrant Emerald Green not just as a color, but as a "signal" of intent.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders (`#CCCCCC` or similar) to section off content. Boundaries must be defined solely through background color shifts. 
*   Use `surface` (#f8f9fa) for the main canvas.
*   Use `surface_container_lowest` (#ffffff) for primary cards.
*   The transition between these two hex codes provides enough contrast for the eye to perceive a boundary without the visual "noise" of a stroke.

### Surface Hierarchy & Nesting
Treat the UI as a physical stack. 
1.  **Base Layer:** `background` (#f8f9fa).
2.  **Sectional Layer:** `surface_container` (#edeeef) for grouping related content blocks.
3.  **Action Layer:** `surface_container_lowest` (#ffffff) for the actual interactive cards.
This nesting creates a "carved out" look that feels premium and structural.

### The Glass & Gradient Rule
To prevent the Emerald Green from feeling "flat," primary CTAs should utilize a subtle linear gradient: `primary` (#006c51) to `primary_container` (#10ac84) at a 135-degree angle. For floating navigation or headers, use **Glassmorphism**: apply `surface` colors at 80% opacity with a `backdrop-filter: blur(20px)`.

---

## 3. Typography: Editorial Authority
We utilize a dual-typeface system to balance character with readability.

*   **The Display Voice (Manrope):** Used for `display` and `headline` scales. Manrope’s geometric yet warm nature provides a modern, architectural feel. Use `display-lg` with tight letter-spacing (-0.02em) to create an authoritative, editorial header.
*   **The Functional Voice (Inter):** Used for `title`, `body`, and `label`. Inter provides maximum legibility for data-heavy sections. 
*   **Contrast as Hierarchy:** Ensure a stark contrast between `on_surface` (#191c1d) for headings and `on_surface_variant` (#3d4a43) for body text. This 20% drop in value guides the user's eye to the most important information first.

---

## 4. Elevation & Depth: The Stacking Principle
In this system, elevation is conveyed through **Tonal Layering** first, and **Ambient Shadows** second.

### Ambient Shadows
Shadows must never be "black." They should be "tinted air."
*   **Shadow Value:** Use the `on_surface` color (#191c1d) at 4% to 6% opacity.
*   **Diffusion:** Use a large blur radius (30px to 50px) with a small Y-offset (4px to 8px). This mimics a card sitting mere millimeters off a white desk, creating a tactile, "touchable" feel.

### The Ghost Border Fallback
If a boundary is required for accessibility (e.g., in a high-glare environment), use a **Ghost Border**:
*   Token: `outline_variant` (#bccac2)
*   Opacity: 15% 
*   Weight: 1px

---

## 5. Components: Tactile Primitives

### Buttons & FABs
*   **Primary:** Rounded `full` (9999px) or `xl` (1.5rem). Use the signature emerald gradient. 
*   **Secondary:** No background, `primary` (#006c51) text, and a `Ghost Border`.
*   **FAB:** Must use `primary_container` (#10ac84) with a high-diffusion ambient shadow to signal the highest level of the stack.

### Cards & Lists
*   **Rule:** Forbid divider lines. Use `spacing-6` (1.5rem) as a minimum vertical gap to separate list items. 
*   **Interactive Cards:** Use `ROUND_TWELVE` (1rem / `lg`) as the standard. On hover, transition the shadow from 4% to 8% opacity and shift the background to `surface_container_lowest`.

### Input Fields
*   **Style:** Minimalist. No bottom line or full box. Use a subtle `surface_container_low` (#f3f4f5) background with `ROUND_TWELVE` corners. On focus, the background shifts to `surface_container_lowest` (#ffffff) with a 1px `primary` Ghost Border.

---

## 6. Do's and Don'ts

### Do
*   **Do** use asymmetrical margins. For example, a `headline-lg` might have a 4rem left margin but only a 2rem right margin to create a "magazine" feel.
*   **Do** embrace white space. If a section feels crowded, increase the spacing token by two levels (e.g., move from `8` to `12`).
*   **Do** use `tertiary_container` (#e8776b) for destructive actions to maintain the "Soft Red" premium aesthetic without looking like a system error.

### Don't
*   **Don't** use pure black (#000000) anywhere. It breaks the "Alabaster" softness.
*   **Don't** use "Card-on-Card" patterns without changing the surface token. If a card is inside a section, the section should be `surface_container` and the card should be `surface_container_lowest`.
*   **Don't** use standard 4px or 8px corners. This system relies on the "Smooth Roundness" of `lg` (1rem) and `xl` (1.5rem) to feel organic.