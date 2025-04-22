---
title: Performance

tags:
  - .NET
  - Microsoft Recommended
  - Best Practices
---

## Built-in  Types
---

### DateTime

- Do NOT use DateTime.Now() as it determines the current time and then translates it to the system timezone. Instead use `DateTime.UtcNow`. Better yet, create a simple wrapper class so its possible to inject it and configure it with a timezone.

---

### Nulls

- Do not use Null Coalescing fallbacks which allocate memory, instead use Enumerable.Empty<T>() and Array.Empty<T>().

| Method                | Description                                                  | Allocates New Memory? |
|----------------------|--------------------------------------------------------------|------------------------|
| `Enumerable.Empty<T>()` | Returns a cached, reusable empty `IEnumerable<T>`          | ❌ No                  |
| `Array.Empty<T>()`      | Returns a cached, reusable empty `T[]`                     | ❌ No                  |
| `new T[0]`              | Creates a **new empty array** each time                    | ✅ Yes                 |
| `new List<T>`           | Creates a **new empty List** each time                     | ✅ Yes                 |

Examples:
```csharp
string[]? names = GetNamesOrNull();

// Safer fallback
foreach (var name in names ?? Array.Empty<string>())
{
    Console.WriteLine(name);
}
```


```csharp
public void ProcessData(IEnumerable<int>? data = null)
{
    foreach (var number in data ?? Enumerable.Empty<int>())
    {
        Console.WriteLine(number);
    }
}
```

When to Use Which?

- ✅ `Enumerable.Empty<T>()`: when your logic depends on `IEnumerable<T>` (e.g., LINQ).
- ✅ `Array.Empty<T>()`: when you need a real array (e.g., indexing, passing to APIs expecting `T[]`).


---

### String

- Use String.Conact() instead of manually appending to the string with "+"

Using String.Concat("this", "is", "a", "string") is generally more efficient than using the + operator repeatedly, especially in loops or when concatenating many strings.

That's because + creates intermediate string objects for each operation, while String.Concat directly combines them in one go, reducing memory allocations and improving performance.