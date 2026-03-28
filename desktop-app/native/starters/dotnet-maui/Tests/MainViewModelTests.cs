using Xunit;
using MyApp.ViewModels;

namespace MyApp.Tests;

public class MainViewModelTests
{
    [Fact]
    public void Count_StartsAtZero()
    {
        var vm = new MainViewModel();
        Assert.Equal(0, vm.Count);
    }

    [Fact]
    public void CountText_FormatsCorrectly()
    {
        var vm = new MainViewModel();
        Assert.Equal("Count: 0", vm.CountText);
    }

    [Fact]
    public void Increment_IncreasesCount()
    {
        var vm = new MainViewModel();
        vm.Increment();
        Assert.Equal(1, vm.Count);
    }

    [Fact]
    public void Increment_MultipleTimes()
    {
        var vm = new MainViewModel();
        vm.Increment();
        vm.Increment();
        vm.Increment();
        Assert.Equal(3, vm.Count);
    }

    [Fact]
    public void Reset_SetsCountToZero()
    {
        var vm = new MainViewModel();
        vm.Increment();
        vm.Increment();
        vm.Reset();
        Assert.Equal(0, vm.Count);
    }

    [Fact]
    public void PropertyChanged_FiresOnIncrement()
    {
        var vm = new MainViewModel();
        var changed = new List<string?>();
        vm.PropertyChanged += (_, e) => changed.Add(e.PropertyName);

        vm.Increment();

        Assert.Contains("Count", changed);
        Assert.Contains("CountText", changed);
    }
}
