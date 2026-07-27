@echo off
chcp 65001 >nul
mode con:cols=78 lines=26
color 0A
setlocal EnableExtensions EnableDelayedExpansion

:: Standalone Module Parameters
set "TOOLBOX_VER=v0.35"
set "MODULE_NAME=Morphs_Creations_Image_Generation"
set "T_Dir=%~dp0ToolboxData"
set "Out_Dir=%T_Dir%\GeneratedImages"
set "PS_Engine=%T_Dir%\AIGenEngine.ps1"

:: Default Model Configuration
set "SELECTED_MODEL=nanobanana"
set "MODEL_DISPLAY=Nano Banana (Google Gemini Flash)"

:: Default Aspect Ratio & Resolution Configuration
set "SELECTED_AR=16:9"
set "SELECTED_TIER=1080p"
set "SELECTED_ENHANCE=true"
set "ENHANCE_DISPLAY=ON (AI Post-Upscale)"
set "SELECTED_STYLE=MASTERPIECE"
set "STYLE_DISPLAY=Masterpiece 8K ^& Micro-Detail"
set "IMG_WIDTH=1920"
set "IMG_HEIGHT=1080"

if not exist "%T_Dir%" mkdir "%T_Dir%"
if not exist "%Out_Dir%" mkdir "%Out_Dir%"

:: Step 0: Deploy Fresh Sub-Engine File to Disk
call :Ensure_Engine_Script

:: Startup Animated Multi-Color Header Rendering
cls
powershell -ExecutionPolicy Bypass -Command "$colors=@('Cyan','Green','Magenta','Yellow','White','DarkCyan'); $logo=@('        ßßß    ßßß   ßßßßßß   ßßßßßß   ßßßßßß   ßß   ßß  ßßßßßßß','        ßßßß  ßßßß  ßß    ßß  ßß   ßß  ßß   ßß  ßß   ßß  ßß     ','        ßß ßßßß ßß  ßß    ßß  ßßßßßß   ßßßßßß   ßßßßßßß  ßßßßßßß','        ßß  ßß  ßß  ßß    ßß  ßß   ßß  ßß       ßß   ßß       ßß','        ßß      ßß   ßßßßßß   ßß   ßß  ßß       ßß   ßß  ßßßßßßß',' ','   ßßßßßß  ßßßßßß  ßßßßßßß   ßßßßß  ßßßßßßßß  ßß  ßßßßßß  ßßß    ßß  ßßßßßßß','  ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßßßß   ßß  ßß     ','  ßß       ßßßßßß  ßßßßßßß  ßßßßßßß    ßß     ßß ßß    ßß ßß ßß  ßß  ßßßßßßß','  ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßß  ßß ßß       ßß','   ßßßßßß  ßß   ßß ßßßßßßß  ßß   ßß    ßß     ßß  ßßßßßß  ßß   ßßßß  ßßßßßßß'); foreach ($line in $logo) { if ($line.Trim().Length -eq 0) { Write-Host ''; continue }; [char[]]$chars = $line.ToCharArray(); foreach ($c in $chars) { if ($c -eq 'ß') { $color = Get-Random -InputObject $colors; Write-Host $c -ForegroundColor $color -NoNewline } else { Write-Host $c -NoNewline } }; Write-Host '' }"
echo.
timeout /t 2 >nul

:AI_Image_Menu
call :Recalculate_Dimensions
cls
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo.
echo         ßßß    ßßß   ßßßßßß   ßßßßßß   ßßßßßß   ßß   ßß  ßßßßßßß
echo         ßßßß  ßßßß  ßß    ßß  ßß   ßß  ßß   ßß  ßß   ßß  ßß     
echo         ßß ßßßß ßß  ßß    ßß  ßßßßßß   ßßßßßß   ßßßßßßß  ßßßßßßß
echo         ßß  ßß  ßß  ßß    ßß  ßß   ßß  ßß       ßß   ßß       ßß
echo         ßß      ßß   ßßßßßß   ßß   ßß  ßß       ßß   ßß  ßßßßßßß
echo.
echo  ßßßßßß  ßßßßßß  ßßßßßßß   ßßßßß  ßßßßßßßß  ßß  ßßßßßß  ßßß    ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßßßß   ßß  ßß     
echo ßß       ßßßßßß  ßßßßßßß  ßßßßßßß    ßß     ßß ßß    ßß ßß ßß  ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßß  ßß ßß       ßß
echo  ßßßßßß  ßß   ßß ßßßßßßß  ßß   ßß    ßß     ßß  ßßßßßß  ßß   ßßßß  ßßßßßßß
echo.
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo ============================================================================
echo         %MODULE_NAME% [%TOOLBOX_VER%]      
echo ============================================================================
echo.
echo [1] Generate New AI Image
echo [2] AI Model Engine    (Active: %MODEL_DISPLAY%)
echo [3] Aspect Ratio       (Active: %SELECTED_AR%)
echo [4] Resolution Quality (Active: %SELECTED_TIER% - %IMG_WIDTH%x%IMG_HEIGHT% PNG)
echo [5] Detail Preset      (Active: %STYLE_DISPLAY%)
echo [6] AI Detail Enhancer (Active: %ENHANCE_DISPLAY%)
echo [7] Open Output Directory
echo [8] Exit Module
echo.
echo ============================================================================
set /p "user_choice=Select an option [1-8]: "

if "%user_choice%"=="1" goto :Generate_Image_Routine
if "%user_choice%"=="2" goto :Select_Model_Menu
if "%user_choice%"=="3" goto :Select_Aspect_Ratio_Menu
if "%user_choice%"=="4" goto :Select_Resolution_Menu
if "%user_choice%"=="5" goto :Select_Style_Menu
if "%user_choice%"=="6" (
    if "%SELECTED_ENHANCE%"=="true" (
        set "SELECTED_ENHANCE=false"
        set "ENHANCE_DISPLAY=OFF"
    ) else (
        set "SELECTED_ENHANCE=true"
        set "ENHANCE_DISPLAY=ON (AI Post-Upscale)"
    )
    goto :AI_Image_Menu
)
if "%user_choice%"=="7" (
    start "" "%Out_Dir%"
    goto :AI_Image_Menu
)
if "%user_choice%"=="8" exit /b 0

echo.
echo [!] Invalid selection. Please choose a valid option.
timeout /t 2 >nul
goto :AI_Image_Menu

:Select_Style_Menu
cls
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo.
echo         ßßß    ßßß   ßßßßßß   ßßßßßß   ßßßßßß   ßß   ßß  ßßßßßßß
echo         ßßßß  ßßßß  ßß    ßß  ßß   ßß  ßß   ßß  ßß   ßß  ßß     
echo         ßß ßßßß ßß  ßß    ßß  ßßßßßß   ßßßßßß   ßßßßßßß  ßßßßßßß
echo         ßß  ßß  ßß  ßß    ßß  ßß   ßß  ßß       ßß   ßß       ßß
echo         ßß      ßß   ßßßßßß   ßß   ßß  ßß       ßß   ßß  ßßßßßßß
echo.
echo  ßßßßßß  ßßßßßß  ßßßßßßß   ßßßßß  ßßßßßßßß  ßß  ßßßßßß  ßßß    ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßßßß   ßß  ßß     
echo ßß       ßßßßßß  ßßßßßßß  ßßßßßßß    ßß     ßß ßß    ßß ßß ßß  ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßß  ßß ßß       ßß
echo  ßßßßßß  ßß   ßß ßßßßßßß  ßß   ßß    ßß     ßß  ßßßßßß  ßß   ßßßß  ßßßßßßß
echo.
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo ============================================================================
echo                 SELECT DETAIL ^& STYLE PRESET [%TOOLBOX_VER%]               
echo ============================================================================
echo.
echo [1] Masterpiece 8K ^& Micro-Detail (Sharp Scales, Intricate Art) [DEFAULT]
echo [2] Photorealistic RAW 8K Camera (35mm DSLR, Sharp Focus)
echo [3] Cinematic Octane 8K Render (Unreal Engine 5, Raytracing)
echo [4] Dark Fantasy Masterwork (Sharp Line Art, Dark Aesthetic)
echo [5] Raw User Prompt Only (No Extra Quality Modifiers)
echo [6] Back to Main Menu
echo.
echo ============================================================================
set /p "style_choice=Choose Style Preset [1-6]: "

if "%style_choice%"=="1" (
    set "SELECTED_STYLE=MASTERPIECE"
    set "STYLE_DISPLAY=Masterpiece 8K ^& Micro-Detail"
    goto :AI_Image_Menu
)
if "%style_choice%"=="2" (
    set "SELECTED_STYLE=PHOTOREAL"
    set "STYLE_DISPLAY=Photorealistic RAW 8K Camera"
    goto :AI_Image_Menu
)
if "%style_choice%"=="3" (
    set "SELECTED_STYLE=CINEMATIC"
    set "STYLE_DISPLAY=Cinematic Octane 8K Render"
    goto :AI_Image_Menu
)
if "%style_choice%"=="4" (
    set "SELECTED_STYLE=DARK_FANTASY"
    set "STYLE_DISPLAY=Dark Fantasy Masterwork"
    goto :AI_Image_Menu
)
if "%style_choice%"=="5" (
    set "SELECTED_STYLE=OFF"
    set "STYLE_DISPLAY=Raw Prompt Only"
    goto :AI_Image_Menu
)
if "%style_choice%"=="6" goto :AI_Image_Menu

echo.
echo [!] Invalid selection. Retrying...
timeout /t 2 >nul
goto :Select_Style_Menu

:Select_Model_Menu
cls
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo.
echo         ßßß    ßßß   ßßßßßß   ßßßßßß   ßßßßßß   ßß   ßß  ßßßßßßß
echo         ßßßß  ßßßß  ßß    ßß  ßß   ßß  ßß   ßß  ßß   ßß  ßß     
echo         ßß ßßßß ßß  ßß    ßß  ßßßßßß   ßßßßßß   ßßßßßßß  ßßßßßßß
echo         ßß  ßß  ßß  ßß    ßß  ßß   ßß  ßß       ßß   ßß       ßß
echo         ßß      ßß   ßßßßßß   ßß   ßß  ßß       ßß   ßß  ßßßßßßß
echo.
echo  ßßßßßß  ßßßßßß  ßßßßßßß   ßßßßß  ßßßßßßßß  ßß  ßßßßßß  ßßß    ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßßßß   ßß  ßß     
echo ßß       ßßßßßß  ßßßßßßß  ßßßßßßß    ßß     ßß ßß    ßß ßß ßß  ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßß  ßß ßß       ßß
echo  ßßßßßß  ßß   ßß ßßßßßßß  ßß   ßß    ßß     ßß  ßßßßßß  ßß   ßßßß  ßßßßßßß
echo.
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo ============================================================================
echo                 SELECT AI MODEL ENGINE [%TOOLBOX_VER%]                     
echo ============================================================================
echo.
echo [1] Nano Banana (Google Gemini Flash Image)  [DEFAULT]
echo [2] FLUX.1 Schnell (Black Forest Labs)
echo [3] FLUX Realism (Photorealistic Fine-Tune)
echo [4] FLUX Anime (Anime ^& Manga Style)
echo [5] FLUX 3D (3D Digital Render Style)
echo [6] Midjourney Style Engine
echo [7] Turbo Diffusion (Ultra Fast)
echo [8] GPT Image (OpenAI Engine)
echo [9] Back to Main Menu
echo.
echo ============================================================================
set /p "model_choice=Choose model engine [1-9]: "

if "%model_choice%"=="1" (
    set "SELECTED_MODEL=nanobanana"
    set "MODEL_DISPLAY=Nano Banana (Google Gemini Flash)"
    goto :AI_Image_Menu
)
if "%model_choice%"=="2" (
    set "SELECTED_MODEL=flux"
    set "MODEL_DISPLAY=FLUX.1 Schnell"
    goto :AI_Image_Menu
)
if "%model_choice%"=="3" (
    set "SELECTED_MODEL=flux-realism"
    set "MODEL_DISPLAY=FLUX Realism"
    goto :AI_Image_Menu
)
if "%model_choice%"=="4" (
    set "SELECTED_MODEL=flux-anime"
    set "MODEL_DISPLAY=FLUX Anime Style"
    goto :AI_Image_Menu
)
if "%model_choice%"=="5" (
    set "SELECTED_MODEL=flux-3d"
    set "MODEL_DISPLAY=FLUX 3D Render"
    goto :AI_Image_Menu
)
if "%model_choice%"=="6" (
    set "SELECTED_MODEL=midjourney"
    set "MODEL_DISPLAY=Midjourney Style Engine"
    goto :AI_Image_Menu
)
if "%model_choice%"=="7" (
    set "SELECTED_MODEL=turbo"
    set "MODEL_DISPLAY=Turbo Diffusion"
    goto :AI_Image_Menu
)
if "%model_choice%"=="8" (
    set "SELECTED_MODEL=gptimage"
    set "MODEL_DISPLAY=GPT Image (OpenAI)"
    goto :AI_Image_Menu
)
if "%model_choice%"=="9" goto :AI_Image_Menu

echo.
echo [!] Invalid selection. Retrying...
timeout /t 2 >nul
goto :Select_Model_Menu

:Select_Aspect_Ratio_Menu
cls
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo.
echo         ßßß    ßßß   ßßßßßß   ßßßßßß   ßßßßßß   ßß   ßß  ßßßßßßß
echo         ßßßß  ßßßß  ßß    ßß  ßß   ßß  ßß   ßß  ßß   ßß  ßß     
echo         ßß ßßßß ßß  ßß    ßß  ßßßßßß   ßßßßßß   ßßßßßßß  ßßßßßßß
echo         ßß  ßß  ßß  ßß    ßß  ßß   ßß  ßß       ßß   ßß       ßß
echo         ßß      ßß   ßßßßßß   ßß   ßß  ßß       ßß   ßß  ßßßßßßß
echo.
echo  ßßßßßß  ßßßßßß  ßßßßßßß   ßßßßß  ßßßßßßßß  ßß  ßßßßßß  ßßß    ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßßßß   ßß  ßß     
echo ßß       ßßßßßß  ßßßßßßß  ßßßßßßß    ßß     ßß ßß    ßß ßß ßß  ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßß  ßß ßß       ßß
echo  ßßßßßß  ßß   ßß ßßßßßßß  ßß   ßß    ßß     ßß  ßßßßßß  ßß   ßßßß  ßßßßßßß
echo.
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo ============================================================================
echo                 SELECT ASPECT RATIO [%TOOLBOX_VER%]                        
echo ============================================================================
echo.
echo [1] 16:9  (Widescreen / Landscape / Desktop Monitor)  [DEFAULT]
echo [2] 1:1   (Square / Standard Avatar)
echo [3] 9:16  (Portrait / Mobile Phone / Story)
echo [4] 4:3   (Standard Display Monitor)
echo [5] 21:9  (Ultrawide Cinematic Widescreen)
echo [6] Back to Main Menu
echo.
echo ============================================================================
set /p "ar_choice=Choose Aspect Ratio [1-6]: "

if "%ar_choice%"=="1" (
    set "SELECTED_AR=16:9"
    goto :AI_Image_Menu
)
if "%ar_choice%"=="2" (
    set "SELECTED_AR=1:1"
    goto :AI_Image_Menu
)
if "%ar_choice%"=="3" (
    set "SELECTED_AR=9:16"
    goto :AI_Image_Menu
)
if "%ar_choice%"=="4" (
    set "SELECTED_AR=4:3"
    goto :AI_Image_Menu
)
if "%ar_choice%"=="5" (
    set "SELECTED_AR=21:9"
    goto :AI_Image_Menu
)
if "%ar_choice%"=="6" goto :AI_Image_Menu

echo.
echo [!] Invalid selection. Retrying...
timeout /t 2 >nul
goto :Select_Aspect_Ratio_Menu

:Select_Resolution_Menu
cls
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo.
echo         ßßß    ßßß   ßßßßßß   ßßßßßß   ßßßßßß   ßß   ßß  ßßßßßßß
echo         ßßßß  ßßßß  ßß    ßß  ßß   ßß  ßß   ßß  ßß   ßß  ßß     
echo         ßß ßßßß ßß  ßß    ßß  ßßßßßß   ßßßßßß   ßßßßßßß  ßßßßßßß
echo         ßß  ßß  ßß  ßß    ßß  ßß   ßß  ßß       ßß   ßß       ßß
echo         ßß      ßß   ßßßßßß   ßß   ßß  ßß       ßß   ßß  ßßßßßßß
echo.
echo  ßßßßßß  ßßßßßß  ßßßßßßß   ßßßßß  ßßßßßßßß  ßß  ßßßßßß  ßßß    ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßßßß   ßß  ßß     
echo ßß       ßßßßßß  ßßßßßßß  ßßßßßßß    ßß     ßß ßß    ßß ßß ßß  ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßß  ßß ßß       ßß
echo  ßßßßßß  ßß   ßß ßßßßßßß  ßß   ßß    ßß     ßß  ßßßßßß  ßß   ßßßß  ßßßßßßß
echo.
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo ============================================================================
echo                 SELECT RESOLUTION QUALITY TIER [%TOOLBOX_VER%]             
echo ============================================================================
echo.
echo [1] SD    (Standard Speed - Base 1024 Edge)
echo [2] 1080p (Full HD Lossless PNG)  [DEFAULT]
echo [3] 2K    (QHD High Resolution Pass)
echo [4] 4K    (Ultra HD - High Detail Target)
echo [5] 8K    (Master Quality - Maximum Detail Pass)
echo [6] Back to Main Menu
echo.
echo ============================================================================
set /p "tier_choice=Choose Quality Tier [1-6]: "

if "%tier_choice%"=="1" (
    set "SELECTED_TIER=SD"
    goto :AI_Image_Menu
)
if "%tier_choice%"=="2" (
    set "SELECTED_TIER=1080p"
    goto :AI_Image_Menu
)
if "%tier_choice%"=="3" (
    set "SELECTED_TIER=2K"
    goto :AI_Image_Menu
)
if "%tier_choice%"=="4" (
    set "SELECTED_TIER=4K"
    goto :AI_Image_Menu
)
if "%tier_choice%"=="5" (
    set "SELECTED_TIER=8K"
    goto :AI_Image_Menu
)
if "%tier_choice%"=="6" goto :AI_Image_Menu

echo.
echo [!] Invalid selection. Retrying...
timeout /t 2 >nul
goto :Select_Resolution_Menu

:Generate_Image_Routine
call :Recalculate_Dimensions
cls
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo.
echo         ßßß    ßßß   ßßßßßß   ßßßßßß   ßßßßßß   ßß   ßß  ßßßßßßß
echo         ßßßß  ßßßß  ßß    ßß  ßß   ßß  ßß   ßß  ßß   ßß  ßß     
echo         ßß ßßßß ßß  ßß    ßß  ßßßßßß   ßßßßßß   ßßßßßßß  ßßßßßßß
echo         ßß  ßß  ßß  ßß    ßß  ßß   ßß  ßß       ßß   ßß       ßß
echo         ßß      ßß   ßßßßßß   ßß   ßß  ßß       ßß   ßß  ßßßßßßß
echo.
echo  ßßßßßß  ßßßßßß  ßßßßßßß   ßßßßß  ßßßßßßßß  ßß  ßßßßßß  ßßß    ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßßßß   ßß  ßß     
echo ßß       ßßßßßß  ßßßßßßß  ßßßßßßß    ßß     ßß ßß    ßß ßß ßß  ßß  ßßßßßßß
echo ßß       ßß   ßß ßß       ßß   ßß    ßß     ßß ßß    ßß ßß  ßß ßß       ßß
echo  ßßßßßß  ßß   ßß ßßßßßßß  ßß   ßß    ßß     ßß  ßßßßßß  ßß   ßßßß  ßßßßßßß
echo.
echo ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
echo ============================================================================
echo                 AI IMAGE GENERATION SUBROUTINE [%TOOLBOX_VER%]             
echo ============================================================================
echo.
echo Engine Active    : %MODEL_DISPLAY%
echo Detail Preset    : %STYLE_DISPLAY%
echo Format ^& Quality : %SELECTED_AR% @ %SELECTED_TIER% (%IMG_WIDTH%x%IMG_HEIGHT% PNG Target)
echo AI Detail Engine : %ENHANCE_DISPLAY%
echo.

set "raw_prompt="
set /p "raw_prompt=Enter prompt describing the image to generate: "

if not defined raw_prompt (
    echo.
    echo [!] Empty prompt detected.
    echo Press any key to return to menu...
    pause >nul
    goto :AI_Image_Menu
)

:: Environment Variable Handoff
set "RAW_PROMPT_VAL=!raw_prompt!"
set "STYLE_VAL=%SELECTED_STYLE%"
set "MODEL_VAL=%SELECTED_MODEL%"
set "WIDTH_VAL=%IMG_WIDTH%"
set "HEIGHT_VAL=%IMG_HEIGHT%"
set "AR_VAL=%SELECTED_AR%"
set "TIER_VAL=%SELECTED_TIER%"
set "ENHANCE_VAL=%SELECTED_ENHANCE%"
set "VIEWER_PATH=%T_Dir%\NativeImageViewer.exe"
set "OUT_DIR=%Out_Dir%"

echo.
echo [*] Invoking PowerShell Core Engine [%TOOLBOX_VER%]...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS_Engine%"
set "PS_EXIT_CODE=%ERRORLEVEL%"

if %PS_EXIT_CODE% neq 0 (
    echo.
    echo ============================================================================
    echo [ERROR] PowerShell engine exited with code: %PS_EXIT_CODE%
    echo [CRASH PREVENTION] Halted execution loop to retain error log above.
    echo ============================================================================
    echo.
    pause
)

goto :AI_Image_Menu


:: ============================================================================
:: SUBROUTINE: Recalculate_Dimensions
:: Physical dimension matrix mapped to exact quality tiers
:: ============================================================================
:Recalculate_Dimensions
if "%SELECTED_AR%"=="1:1" (
    if "%SELECTED_TIER%"=="SD" ( set "IMG_WIDTH=1024" & set "IMG_HEIGHT=1024" )
    if "%SELECTED_TIER%"=="1080p" ( set "IMG_WIDTH=1080" & set "IMG_HEIGHT=1080" )
    if "%SELECTED_TIER%"=="2K" ( set "IMG_WIDTH=1440" & set "IMG_HEIGHT=1440" )
    if "%SELECTED_TIER%"=="4K" ( set "IMG_WIDTH=2160" & set "IMG_HEIGHT=2160" )
    if "%SELECTED_TIER%"=="8K" ( set "IMG_WIDTH=3840" & set "IMG_HEIGHT=3840" )
)
if "%SELECTED_AR%"=="16:9" (
    if "%SELECTED_TIER%"=="SD" ( set "IMG_WIDTH=1280" & set "IMG_HEIGHT=720" )
    if "%SELECTED_TIER%"=="1080p" ( set "IMG_WIDTH=1920" & set "IMG_HEIGHT=1080" )
    if "%SELECTED_TIER%"=="2K" ( set "IMG_WIDTH=2560" & set "IMG_HEIGHT=1440" )
    if "%SELECTED_TIER%"=="4K" ( set "IMG_WIDTH=3840" & set "IMG_HEIGHT=2160" )
    if "%SELECTED_TIER%"=="8K" ( set "IMG_WIDTH=3840" & set "IMG_HEIGHT=2160" )
)
if "%SELECTED_AR%"=="9:16" (
    if "%SELECTED_TIER%"=="SD" ( set "IMG_WIDTH=720" & set "IMG_HEIGHT=1280" )
    if "%SELECTED_TIER%"=="1080p" ( set "IMG_WIDTH=1080" & set "IMG_HEIGHT=1920" )
    if "%SELECTED_TIER%"=="2K" ( set "IMG_WIDTH=1440" & set "IMG_HEIGHT=2560" )
    if "%SELECTED_TIER%"=="4K" ( set "IMG_WIDTH=2160" & set "IMG_HEIGHT=3840" )
    if "%SELECTED_TIER%"=="8K" ( set "IMG_WIDTH=2160" & set "IMG_HEIGHT=3840" )
)
if "%SELECTED_AR%"=="4:3" (
    if "%SELECTED_TIER%"=="SD" ( set "IMG_WIDTH=1024" & set "IMG_HEIGHT=768" )
    if "%SELECTED_TIER%"=="1080p" ( set "IMG_WIDTH=1440" & set "IMG_HEIGHT=1080" )
    if "%SELECTED_TIER%"=="2K" ( set "IMG_WIDTH=1920" & set "IMG_HEIGHT=1440" )
    if "%SELECTED_TIER%"=="4K" ( set "IMG_WIDTH=2880" & set "IMG_HEIGHT=2160" )
    if "%SELECTED_TIER%"=="8K" ( set "IMG_WIDTH=2880" & set "IMG_HEIGHT=2160" )
)
if "%SELECTED_AR%"=="21:9" (
    if "%SELECTED_TIER%"=="SD" ( set "IMG_WIDTH=1344" & set "IMG_HEIGHT=576" )
    if "%SELECTED_TIER%"=="1080p" ( set "IMG_WIDTH=1920" & set "IMG_HEIGHT=822" )
    if "%SELECTED_TIER%"=="2K" ( set "IMG_WIDTH=2560" & set "IMG_HEIGHT=1097" )
    if "%SELECTED_TIER%"=="4K" ( set "IMG_WIDTH=3840" & set "IMG_HEIGHT=1645" )
    if "%SELECTED_TIER%"=="8K" ( set "IMG_WIDTH=3840" & set "IMG_HEIGHT=1645" )
)
exit /b 0


:: ============================================================================
:: SUBROUTINE: Ensure_Engine_Script
:: Writes AIGenEngine.ps1 with Prompt Quality Modifiers and Proportional Resampler
:: ============================================================================
:Ensure_Engine_Script
if exist "%PS_Engine%" del /f /q "%PS_Engine%" >nul 2>&1

setlocal DisableDelayedExpansion
echo $rawPrompt = $env:RAW_PROMPT_VAL> "%PS_Engine%"
echo $stylePreset = $env:STYLE_VAL>> "%PS_Engine%"
echo $model = $env:MODEL_VAL>> "%PS_Engine%"
echo $width = $env:WIDTH_VAL>> "%PS_Engine%"
echo $height = $env:HEIGHT_VAL>> "%PS_Engine%"
echo $ar = $env:AR_VAL>> "%PS_Engine%"
echo $tier = $env:TIER_VAL>> "%PS_Engine%"
echo $enhance = $env:ENHANCE_VAL>> "%PS_Engine%"
echo $viewerPath = $env:VIEWER_PATH>> "%PS_Engine%"
echo $outDir = $env:OUT_DIR>> "%PS_Engine%"
echo if ([string]::IsNullOrWhiteSpace($model)) { $model = "nanobanana" }>> "%PS_Engine%"
echo if ([string]::IsNullOrWhiteSpace($width)) { $width = "1920" }>> "%PS_Engine%"
echo if ([string]::IsNullOrWhiteSpace($height)) { $height = "1080" }>> "%PS_Engine%"
echo if ([string]::IsNullOrWhiteSpace($enhance)) { $enhance = "true" }>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo # Apply Micro-Detail Quality Modifier to Prompt>> "%PS_Engine%"
echo $enhancedPrompt = $rawPrompt>> "%PS_Engine%"
echo if ($stylePreset -eq "MASTERPIECE") {>> "%PS_Engine%"
echo     $enhancedPrompt += ", 8k resolution, masterpiece, highly detailed dragon scales, intricate mandala patterns, sharp focus, hyperrealistic, 35mm photograph, flawless texture">> "%PS_Engine%"
echo } elseif ($stylePreset -eq "PHOTOREAL") {>> "%PS_Engine%"
echo     $enhancedPrompt += ", photorealistic 8k, raw camera photo, sharp focus, shot on 35mm lens, f/1.8, cinematic lighting, ultra high detail">> "%PS_Engine%"
echo } elseif ($stylePreset -eq "CINEMATIC") {>> "%PS_Engine%"
echo     $enhancedPrompt += ", octane render 8k, unreal engine 5, raytracing, volumetric lighting, hyperdetailed, sharp edges, dramatic shadows">> "%PS_Engine%"
echo } elseif ($stylePreset -eq "DARK_FANTASY") {>> "%PS_Engine%"
echo     $enhancedPrompt += ", dark fantasy art, intricate details, highly detailed, sharp line art, 8k resolution, trending on artstation">> "%PS_Engine%"
echo }>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo Write-Host "============================================================================" -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "              AI IMAGE GENERATION ENGINE (PS CORE) v0.35                    " -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "============================================================================" -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "">> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo if ([string]::IsNullOrWhiteSpace($rawPrompt)) {>> "%PS_Engine%"
echo     Write-Host "[ERROR] Empty prompt received." -ForegroundColor Red>> "%PS_Engine%"
echo     Read-Host "Press Enter to return...">> "%PS_Engine%"
echo     exit 1>> "%PS_Engine%"
echo }>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo if (-not (Test-Path $viewerPath)) {>> "%PS_Engine%"
echo     Write-Host "[*] Downloading Native Image Viewer dependency..." -ForegroundColor Yellow>> "%PS_Engine%"
echo     try {>> "%PS_Engine%"
echo         [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12>> "%PS_Engine%"
echo         $wc = New-Object System.Net.WebClient>> "%PS_Engine%"
echo         $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0")>> "%PS_Engine%"
echo         $wc.DownloadFile("https://github.com/deminimis/minimalimageviewer/releases/download/v2.0.3/MinimalImageViewer.exe", $viewerPath)>> "%PS_Engine%"
echo         Write-Host "[OK] Native Image Viewer acquired." -ForegroundColor Green>> "%PS_Engine%"
echo     } catch {>> "%PS_Engine%"
echo         Write-Host "[ERROR] Failed to download viewer:" $_.Exception.Message -ForegroundColor Red>> "%PS_Engine%"
echo         Read-Host "Press Enter to return...">> "%PS_Engine%"
echo         exit 1>> "%PS_Engine%"
echo     }>> "%PS_Engine%"
echo }>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo $encodedPrompt = [System.Uri]::EscapeDataString($enhancedPrompt)>> "%PS_Engine%"
echo $seed = Get-Random -Minimum 100000 -Maximum 99999999>> "%PS_Engine%"
echo $targetFile = Join-Path $outDir "AI_Gen_$seed.png">> "%PS_Engine%"
echo $metaFile = Join-Path $outDir "AI_Gen_$seed.txt">> "%PS_Engine%"
echo $apiUrl = "https://image.pollinations.ai/prompt/" + $encodedPrompt + "?width=" + $width + "&height=" + $height + "&seed=" + $seed + "&model=" + $model + "&enhance=" + $enhance + "&nologo=true">> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo Write-Host "[*] Selected Model  : $model" -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "[*] Style Preset    : $stylePreset" -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "[*] Aspect Ratio    : $ar" -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "[*] Quality Tier    : $tier Target (${width}x${height})" -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "[*] Output Format   : PNG (Lossless High-Quality)" -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "[*] Detail Enhancer : $enhance (AI Post-Upscale Pass)" -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "[*] Prompt Input    : $rawPrompt" -ForegroundColor Cyan>> "%PS_Engine%"
echo Write-Host "[*] Enhanced Prompt : $enhancedPrompt" -ForegroundColor Cyan>> "%PS_Engine%"
echo Write-Host "[*] Request URL      : $apiUrl" -ForegroundColor Gray>> "%PS_Engine%"
echo Write-Host "[*] Requesting AI image generation (Timeout: 120s)..." -ForegroundColor Yellow>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo try {>> "%PS_Engine%"
echo     [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12>> "%PS_Engine%"
echo     $wc = New-Object System.Net.WebClient>> "%PS_Engine%"
echo     $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/120.0.0.0")>> "%PS_Engine%"
echo     $wc.DownloadFile($apiUrl, $targetFile)>> "%PS_Engine%"
echo } catch {>> "%PS_Engine%"
echo     Write-Host "">> "%PS_Engine%"
echo     Write-Host "[ERROR] Generation request failed:" $_.Exception.Message -ForegroundColor Red>> "%PS_Engine%"
echo     Write-Host "">> "%PS_Engine%"
echo     Read-Host "Press Enter to return...">> "%PS_Engine%"
echo     exit 1>> "%PS_Engine%"
echo }>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo if (-not (Test-Path $targetFile)) {>> "%PS_Engine%"
echo     Write-Host "[ERROR] Target image file was not created on disk." -ForegroundColor Red>> "%PS_Engine%"
echo     Read-Host "Press Enter to return...">> "%PS_Engine%"
echo     exit 1>> "%PS_Engine%"
echo }>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo $fileSize = (Get-Item $targetFile).Length>> "%PS_Engine%"
echo if ($fileSize -lt 10240) {>> "%PS_Engine%"
echo     Write-Host "">> "%PS_Engine%"
echo     Write-Host "============================================================================" -ForegroundColor Red>> "%PS_Engine%"
echo     Write-Host "[ERROR] API returned error payload ($fileSize bytes)." -ForegroundColor Red>> "%PS_Engine%"
echo     Write-Host "==================== DIAGNOSTIC PAYLOAD CONTENTS ====================" -ForegroundColor Yellow>> "%PS_Engine%"
echo     Get-Content $targetFile>> "%PS_Engine%"
echo     Write-Host "============================================================================" -ForegroundColor Yellow>> "%PS_Engine%"
echo     Remove-Item $targetFile -Force -ErrorAction SilentlyContinue>> "%PS_Engine%"
echo     Write-Host "">> "%PS_Engine%"
echo     Read-Host "Press Enter to return...">> "%PS_Engine%"
echo     exit 1>> "%PS_Engine%"
echo }>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo # Native Proportional Aspect-Ratio Preserving Resampler via System.Drawing>> "%PS_Engine%"
echo try {>> "%PS_Engine%"
echo     Add-Type -AssemblyName System.Drawing>> "%PS_Engine%"
echo     $srcImg = [System.Drawing.Image]::FromFile($targetFile)>> "%PS_Engine%"
echo     $targetW = [int]$width>> "%PS_Engine%"
echo     $targetH = [int]$height>> "%PS_Engine%"
echo     if ($srcImg.Width -ne $targetW -or $srcImg.Height -ne $targetH) {>> "%PS_Engine%"
echo         Write-Host "[*] Post-processing: Resampling PNG to ${targetW}x${targetH} (Preserving Proportions)..." -ForegroundColor Yellow>> "%PS_Engine%"
echo         $bmp = New-Object System.Drawing.Bitmap($targetW, $targetH)>> "%PS_Engine%"
echo         $g = [System.Drawing.Graphics]::FromImage($bmp)>> "%PS_Engine%"
echo         $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic>> "%PS_Engine%"
echo         $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality>> "%PS_Engine%"
echo         $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality>> "%PS_Engine%"
echo         $srcRatio = $srcImg.Width / $srcImg.Height>> "%PS_Engine%"
echo         $targetRatio = $targetW / $targetH>> "%PS_Engine%"
echo         if ($srcRatio -gt $targetRatio) {>> "%PS_Engine%"
echo             $cropW = [int]($srcImg.Height * $targetRatio)>> "%PS_Engine%"
echo             $cropH = $srcImg.Height>> "%PS_Engine%"
echo             $cropX = [int](($srcImg.Width - $cropW) / 2)>> "%PS_Engine%"
echo             $cropY = 0>> "%PS_Engine%"
echo         } else {>> "%PS_Engine%"
echo             $cropW = $srcImg.Width>> "%PS_Engine%"
echo             $cropH = [int]($srcImg.Width / $targetRatio)>> "%PS_Engine%"
echo             $cropX = 0>> "%PS_Engine%"
echo             $cropY = [int](($srcImg.Height - $cropH) / 2)>> "%PS_Engine%"
echo         }>> "%PS_Engine%"
echo         $srcRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropW, $cropH)>> "%PS_Engine%"
echo         $destRect = New-Object System.Drawing.Rectangle(0, 0, $targetW, $targetH)>> "%PS_Engine%"
echo         $g.DrawImage($srcImg, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)>> "%PS_Engine%"
echo         $srcImg.Dispose()>> "%PS_Engine%"
echo         $g.Dispose()>> "%PS_Engine%"
echo         $bmp.Save($targetFile, [System.Drawing.Imaging.ImageFormat]::Png)>> "%PS_Engine%"
echo         $bmp.Dispose()>> "%PS_Engine%"
echo         Write-Host "[OK] Lossless PNG resampled without aspect ratio distortion." -ForegroundColor Green>> "%PS_Engine%"
echo     } else {>> "%PS_Engine%"
echo         $srcImg.Dispose()>> "%PS_Engine%"
echo     }>> "%PS_Engine%"
echo } catch {>> "%PS_Engine%"
echo     Write-Host "[!] Note: Aspect-fit resampler bypassed: $($_.Exception.Message)" -ForegroundColor Gray>> "%PS_Engine%"
echo }>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo # Write Sidecar Metadata Log>> "%PS_Engine%"
echo $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss">> "%PS_Engine%"
echo $logData = "============================================================================" + "`n" +>> "%PS_Engine%"
echo            "MORPHS CREATIONS AI IMAGE LOG - v0.35" + "`n" +>> "%PS_Engine%"
echo            "============================================================================" + "`n" +>> "%PS_Engine%"
echo            "Timestamp       : " + $timestamp + "`n" +>> "%PS_Engine%"
echo            "Raw Prompt      : " + $rawPrompt + "`n" +>> "%PS_Engine%"
echo            "Enhanced Prompt : " + $enhancedPrompt + "`n" +>> "%PS_Engine%"
echo            "Style Preset    : " + $stylePreset + "`n" +>> "%PS_Engine%"
echo            "Model Engine    : " + $model + "`n" +>> "%PS_Engine%"
echo            "Aspect Ratio    : " + $ar + "`n" +>> "%PS_Engine%"
echo            "Quality Tier    : " + $tier + "`n" +>> "%PS_Engine%"
echo            "Dimensions      : " + $width + "x" + $height + "`n" +>> "%PS_Engine%"
echo            "Output Format   : PNG (Lossless)" + "`n" +>> "%PS_Engine%"
echo            "Detail Enhancer : " + $enhance + "`n" +>> "%PS_Engine%"
echo            "Random Seed     : " + $seed + "`n" +>> "%PS_Engine%"
echo            "Image Target    : " + $targetFile + "`n" +>> "%PS_Engine%"
echo            "API Endpoint    : " + $apiUrl + "`n" +>> "%PS_Engine%"
echo            "============================================================================">> "%PS_Engine%"
echo Set-Content -Path $metaFile -Value $logData>> "%PS_Engine%"
echo.>> "%PS_Engine%"
echo Write-Host "">> "%PS_Engine%"
echo Write-Host "[SUCCESS] Lossless PNG Image generated and validated ($fileSize bytes)." -ForegroundColor Green>> "%PS_Engine%"
echo Write-Host "[*] Saved prompt metadata to: $metaFile" -ForegroundColor Yellow>> "%PS_Engine%"
echo Write-Host "[*] Launching Native Image Viewer..." -ForegroundColor Cyan>> "%PS_Engine%"
echo ^& $viewerPath $targetFile>> "%PS_Engine%"
echo Write-Host "">> "%PS_Engine%"
echo Read-Host "Press Enter to return...">> "%PS_Engine%"
endlocal
exit /b 0