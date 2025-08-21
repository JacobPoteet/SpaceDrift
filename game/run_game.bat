@echo off
echo Starting Space Exploration Game...
echo.
echo Make sure Love2D is installed and in your PATH
echo.
echo Controls:
echo - Drag window to explore space
echo - Resize window edges to change view
echo - R key: Regenerate world
echo - Space: Toggle pause
echo - Escape: Quit game
echo.
echo Press any key to start...
pause >nul

love .

echo.
echo Game finished.
pause
