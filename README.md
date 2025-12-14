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

## Setup & Installation

เนื่องจากโปรแกรมถูกเขียนใหม่ด้วย C# .NET 8 เพื่อประสิทธิภาพที่ดีขึ้น คุณจำเป็นต้องเตรียมไฟล์ Execute ก่อนใช้งานครั้งแรก:

1. **Build โปรแกรม:**
   - ดับเบิ้ลคลิกไฟล์ `Build.bat`
   - รอจนเสร็จ จะได้ไฟล์ `LanguageMonitor.exe` ขึ้นมา

2. **เปิดใช้งาน:**
   - ดับเบิ้ลคลิก `Start.vbs` หรือ `LanguageMonitor.exe` เพื่อเริ่มทำงาน

3. **ติดตั้ง Auto-start (Optional):**
   - ดับเบิ้ลคลิก `Install.bat` เพื่อให้โปรแกรมเปิดเองตอนเปิดเครื่อง

## Files
| File | Description |
|------|-------------|
| `Build.bat` | **สร้างไฟล์โปรแกรม** (ต้องรันครั้งแรก) |
| `Start.vbs` | เปิดโปรแกรม (แบบซ่อนหน้าต่าง Console) |
| `StopMonitor.bat` | ปิดโปรแกรม |
| `Install.bat` | ติดตั้ง Auto-start กับ Windows |
| `Uninstall.bat` | ถอน Auto-start |

## Requirements
- Windows 10/11
- .NET 8 Runtime (ถ้าใช้ไฟล์ Build แบบ Self-Contained จะไม่จำเป็นต้องลงแยก)