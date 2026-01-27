@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

:: 定义用户文件夹路径
set "UserFolder=%USERPROFILE%"

:: 提示脚本开始执行
echo ==============================================
echo 正在尝试将用户文件夹固定到资源管理器左侧...
echo 目标文件夹：%UserFolder%
echo ==============================================
echo.

:: 以Bypass策略执行PowerShell命令，提升兼容性
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$ErrorActionPreference = 'Stop'; ^
try { ^
    $shell = New-Object -ComObject Shell.Application -ErrorAction Stop; ^
    $folder = $shell.Namespace('!UserFolder!'); ^
    if ($folder -and $folder.Self) { ^
        $folder.Self.InvokeVerb('pintohome'); ^
        Write-Host '✅ 成功：已将用户文件夹固定到资源管理器左侧！' -ForegroundColor Green; ^
    } else { ^
        Write-Host '❌ 失败：无法找到用户文件夹或文件夹对象无效！' -ForegroundColor Red; ^
        exit 1; ^
    } ^
} catch { ^
    Write-Host '❌ 异常：' $_.Exception.Message -ForegroundColor Red; ^
    exit 1; ^
}"

:: 捕获PowerShell执行返回码
if %errorlevel% equ 0 (
    echo.
    echo 操作完成，按任意键退出...
) else (
    echo.
    echo 操作失败，按任意键退出...
)
pause >nul
endlocal