module PaletteStore

using SearchLight, JSON, DataFrames

import SearchLightPostgreSQL.LibPQ

export store_palette_batch

# Constants

const MAX_BATCHES = 2

# Public API

"""
    store_palette_batch(payload::AbstractDict)

Persists a palette batch from the incoming JSON payload using raw SQL via
SearchLight's LibPQ connection, then prunes batches older than the `MAX_BATCHES`.
"""
function store_palette_batch(payload::AbstractDict)
    conn = SearchLight.connection()

    # 1. Insert the parent batch row and get its id back
    result = LibPQ.execute(conn, "INSERT INTO palette_batches (submitted_at) VALUES (NOW()) RETURNING id;")
    batch_id = first(result)[1]

    # 2. Insert each palette as a JSONB row
    palettes = payload["palettes"]
    for p in palettes
        colors_json = JSON.json(p)
        LibPQ.execute(conn,
            "INSERT INTO palettes (batch_id, colors, created_at) VALUES (\$1, \$2::jsonb, NOW());",
            [batch_id, colors_json]
        )
    end

    println("[PaletteStore] Stored batch #$(batch_id) with $(length(palettes)) palette(s) to PostgreSQL.")

    # 3. Prune old batches (keeps only the latest MAX_BATCHES)
    old_result = LibPQ.execute(conn,
        "SELECT id FROM palette_batches ORDER BY id DESC OFFSET \$1;",
        [MAX_BATCHES]
    )

    old_ids = Int[]
    for row in old_result
        push!(old_ids, row[1])
    end

    if !isempty(old_ids)
        # Build the ANY($1::int[]) string
        ids_str = "{" * join(old_ids, ",") * "}"
        # ON DELETE CASCADE handles the child palettes rows automatically
        LibPQ.execute(conn,
            "DELETE FROM palette_batches WHERE id = ANY(\$1::int[]);",
            [ids_str]
        )
        println("[PaletteStore] Pruned $(length(old_ids)) old batch(es) from PostgreSQL " *
                "(keeping the latest $(MAX_BATCHES)). IDs removed: $(join(old_ids, ", "))")
    end
end

end # module PaletteStore
