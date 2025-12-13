using System;
using System.Threading;
using System.Windows;

namespace LanguageMonitor
{
    public partial class App : Application
    {
        private static Mutex? _mutex = null;
        private const string AppName = "LanguageMonitor_Krudony_Instance";

        protected override void OnStartup(StartupEventArgs e)
        {
            bool createdNew;
            _mutex = new Mutex(true, AppName, out createdNew);

            if (!createdNew)
            {
                // App is already running!
                // Optional: Bring existing window to front (requires more P/Invoke code)
                // For now, just exit silently to prevent duplicates.
                Application.Current.Shutdown();
                return;
            }

            base.OnStartup(e);
        }

        protected override void OnExit(ExitEventArgs e)
        {
            if (_mutex != null)
            {
                _mutex.ReleaseMutex();
                _mutex.Dispose();
            }
            base.OnExit(e);
        }
    }
}