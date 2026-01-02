package com.ganeshkulfi.app.presentation.theme

import android.app.Activity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.SideEffect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalView
import androidx.core.view.WindowCompat

private val LightColorScheme = lightColorScheme(
    primary = Saffron,
    onPrimary = Color.White,
    primaryContainer = SaffronLight,
    onPrimaryContainer = DeepBrownDark,
    
    secondary = DeepBrown,
    onSecondary = Color.White,
    secondaryContainer = DeepBrownLight,
    onSecondaryContainer = Color.White,
    
    tertiary = DeepBrownLight,
    onTertiary = Color.White,
    
    background = CreamLight,
    onBackground = DarkGray,
    
    surface = Color.White,
    onSurface = DarkGray,
    surfaceVariant = LightGray,
    onSurfaceVariant = NeutralGray,
    
    error = Error,
    onError = Color.White,
    errorContainer = Color(0xFFFFDAD6),
    onErrorContainer = Color(0xFF410002),
    
    outline = NeutralGray,
    outlineVariant = LightGray
)

private val DarkColorScheme = darkColorScheme(
    primary = SaffronDark,
    onPrimary = Color.White,
    primaryContainer = Saffron,
    onPrimaryContainer = DarkGray,
    
    secondary = DeepBrownLight,
    onSecondary = Color.White,
    secondaryContainer = DeepBrown,
    onSecondaryContainer = Color.White,
    
    tertiary = DeepBrown,
    onTertiary = Color.White,
    
    background = DarkGray,
    onBackground = CreamLight,
    
    surface = Color(0xFF1C1B1F),
    onSurface = CreamLight,
    surfaceVariant = Color(0xFF49454F),
    onSurfaceVariant = Color(0xFFCAC4D0),
    
    error = Error,
    onError = Color.White,
    
    outline = Color(0xFF938F99),
    outlineVariant = Color(0xFF49454F)
)

@Composable
fun KulfiDelightTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme
    
    val view = LocalView.current
    if (!view.isInEditMode) {
        SideEffect {
            val window = (view.context as Activity).window
            window.statusBarColor = colorScheme.primary.toArgb()
            WindowCompat.getInsetsController(window, view).isAppearanceLightStatusBars = !darkTheme
        }
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
