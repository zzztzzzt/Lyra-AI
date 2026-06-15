module CreatePaletteBatchesAndPalettes

import SearchLight

function up()
    SearchLight.query("""
    CREATE TABLE IF NOT EXISTS palette_batches (
        id           SERIAL PRIMARY KEY,
        submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
    """)

    SearchLight.query("""
    CREATE TABLE IF NOT EXISTS palettes (
        id         SERIAL PRIMARY KEY,
        batch_id   INTEGER NOT NULL REFERENCES palette_batches(id) ON DELETE CASCADE,
        colors     JSONB   NOT NULL,
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
    """)

    SearchLight.query("CREATE INDEX IF NOT EXISTS idx_palettes_batch_id ON palettes(batch_id);")
end

function down()
    SearchLight.query("DROP TABLE IF EXISTS palettes;")
    SearchLight.query("DROP TABLE IF EXISTS palette_batches;")
end

end # module CreatePaletteBatchesAndPalettes