# Language Monitor

แสดงสถานะภาษาแป้นพิมพ์ (TH/EN) บนหน้าจอแบบ Overlay

## Features
- แสดง TH/EN มุมขวาบนของจอ
- สีเปลี่ยนตามภาษา (TH=เขียว, EN=น้ำเงิน)
- Always on top
- ลากเลื่อนได้
- มีปุ่มปิด

## Hotkeys
| Hotkey | Action |
|--------|--------|
| `Ctrl+Shift+Z` | Card ตาม cursor |
| `Ctrl+Alt+X` | Card กลับมุมขวาบน |

## Requirements

> ⚠️ **ต้องติดตั้ง .NET 8 Desktop Runtime ก่อนใช้งาน**
> 
> ดาวน์โหลดได้ที่: https://dotnet.microsoft.com/download/dotnet/8.0
> 
> เลือก **".NET Desktop Runtime 8.x"** สำหรับ **Windows x64**

## Quick Start (ใช้ไฟล์ที่ Build แล้ว)

1. ติดตั้ง .NET 8 Desktop Runtime (ถ้ายังไม่มี)
2. ดับเบิ้ลคลิก `LanguageMonitor.exe` เพื่อเริ่มใช้งาน
3. (Optional) ดับเบิ้ลคลิก `Install.bat` เพื่อให้เปิดเองตอนเปิดเครื่อง

## Build from Source (สำหรับ Developer)

ถ้าต้องการ Build ใหม่จาก Source Code:

1. ติดตั้ง [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
2. ดับเบิ้ลคลิก `Build.bat`
3. รอจนเสร็จ จะได้ไฟล์ `LanguageMonitor.exe`

## Files
| File | Description |
|------|-------------|
| `LanguageMonitor.exe` | ไฟล์โปรแกรมหลัก |
| `Start.vbs` | เปิดโปรแกรม (แบบซ่อน Console) |
| `StopMonitor.bat` | ปิดโปรแกรม |
| `Install.bat` | ติดตั้ง Auto-start กับ Windows |
| `Uninstall.bat` | ถอน Auto-start |
| `Build.bat` | Build โปรแกรมจาก Source |

## System Requirements
- Windows 10/11 (64-bit)
- .NET 8 Desktop Runtime