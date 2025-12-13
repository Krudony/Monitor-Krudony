# Language Monitor - จอเดียว ตรงกลาง + คีย์ลัด
Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase, System.Windows.Forms

# Win32 API
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Win32Helper {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, IntPtr lpdwProcessId);

    [DllImport("user32.dll")]
    public static extern IntPtr GetKeyboardLayout(uint idThread);

    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);

    [DllImport("user32.dll")]
    public static extern bool UnregisterHotKey(IntPtr hWnd, int id);

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    public static string GetCurrentLanguage() {
        IntPtr hwnd = GetForegroundWindow();
        uint threadId = GetWindowThreadProcessId(hwnd, IntPtr.Zero);
        IntPtr layout = GetKeyboardLayout(threadId);
        int langId = (int)layout & 0xFFFF;

        if (langId == 0x041E) return "TH";
        if (langId == 0x0409) return "EN";
        return langId.ToString("X4");
    }

    public static POINT GetMousePosition() {
        POINT p;
        GetCursorPos(out p);
        return p;
    }
}
"@

# XAML - จอเดียว มีปุ่มปิด ลากได้
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Language Monitor" Height="45" Width="65"
        WindowStyle="None" ResizeMode="NoResize"
        AllowsTransparency="True" Background="Transparent"
        Topmost="True" ShowInTaskbar="False">
    <Border Name="CardBorder" CornerRadius="8" Background="#DD333333">
        <Grid>
            <TextBlock Name="LangText" Text="--" Foreground="White"
                       FontSize="20" FontWeight="Bold"
                       HorizontalAlignment="Center" VerticalAlignment="Center"/>
            <Button Name="CloseBtn" Content="x"
                    HorizontalAlignment="Right" VerticalAlignment="Top"
                    Width="14" Height="14" Margin="0,2,2,0"
                    Background="Transparent" BorderBrush="Transparent"
                    Foreground="#999999" FontSize="9"
                    FontWeight="Bold" Cursor="Hand"/>
        </Grid>
    </Border>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $XAML
$Form = [System.Windows.Markup.XamlReader]::Load($reader)

$LangText = $Form.FindName("LangText")
$CardBorder = $Form.FindName("CardBorder")
$CloseBtn = $Form.FindName("CloseBtn")

$CloseBtn.Add_Click({ $Form.Close() })
$Form.Add_MouseLeftButtonDown({ $Form.DragMove() })
$CloseBtn.Add_MouseEnter({ $CloseBtn.Foreground = "White" })
$CloseBtn.Add_MouseLeave({ $CloseBtn.Foreground = "#999999" })

$script:currentLang = ""
$script:followCursor = $false

$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$script:centerX = ($screen.Bounds.Width - 65) / 2
$script:centerY = ($screen.Bounds.Height - 45) / 2

$Form.Left = $screen.Bounds.Right - 85
$Form.Top = $screen.Bounds.Top + 20

$timer = New-Object System.Windows.Threading.DispatcherTimer
$timer.Interval = [TimeSpan]::FromMilliseconds(100)

$timer.Add_Tick({
    try {
        $lang = [Win32Helper]::GetCurrentLanguage()
        if ($lang -ne $script:currentLang) {
            $script:currentLang = $lang
            $LangText.Text = $lang
            if ($lang -eq "TH") { $CardBorder.Background = "#DD006400" }
            elseif ($lang -eq "EN") { $CardBorder.Background = "#DD00008B" }
            else { $CardBorder.Background = "#DD555555" }
        }
        if ($script:followCursor) {
            $pos = [Win32Helper]::GetMousePosition()
            $Form.Left = $pos.X + 15
            $Form.Top = $pos.Y + 15
        }
    }
    catch {}
})

$Form.Add_SourceInitialized({
    $helper = New-Object System.Windows.Interop.WindowInteropHelper($Form)
    $hwnd = $helper.Handle
    [Win32Helper]::RegisterHotKey($hwnd, 1, 0x0006, 0x5A) | Out-Null
    [Win32Helper]::RegisterHotKey($hwnd, 2, 0x0003, 0x58) | Out-Null
})

$Form.Add_Loaded({
    $helper = New-Object System.Windows.Interop.WindowInteropHelper($Form)
    $source = [System.Windows.Interop.HwndSource]::FromHwnd($helper.Handle)
    $source.AddHook({
        param($hwnd, $msg, $wParam, $lParam, [ref]$handled)
        if ($msg -eq 0x0312) {
            $id = $wParam.ToInt32()
            if ($id -eq 1) { $script:followCursor = $true }
            elseif ($id -eq 2) {
                $script:followCursor = $false
                $Form.Left = $screen.Bounds.Right - 85
                $Form.Top = $screen.Bounds.Top + 20
            }
            $handled = $true
        }
        return [IntPtr]::Zero
    })
})

$Form.Add_Closed({
    $timer.Stop()
    $helper = New-Object System.Windows.Interop.WindowInteropHelper($Form)
    [Win32Helper]::UnregisterHotKey($helper.Handle, 1) | Out-Null
    [Win32Helper]::UnregisterHotKey($helper.Handle, 2) | Out-Null
})

$timer.Start()
$Form.ShowDialog() | Out-Null
