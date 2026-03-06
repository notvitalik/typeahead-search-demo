using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using TypeAheadApi.Models;
using TypeAheadApi.Services;

var builder = WebApplication.CreateBuilder(args);

// Configure logging early so build/startup errors are visible
builder.Logging.ClearProviders();
builder.Logging.AddConsole();
builder.Logging.AddDebug();

// Register services BEFORE Build()
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddMemoryCache();
builder.Services.AddHealthChecks();
builder.Services.AddScoped<ICustomerTypeaheadService, CustomerTypeaheadService>();
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", p => p.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

WebApplication app;
try
{
    app = builder.Build();
}
catch (Exception ex)
{
    // If build fails, try to log to console and a file so the root cause is visible
    using var lf = LoggerFactory.Create(lb => { lb.AddConsole(); lb.AddDebug(); });
    var log = lf.CreateLogger("HostBuild");
    log.LogCritical(ex, "Host build failed");
    try
    {
        Directory.CreateDirectory("logs");
        File.AppendAllText(Path.Combine("logs", "host-errors.log"), DateTime.UtcNow.ToString("o") + " BUILD FAILED: " + ex + Environment.NewLine);
    }
    catch { }
    throw;
}

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseExceptionHandler("/error");
}

app.UseHttpsRedirection();
app.UseCors("AllowAll");
app.UseDefaultFiles();
app.UseStaticFiles();

app.MapGet("/error", (HttpContext http) => Results.Problem("An internal server error occurred"))
   .ExcludeFromDescription();

app.MapHealthChecks("/health");

if (app.Environment.IsDevelopment())
{
    app.MapGet("/debug/csb", ([FromServices] IConfiguration config) =>
    {
        var cs = config.GetConnectionString("Sql");
        if (string.IsNullOrWhiteSpace(cs)) return Results.Problem("Missing ConnectionStrings:Sql");

        var csb = new SqlConnectionStringBuilder(cs);
        return Results.Ok(new { csb.DataSource, csb.InitialCatalog });
    });

    app.MapGet("/debug/sqlping", async ([FromServices] IConfiguration config, CancellationToken ct) =>
    {
        var cs = config.GetConnectionString("Sql");
        if (string.IsNullOrWhiteSpace(cs)) return Results.Problem("Missing ConnectionStrings:Sql");

        try
        {
            await using var conn = new SqlConnection(cs);
            await conn.OpenAsync(ct);

            await using var cmd = new SqlCommand("SELECT @@SERVERNAME, DB_NAME(), @@VERSION", conn);
            await using var r = await cmd.ExecuteReaderAsync(ct);
            await r.ReadAsync(ct);

            return Results.Ok(new
            {
                serverName = r.GetString(0),
                database = r.GetString(1),
                version = r.GetString(2)
            });
        }
        catch (Exception ex)
        {
            return Results.Problem(ex.ToString(), title: "SQL connection failed");
        }
    });
}

app.MapGet("/api/customers/typeahead", async (
    [FromQuery] string q,
    [FromQuery] int? limit,
    [FromServices] ICustomerTypeaheadService service,
    CancellationToken ct) =>
{
    try
    {
        var results = await service.SearchAsync(q, limit ?? 10, ct);
        return Results.Ok(results);
    }
    catch (OperationCanceledException)
    {
        return Results.StatusCode(StatusCodes.Status408RequestTimeout);
    }
    catch (Exception ex)
    {
        return Results.Problem(ex.Message);
    }
})
.WithName("CustomerTypeahead")
.Produces<TypeaheadItem[]>();

try
{
    app.Run();
}
catch (Exception ex)
{
    // Log runtime exceptions to console and file
    try
    {
        var logger = app.Services.GetService<ILogger<Program>>() ?? LoggerFactory.Create(lb => lb.AddConsole()).CreateLogger("HostRun");
        logger.LogCritical(ex, "Host terminated unexpectedly");
    }
    catch { }

    try
    {
        Directory.CreateDirectory("logs");
        File.AppendAllText(Path.Combine("logs", "host-errors.log"), DateTime.UtcNow.ToString("o") + " RUN FAILED: " + ex + Environment.NewLine);
    }
    catch { }

    throw;
}
