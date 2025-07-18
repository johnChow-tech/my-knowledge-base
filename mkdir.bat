@echo off
:: =================================================================
::  Knowledge Base Initializer Script (V2)
::  Creates directory structure AND .gitkeep files for Git tracking.
:: =================================================================

echo Starting to create directory structure...
echo.

:: --- Creating all directories first ---
mkdir "01_Programming_Languages\JavaScript"
mkdir "02_Frontend_Development\HTML_And_CSS"
mkdir "02_Frontend_Development\Browser_APIs"
mkdir "03_Testing_and_QA\Cypress"
mkdir "03_Testing_and_QA\Playwright"
mkdir "03_Testing_and_QA\API_Testing"
mkdir "04_Tools_and_DevOps\Git"
mkdir "04_Tools_and_DevOps\GitHub_Actions"
mkdir "99_Problem_Solving_Log"

echo.
echo Creating .gitkeep files to ensure directories are tracked by Git...

:: --- Create .gitkeep files in the deepest directories ---
:: 'type NUL > file' is a command-line way to create an empty file in Windows.
type NUL > "01_Programming_Languages\JavaScript\.gitkeep"
type NUL > "02_Frontend_Development\HTML_And_CSS\.gitkeep"
type NUL > "02_Frontend_Development\Browser_APIs\.gitkeep"
type NUL > "03_Testing_and_QA\Cypress\.gitkeep"
type NUL > "03_Testing_and_QA\Playwright\.gitkeep"
type NUL > "03_Testing_and_QA\API_Testing\.gitkeep"
type NUL > "04_Tools_and_DevOps\Git\.gitkeep"
type NUL > "04_Tools_and_DevOps\GitHub_Actions\.gitkeep"
type NUL > "99_Problem_Solving_Log\.gitkeep"

echo.
echo =================================
echo  Structure with .gitkeep files created successfully!
echo =================================
echo.

pause