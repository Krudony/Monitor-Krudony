using System;
using System.Windows;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Threading;

namespace LanguageMonitor
{
    public partial class MainWindow : Window
    {
        private readonly LanguageDetector _detector;
        private bool _isFollowCursor = false;
        private DispatcherTimer? _cursorTimer;

        // Hotkey IDs
        private const int HOTKEY_ID_FOLLOW = 9001; // Ctrl+Shift+Z
        private const int HOTKEY_ID_RESET = 9002;  // Ctrl+Alt+X

        public MainWindow()
        {
            InitializeComponent();

            // Initialize Position (Top-Right)
            ResetPosition();

            // Initialize Detector
            _detector = new LanguageDetector();
            _detector.LanguageChanged += OnLanguageChanged;
            _detector.Start();

            // Initialize Cursor Follow Timer (Only runs when enabled)
            _cursorTimer = new DispatcherTimer();
            _cursorTimer.Interval = TimeSpan.FromMilliseconds(20); // Smooth update
            _cursorTimer.Tick += CursorTimer_Tick;

            this.Loaded += MainWindow_Loaded;
            this.Closed += MainWindow_Closed;
        }

        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            // Setup Hotkeys
            var helper = new WindowInteropHelper(this);
            var source = HwndSource.FromHwnd(helper.Handle);
            source.AddHook(HwndHook);

            // Register Ctrl+Shift+Z (0x5A)
            NativeMethods.RegisterHotKey(helper.Handle, HOTKEY_ID_FOLLOW, NativeMethods.MOD_CONTROL | NativeMethods.MOD_SHIFT, 0x5A);

            // Register Ctrl+Alt+X (0x58)
            NativeMethods.RegisterHotKey(helper.Handle, HOTKEY_ID_RESET, NativeMethods.MOD_CONTROL | NativeMethods.MOD_ALT, 0x58);
        }

        private void MainWindow_Closed(object? sender, EventArgs e)
        {
            _detector.Dispose();
            
            // Unregister Hotkeys
            var helper = new WindowInteropHelper(this);
            NativeMethods.UnregisterHotKey(helper.Handle, HOTKEY_ID_FOLLOW);
            NativeMethods.UnregisterHotKey(helper.Handle, HOTKEY_ID_RESET);
        }

        private IntPtr HwndHook(IntPtr hwnd, int msg, IntPtr wParam, IntPtr lParam, ref bool handled)
        {
            const int WM_HOTKEY = 0x0312;
            if (msg == WM_HOTKEY)
            {
                int id = wParam.ToInt32();
                if (id == HOTKEY_ID_FOLLOW)
                {
                    _isFollowCursor = true;
                    _cursorTimer?.Start();
                }
                else if (id == HOTKEY_ID_RESET)
                {
                    _isFollowCursor = false;
                    _cursorTimer?.Stop();
                    ResetPosition();
                }
                handled = true;
            }
            return IntPtr.Zero;
        }

        private void CursorTimer_Tick(object? sender, EventArgs e)
        {
            if (_isFollowCursor)
            {
                NativeMethods.GetCursorPos(out var point);
                // Offset slightly so it doesn't block click
                this.Left = point.X + 15;
                this.Top = point.Y + 15;
            }
        }

        private void ResetPosition()
        {
            var screenWidth = SystemParameters.PrimaryScreenWidth;
            this.Left = screenWidth - this.Width - 20;
            this.Top = 20;
        }

        private void OnLanguageChanged(object? sender, string lang)
        {
            Dispatcher.Invoke(() =>
            {
                LangText.Text = lang;
                
                if (lang == "TH")
                    CardBorder.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#DD006400"));
                else if (lang == "EN")
                    CardBorder.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#DD00008B"));
                else
                    CardBorder.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#DD555555"));
            });
        }

        private void Window_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ButtonState == MouseButtonState.Pressed)
            {
                this.DragMove();
            }
        }

        private void CloseBtn_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        private void CloseBtn_MouseEnter(object sender, MouseEventArgs e)
        {
            CloseBtn.Foreground = Brushes.White;
        }

        private void CloseBtn_MouseLeave(object sender, MouseEventArgs e)
        {
            CloseBtn.Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString("#999999"));
        }
    }
}
