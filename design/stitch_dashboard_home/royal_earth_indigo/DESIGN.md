# Design System: Modern Heritage Luxe

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Digital Archivist."** 

This system moves beyond standard mobile layouts to create a high-end editorial experience that feels like a curated exhibition of India's soul. We are blending the weight of ancient stone and royal pigments with the ethereal precision of future-tech. 

To break the "template" look, we reject rigid grids in favor of **Intentional Asymmetry**. Hero sections should feature overlapping elements—such as a high-resolution site photograph partially obscured by a glassmorphic data card—to create a sense of physical depth. Typography is used as a structural element, where massive display scales contrast with delicate, high-precision labels to evoke an "Editorial Museum" aesthetic.

---

## 2. Colors: The Royal Earth Palette
Our palette is rooted in the deep stability of Indian history, punctuated by the vibrance of its festivals.

*   **Primary (Indigo):** `primary_container (#2e3192)` is our foundation. It represents the night sky over the Thar desert and the deep inks of ancient manuscripts. Use this for main surfaces where stability is required.
*   **Secondary (Terracotta):** `secondary (#ffb4a5)` and `secondary_container (#802918)` represent the baked earth of the Indus Valley. Use these for secondary supportive elements.
*   **Tertiary (Saffron):** `tertiary (#ffb77a)` is our "Spark." It is used sparingly for high-value accents, signifying the flame of knowledge and spiritual elevation.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to define sections. Boundaries must be established through tonal shifts. For example, a `surface_container_low` section should sit directly against a `surface` background. The change in luminance is the divider.

### The "Glass & Gradient" Rule
To achieve a "Luxe" feel, use **Glassmorphism** for floating overlays. Use `surface_variant` at 40% opacity with a `20px` backdrop blur. For main CTAs, do not use flat colors; apply a subtle linear gradient from `primary` to `primary_container` at a 135-degree angle to give the UI a "soul" and polished sheen.

---

## 3. Typography: Editorial Authority
We utilize a high-contrast pairing: **Noto Serif** for the historical weight of headers and **Manrope** for the technical precision of the interface.

*   **Display (L/M/S):** `notoSerif`. Use for site names (e.g., "Hampi"). These should use **Embossed Styling** (a 1px top-shadow at 20% opacity and a 1px bottom-highlight) to look carved into the interface.
*   **Headline (L/M/S):** `notoSerif`. Reserved for section titles. Use asymmetric tracking (-2%) to feel more premium.
*   **Title & Body:** `manrope`. This provides the "Modern Tech" balance. Body text should maintain a line height of 1.6x for maximum readability against dark backgrounds.
*   **Labels:** `manrope` (All Caps, +5% tracking). Use for metadata like "LAT/LONG" or "CONSTRUCTION YEAR" to mimic archival cataloging.

---

## 4. Elevation & Depth: Tonal Layering
In this system, depth is not "added"—it is "carved" or "stacked."

### The Layering Principle
Avoid shadows for structural separation. Instead, use the **Surface Tier Stack**:
1.  **Base:** `surface` (#131319)
2.  **Sectioning:** `surface_container_low` (#1b1b21)
3.  **Content Cards:** `surface_container` (#1f1f25)
4.  **Interactive Elements:** `surface_container_high` (#2a2930)

### Ambient Shadows
If an element must float (e.g., a Quick-Action Fab), use an **Ambient Tinted Shadow**. The shadow color must be a 10% opacity version of `on_surface` with a blur value of `24px`. Never use pure black shadows.

### Glassmorphism & Depth
For modal overlays and navigation bars, use `surface_container_lowest` at 60% opacity with a heavy backdrop blur. This allows the vibrant colors of site photography to bleed through the UI, making the app feel integrated into the heritage sites themselves.

---

## 5. Components

### Modern Skeuomorphic Buttons
Buttons are not flat. They should feel like "Jeweled Tech."
*   **Primary Button:** Gradient from `primary` to `primary_container`. Give it a `DEFAULT` (0.25rem) corner radius. Add a subtle inner-glow (top edge) to create a tactile, pressed-metal look.
*   **Secondary Button:** `surface_container_highest` with a `Ghost Border` (outline-variant at 20% opacity).

### Cards & Discovery Lists
*   **Rule:** Forbid divider lines. 
*   **Implementation:** Use a `1.5` (0.5rem) vertical spacing scale shift to separate list items. Cards for heritage sites should use a "Bleed" layout where the image takes up 100% of the card area, with text labels sitting on a glassmorphic strip at the bottom.

### Chips (Discovery Tags)
*   Use `surface_container_high` for unselected states.
*   Upon selection, transition to `tertiary` (Saffron) text with a `tertiary_container` background to signify "illumination."

### Signature Component: The "Heritage Compass"
A bespoke navigation element using a circular skeuomorphic dial. Use `outline_variant` for the dial ticks and `tertiary` for the active direction, blending the look of an ancient sundial with a futuristic HUD.

---

## 6. Do’s and Don’ts

### Do:
*   **DO** use whitespace as a luxury. Use the `12` (4rem) and `16` (5.5rem) spacing tokens to let hero images breathe.
*   **DO** use "Ghost Borders" (20% opacity) only when background colors are too similar for accessibility.
*   **DO** ensure all text on `tertiary` (Saffron) uses `on_tertiary` (Deep Brown/Black) for AAA contrast.

### Don’t:
*   **DON’T** use 100% opaque white text. Use `on_surface_variant` (#c7c5d4) for body text to reduce eye strain in Dark Mode.
*   **DON’T** use rounded corners larger than `xl` (0.75rem) for main containers; keep them sharp and architectural. Only use `full` for functional icons and chips.
*   **DON’T** use standard Material 3 "elevated" shadows. Stick to Tonal Layering or Ambient Tinted Shadows.