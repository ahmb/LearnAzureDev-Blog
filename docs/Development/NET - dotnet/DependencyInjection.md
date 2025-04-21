---
title: Dependency Injection

tags:
  - DI
  - Dependency Injection
  - Best Practices
---


# Dependency Injection: Constructor vs Manual Resolution

### Key Considerations

| Category         | Constructor Injection                        | Manual Resolution (`IServiceProvider`)                    |
|------------------|----------------------------------------------|------------------------------------------------------------|
| **Performance**  | ✅ Optimal (resolve once)                     | ❌ Overhead per resolution                                 |
| **Memory Safety**| ✅ Automatic disposal                         | ❌ Risk of leaks if `using` is omitted                     |
| **Testability**  | ✅ Easy (inject mocks)                        | ❌ Harder (mock `IServiceProvider`)                        |
| **Code Clarity** | ✅ Explicit dependencies                      | ❌ Hidden dependencies                                     |
| **Use Case Fit** | Default choice for most scenarios            | Edge cases (e.g., dynamic/resolved-at-runtime)            |


## Example: Constructor Injection (Recommended)

```csharp
public class EmailService
{
    private readonly ILogger<EmailService> _logger;

    public EmailService(ILogger<EmailService> logger)
    {
        _logger = logger;
    }

    public void SendEmail(string recipient)
    {
        _logger.LogInformation($"Sending email to {recipient}");
    }
}
```

✅ Good For:
- **Web API Controllers**
- **Background services**
- **Unit testing with mock dependencies**

❌ Not Ideal When:
- You need **runtime flexibility** or **conditional resolution** of services


## Example: Manual Resolution via `IServiceProvider`

```csharp
public class DynamicServiceConsumer
{
    private readonly IServiceProvider _provider;

    public DynamicServiceConsumer(IServiceProvider provider)
    {
        _provider = provider;
    }

    public void Execute()
    {
        using var scope = _provider.CreateScope();
        var emailService = scope.ServiceProvider.GetRequiredService<EmailService>();
        emailService.SendEmail("test@example.com");
    }
}
```

✅ Good For:
- **Factories**
- **Plugins**
- **Background tasks where service types vary**

❌ Not Ideal When:
- You want **testable, clear, and maintainable** code

---
