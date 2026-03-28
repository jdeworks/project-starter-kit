using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows.Input;

namespace MyApp.ViewModels;

public class MainViewModel : INotifyPropertyChanged
{
    private int _count;

    public MainViewModel()
    {
        IncrementCommand = new Command(Increment);
        ResetCommand = new Command(Reset);
    }

    public int Count
    {
        get => _count;
        private set
        {
            if (_count != value)
            {
                _count = value;
                OnPropertyChanged();
                OnPropertyChanged(nameof(CountText));
            }
        }
    }

    public string CountText => $"Count: {Count}";

    public ICommand IncrementCommand { get; }
    public ICommand ResetCommand { get; }

    public void Increment()
    {
        Count++;
    }

    public void Reset()
    {
        Count = 0;
    }

    public event PropertyChangedEventHandler? PropertyChanged;

    protected void OnPropertyChanged([CallerMemberName] string? name = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(name));
    }
}
