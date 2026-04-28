# Context length — a different reading

Source: conference talk notes, May 2024

Recent work on positional encodings (RoPE variants, ALiBi) substantially closes the
U-shaped recall gap. In benchmarks designed by the model providers, 128 k context models
retrieve with near-uniform accuracy across the full window.

The practical upshot: structured retrieval adds latency and complexity. For many workloads
a single long-context pass outperforms a retrieval pipeline because retrieval introduces
its own error modes (chunking artifacts, embedding drift).

Conclusion: long context *is* a viable substitute for structured retrieval in low-latency
production settings.
