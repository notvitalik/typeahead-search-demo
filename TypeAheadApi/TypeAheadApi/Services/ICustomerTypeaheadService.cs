using TypeAheadApi.Models;

namespace TypeAheadApi.Services;

public interface ICustomerTypeaheadService
{
    Task<TypeaheadItem[]> SearchAsync(string query, int limit, CancellationToken ct);
}
