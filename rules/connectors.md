# Connector capabilities log
Canonical cross-project record of what connectors/MCPs/APIs can and can't do, with how + when each was verified. Verify (context7 docs + live probe) before trusting; re-verify stale entries. Never write a capability from memory.
## Notion - two connectors, not interchangeable
### Workspace connector (clark@bizzabo, hosted Notion MCP) - DEFAULT for all Notion work
- Decision (2026-06-15): Notion automation stays on the clark@bizzabo account. The personal Notion connector is NOT used.
- Write/create/update: works (create-pages, update-page, create-database via SQL DDL, update-data-source incl. rename via title, move-pages, duplicate-page).
- Read one row by ID: reliable (notion-fetch by page ID). This is the dependable read path.
- Read a DB's schema: yes; its rows: no (notion-fetch on a database/data-source returns schema only).
- Enumerate a DB's rows: NOT reliably. The only row-search is notion-search, which is semantic, capped ~25, and does NOT reliably honor the data_source scope (live test: querying Knowledge returned Chapter rows). It can find a known row by title; it cannot list a DB.
- POST /v1/data_sources/{id}/query (the real deterministic list-all-rows): exists in the REST API but is NOT exposed by this connector.
### Bulk enumeration on the work account (when needed)
- Create a Notion internal integration INSIDE the clark@bizzabo workspace, share the target page to it, and have a script call POST /v1/data_sources/{id}/query (page_size <= 100, cursor). This is the work-account-native way to get the query endpoint. Do not use the personal Notion connector.
### Personal connector (notion-personal) - not used
- Exposes the REST query endpoint but is 401 (invalid token), and per decision above we don't use it. Kept as a factual note only.
## Google Slides (google-workspace connector)
- Copy a deck (slides_create_from_template / drive_copy_file), global text replace (slides_replace_text), read (slides_get_info). No per-slide add/delete/reorder/duplicate and no batchUpdate - those need the raw Slides API via a bound Apps Script. Renders Google Fonts only. Verified 2026-06-07 to 11.
(Add other connectors as their real limits are verified - probe first, never from memory.)
