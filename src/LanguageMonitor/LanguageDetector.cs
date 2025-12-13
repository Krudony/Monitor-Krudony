using System;
using System.Diagnostics;
using System.Windows.Threading;

namespace LanguageMonitor
{
    public class LanguageDetector : IDisposable
    {
        private NativeMethods.WinEventDelegate? _winEventDelegate;
        private IntPtr _hookId = IntPtr.Zero;
        private DispatcherTimer _timer;
        private string _lastLang = "";

        // Event to notify UI when language *might* have changed
        public event EventHandler<string>? LanguageChanged;

        public LanguageDetector()
        {
            // Hybrid Approach: Polling every 200ms to catch in-window language switching
            // This is still much more efficient than pure script polling because C# is compiled.
            _timer = new DispatcherTimer();
            _timer.Interval = TimeSpan.FromMilliseconds(200);
            _timer.Tick += (s, e) => CheckLanguage();
        }

        public void Start()
        {
            if (_hookId != IntPtr.Zero) return;

            // 1. Hook for Window Switching (Instant Update)
            _winEventDelegate = new NativeMethods.WinEventDelegate(WinEventProc);
            
            _hookId = NativeMethods.SetWinEventHook(
                NativeMethods.EVENT_SYSTEM_FOREGROUND, 
                NativeMethods.EVENT_SYSTEM_FOREGROUND, 
                IntPtr.Zero, 
                _winEventDelegate, 
                0, 
                0, 
                NativeMethods.WINEVENT_OUTOFCONTEXT
            );

            // 2. Start Timer for In-Window Switching
            _timer.Start();

            // Trigger initial check
            CheckLanguage();
        }

        public void Stop()
        {
            _timer.Stop();

            if (_hookId != IntPtr.Zero)
            {
                NativeMethods.UnhookWinEvent(_hookId);
                _hookId = IntPtr.Zero;
            }
        }

        public void ForceCheck()
        {
            CheckLanguage();
        }

        private void WinEventProc(IntPtr hWinEventHook, uint eventType, IntPtr hwnd, int idObject, int idChild, uint dwEventThread, uint dwmsEventTime)
        {
            CheckLanguage();
        }

        private void CheckLanguage()
        {
            try
            {
                IntPtr hwnd = NativeMethods.GetForegroundWindow();
                if (hwnd == IntPtr.Zero) return;

                uint processId;
                uint threadId = NativeMethods.GetWindowThreadProcessId(hwnd, out processId);
                
                IntPtr layout = NativeMethods.GetKeyboardLayout(threadId);
                int langId = (int)layout & 0xFFFF;

                string langCode = "??";
                if (langId == 0x041E) langCode = "TH";
                else if (langId == 0x0409) langCode = "EN";
                else langCode = langId.ToString("X4");

                // Only invoke event if changed (optimization)
                if (langCode != _lastLang)
                {
                    _lastLang = langCode;
                    LanguageChanged?.Invoke(this, langCode);
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"Error checking language: {ex.Message}");
            }
        }

        public void Dispose()
        {
            Stop();
        }
    }
}
