# MVVM pattern

Structuring native desktop apps with Model-View-ViewModel.

## The three layers

### Model
Data and business logic. No UI knowledge.
```csharp
public class TodoItem
{
    public string Id { get; set; } = Guid.NewGuid().ToString();
    public string Title { get; set; } = "";
    public bool IsComplete { get; set; }
}
```

### ViewModel
Presentation logic. Exposes data and commands for the View. Testable without UI.
```csharp
public partial class TodoViewModel : ObservableObject
{
    [ObservableProperty]
    private ObservableCollection<TodoItem> items = new();

    [ObservableProperty]
    private string newItemTitle = "";

    [RelayCommand]
    private void AddItem()
    {
        if (string.IsNullOrWhiteSpace(NewItemTitle)) return;
        Items.Add(new TodoItem { Title = NewItemTitle });
        NewItemTitle = "";
    }
}
```

### View
UI markup (XAML or declarative). Binds to ViewModel properties and commands.
```xml
<Entry Text="{Binding NewItemTitle}" Placeholder="New item..." />
<Button Text="Add" Command="{Binding AddItemCommand}" />
<CollectionView ItemsSource="{Binding Items}">
    <CollectionView.ItemTemplate>
        <DataTemplate>
            <Label Text="{Binding Title}" />
        </DataTemplate>
    </CollectionView.ItemTemplate>
</CollectionView>
```

## Why MVVM

- **Testability** — ViewModels have no UI dependency, so you can unit test all logic
- **Separation** — designers can work on Views while developers work on ViewModels
- **Reuse** — ViewModels can be shared across platforms (Windows, macOS, mobile)

## CommunityToolkit.Mvvm

Use `CommunityToolkit.Mvvm` (NuGet) to eliminate MVVM boilerplate:
- `[ObservableProperty]` — auto-generates `INotifyPropertyChanged` implementation
- `[RelayCommand]` — auto-generates `ICommand` from a method
- Source generators, not reflection — no runtime cost

```bash
dotnet add package CommunityToolkit.Mvvm
```

## Testing ViewModels

```csharp
[Fact]
public void AddItem_WithTitle_AddsToCollection()
{
    var vm = new TodoViewModel();
    vm.NewItemTitle = "Buy milk";
    vm.AddItemCommand.Execute(null);

    Assert.Single(vm.Items);
    Assert.Equal("Buy milk", vm.Items[0].Title);
}

[Fact]
public void AddItem_EmptyTitle_DoesNotAdd()
{
    var vm = new TodoViewModel();
    vm.NewItemTitle = "";
    vm.AddItemCommand.Execute(null);

    Assert.Empty(vm.Items);
}
```
