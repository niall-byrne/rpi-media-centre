# STDLIB

Reusable standard library for bash.

## Loading STDLIB

```bash
source stdlib/__lib__.sh
```

## Library Features

### Standardized Function Return Codes

<!-- vale alex.Ablist = NO -->_

| status code | meaning                              |
|-------------|--------------------------------------|
| 0           | assertion is true                    |
| 1           | assertion is false                   |
| 126         | invalid argument types were provided |
| 127         | invalid argument count               |

<!-- alex.Ablist = YES -->

## Testing

The testing library is not loaded by default, should be sourced manually:

```bash
source stdlib/testing/__lib__.sh
```
