using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Caching.Memory;
using TypeAheadApi.Models;

namespace TypeAheadApi.Services;

public class CustomerTypeaheadService : ICustomerTypeaheadService
{
    private readonly IConfiguration _config;
    private readonly IMemoryCache _cache;
    private readonly ILogger<CustomerTypeaheadService> _logger;
    private static readonly TimeSpan CacheTtl = TimeSpan.FromSeconds(30);
    private const int MinQueryLengthEmail = 2;
    private const int MinQueryLengthName = 3;
    private const int DbCommandTimeout = 5;
    private const string StoredProcedure = "dbo.usp_CustomerTypeahead";

    public CustomerTypeaheadService(IConfiguration config, IMemoryCache cache, ILogger<CustomerTypeaheadService> logger)
    {
        _config = config;
        _cache = cache;
        _logger = logger;
    }

    public async Task<TypeaheadItem[]> SearchAsync(string query, int limit, CancellationToken ct)
    {
        var q = (query ?? string.Empty).Trim();
        var lim = Math.Clamp(limit, 1, 50);

        if (IsTooShort(q))
            return Array.Empty<TypeaheadItem>();

        var cacheKey = GenerateCacheKey(q, lim);
        if (_cache.TryGetValue(cacheKey, out TypeaheadItem[] cached))
            return cached;

        var cs = _config.GetConnectionString("Sql");
        if (string.IsNullOrWhiteSpace(cs))
            throw new InvalidOperationException("Missing ConnectionStrings:Sql in appsettings.json");

        var results = await ExecuteSearchAsync(cs, q, lim, ct);
        _cache.Set(cacheKey, results, new MemoryCacheEntryOptions { AbsoluteExpirationRelativeToNow = CacheTtl });
        return results;
    }

    private async Task<TypeaheadItem[]> ExecuteSearchAsync(string connectionString, string query, int limit, CancellationToken ct)
    {
        var results = new List<TypeaheadItem>(limit);

        try
        {
            await using var conn = new SqlConnection(connectionString);
            await conn.OpenAsync(ct);

            await using var cmd = new SqlCommand(StoredProcedure, conn)
            {
                CommandType = CommandType.StoredProcedure,
                CommandTimeout = DbCommandTimeout
            };

            cmd.Parameters.Add(new SqlParameter("@q", SqlDbType.NVarChar, 64) { Value = query });
            cmd.Parameters.Add(new SqlParameter("@limit", SqlDbType.Int) { Value = limit });

            await using var reader = await cmd.ExecuteReaderAsync(CommandBehavior.SequentialAccess, ct);

            var ordId = reader.GetOrdinal("CustomerId");
            var ordDisplay = reader.GetOrdinal("DisplayText");
            var ordSecondary = reader.GetOrdinal("SecondaryText");

            while (await reader.ReadAsync(ct))
            {
                var id = reader.GetInt64(ordId);
                var display = reader.IsDBNull(ordDisplay) ? "" : reader.GetString(ordDisplay);
                var secondary = reader.IsDBNull(ordSecondary) ? "" : reader.GetString(ordSecondary);
                results.Add(new TypeaheadItem(id, display, secondary));
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Database search failed for query: {Query}", query);
            throw;
        }

        return results.ToArray();
    }

    private static string GenerateCacheKey(string query, int limit) => 
        $"cust:ta:{query.ToUpperInvariant()}:{limit}";

    private static bool IsTooShort(string q) =>
        q.Contains('@') ? q.Length < MinQueryLengthEmail : q.Length < MinQueryLengthName;
}
