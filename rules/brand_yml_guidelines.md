# Brand YAML (_brand.yml) Formatting and Styling Rules

These rules govern the creation, modification, and integration of company branding guidelines via `_brand.yml` files.

## 1. File Naming and Location
*   **Standard Filename**: Name the file `_brand.yml` (with a leading underscore).
*   **Location**: Place the `_brand.yml` file at the root of the project or application folder for auto-discovery by Shiny and Quarto.

## 2. Syntax Rules
*   **Hex Code Quotes**: Wrap all hex color values in double quotes (`"#0066cc"`).
*   **Indentation**: Use 2-space indentation.
*   **Order of References**: Define colors under `color.palette` before referencing them in semantic classes (e.g., `primary: brand-blue`).

## 3. Colors and Semantic Naming
*   **Bootstrap Color Aliases**: Define aliases for standard Bootstrap color names (e.g., `blue`, `red`, `green`, `teal`) to ensure automatic theming systems can map them correctly:
    ```yaml
    color:
      palette:
        brand-navy: "#003366"
        blue: brand-navy
      primary: blue
    ```
*   **Color Ranges**: For color shades/tints, define the midpoint color as the baseline for compatibility.

## 4. Typography and Fonts
*   **Font Definitions**: Declare all fonts in the `typography.fonts` list (with `family` and `source` fields) before using them in `base`, `headings`, or `monospace`.
*   **Google Fonts**: When using `source: google`, ensure the spelling of the font family matches Google Fonts exactly.

## 5. Assets and URLs
*   **Relative Paths**: Logo and icon paths (under the `logo` section) must be relative to the directory containing the `_brand.yml` file.
*   **URL Protocols**: All external logo, font source, or meta links must include the `https://` protocol.
